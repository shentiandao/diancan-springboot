package com.qcl.controller;

import com.qcl.bean.AdminInfo;
import com.qcl.global.GlobalConst;
import com.qcl.meiju.AdminStatusEnum;
import com.qcl.request.AdminForm;
import com.qcl.repository.AdminRepository;
import com.qcl.yichang.DianCanException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;
import java.util.Objects;

@Controller
@RequestMapping("/admin")
@Slf4j
public class AdminController {

    @Autowired
    AdminRepository repository;

    //管理员页面相关
    @GetMapping("/list")
    public String list(HttpServletRequest request, ModelMap map) {
        List<AdminInfo> adminList = repository.findAll();
        map.put("adminList", adminList);

        // 校验是管理员还是员工
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(GlobalConst.COOKIE_TOKEN)) {
                    String cookieValue = cookie.getValue();
                    log.info("获取到存储的cookie={}", cookieValue);
                    if (!StringUtils.isEmpty(cookieValue)) {
                        AdminInfo adminInfo = repository.findByAdminId(Integer.parseInt(cookieValue));
                        if (adminInfo != null && (Objects.equals(AdminStatusEnum.SUPER_ADMIN.getCode(), adminInfo.getAdminType()) || Objects.equals(AdminStatusEnum.SUPER_SUPER_ADMIN.getCode(), adminInfo.getAdminType()))) {
                            map.put("isAdmin", true);
                        }
                    }
                }
            }
        }
        AdminInfo admin = (AdminInfo) request.getSession().getAttribute("admin");
        if (admin == null) {
            // 如果admin对象是null，重定向用户到登录页面
            // return "redirect:/diancan/loginView";
            return "redirect:/BFFXHT";
        }
        // 将管理员的信息添加到模型中
        map.addAttribute("admin", admin);
        return "admin/list";
    }

    /**
     * 管理员添加页面，防止普通员工通过指定地址绕弯
     */

    //查询
    @GetMapping("/search/{adminId}")
    @ResponseBody
    public AdminInfo searchAdmin(@PathVariable("adminId") Integer adminId) {
        AdminInfo adminInfo = repository.findByAdminId(adminId);
        return adminInfo;
    }

    //管理员详情页
    @GetMapping("/index")
public String index(@RequestParam(value = "adminId", required = false) Integer adminId,
                    HttpServletRequest request,
                    ModelMap map) {
    AdminInfo adminInfo;
    if (adminId == null) {
        adminInfo = new AdminInfo();
    } else {
        adminInfo = repository.findByAdminId(adminId);
    }
    map.put("adminInfo", adminInfo);
    map.put("enums", AdminStatusEnum.values());
    log.error("管理员枚举={}", AdminStatusEnum.values());

    // 获取当前登录的管理员的adminId
    Integer currentAdminId = null;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals(GlobalConst.COOKIE_TOKEN)) {
                String cookieValue = cookie.getValue();
                log.info("获取到存储的cookie={}", cookieValue);
                if (!StringUtils.isEmpty(cookieValue)) {
                    currentAdminId = Integer.parseInt(cookieValue);
                }
            }
        }
    }

    // 判断当前登录的管理员是否有权限修改选定的管理员信息
    boolean canEdit = false;
    if (currentAdminId != null) {
        AdminInfo currentAdminInfo = repository.findByAdminId(currentAdminId);
        if (currentAdminInfo != null) {
            if (currentAdminInfo.getAdminType() == AdminStatusEnum.SUPER_SUPER_ADMIN.getCode()) {
                // 超级管理员可以编辑任何人的信息
                canEdit = true;
            } else if (currentAdminInfo.getAdminType() == AdminStatusEnum.SUPER_ADMIN.getCode()) {
                // 管理员可以编辑普通员工和自己的信息
                if (adminId == null || adminId.equals(currentAdminId)) {
                    canEdit = true;
                } else {
                    AdminInfo adminToEdit = repository.findByAdminId(adminId);
                    if (adminToEdit != null && adminToEdit.getAdminType() == AdminStatusEnum.YUANGONG.getCode()) {
                        canEdit = true;
                    }
                }
            }
        }
    }
    map.put("canEdit", canEdit);

    return "admin/index";
}

    //保存/更新
    @PostMapping("/save")
    public String save(@Valid AdminForm form,
                       BindingResult bindingResult,
                       ModelMap map,
                       HttpServletRequest request) {
                        //        if (currentAdmin == null || !currentAdmin.getAdminStatusEnum().equals(AdminStatusEnum.SUPER_SUPER_ADMIN)) {
        
        // 获取当前登录的管理员的信息
        AdminInfo currentAdmin = (AdminInfo) request.getSession().getAttribute("admin");
        // 检查当前登录的管理员的类型
         if (currentAdmin == null || currentAdmin.getAdminType() != AdminStatusEnum.SUPER_SUPER_ADMIN.getCode()) {
        if (form.getAdminId() != null) {
            AdminInfo adminToModify = repository.findByAdminId(form.getAdminId());
            // 如果尝试修改的是管理员或超级管理员的信息，且当前登录的不是超级管理员，则拒绝
            if (adminToModify != null && 
                (adminToModify.getAdminType() == AdminStatusEnum.SUPER_ADMIN.getCode() || 
                adminToModify.getAdminType() == AdminStatusEnum.SUPER_SUPER_ADMIN.getCode()) &&
                !Objects.equals(currentAdmin.getAdminId(), form.getAdminId())) {
                map.put("msg", "你没有权限修改这个管理员的信息");
                map.put("url", "/diancan/admin/index");
                return "Tip/error";
            }
        }
    }


        log.info("SellerForm={}", form);
        if (bindingResult.hasErrors()) {
            map.put("msg", bindingResult.getFieldError().getDefaultMessage());
            map.put("url", "/diancan/admin/index");
            return "Tip/error";
        }

        // 验证账号、密码和手机号/微信是否已填写
        if (StringUtils.isEmpty(form.getUsername()) || StringUtils.isEmpty(form.getPassword()) || StringUtils.isEmpty(form.getPhone())) {
            map.put("msg", "账号、密码和手机号/微信都是必填的");
            map.put("url", "/diancan/admin/index");
            return "Tip/error";
        }
        AdminInfo admin = new AdminInfo();
        try {
            /**
             * 检查数据库中是否已经存在相同的账号
             * 修改日期:2023/10/3
             */
        AdminInfo existingAdmin = repository.findByUsername(form.getUsername());
        if (existingAdmin != null && !Objects.equals(existingAdmin.getAdminId(), form.getAdminId())) {
            map.put("msg", "账号已经被使用");
            map.put("url", "/diancan/admin/index");
            return "Tip/error";
        }

        if (form.getAdminId() != null) {
            admin = repository.findByAdminId(form.getAdminId());
        }
        BeanUtils.copyProperties(form, admin);
        repository.save(admin);
    } catch (DianCanException e) {
        map.put("msg", e.getMessage());
        map.put("url", "/diancan/admin/index");
        return "Tip/error";
    }

        map.put("url", "/diancan/admin/list");
        return "Tip/success";
    }

    //删除

    /**
     * 修改了原先管理员连其他管理员的信息都能删除的问题
     * 修改日期:2023/10/3
     * @param adminId
     * @param map
     * @param request
     * @return
     */
    // 删除管理员信息的方法
@DeleteMapping("/delete/{adminId}")
public String delete(@PathVariable("adminId") Integer adminId, ModelMap map, HttpServletRequest request) {
    AdminInfo currentAdmin = (AdminInfo) request.getSession().getAttribute("admin");
    if (currentAdmin == null) {
        return "redirect:/BFFXHT";
    }

    AdminInfo adminToDelete = repository.findByAdminId(adminId);
    if (adminToDelete == null) {
        map.put("msg", "管理员不存在");
        map.put("url", "/diancan/admin/list");
        return "Tip/error";
    }

    // 超级管理员可以删除任何人的信息
    if (currentAdmin.getAdminType() == AdminStatusEnum.SUPER_SUPER_ADMIN.getCode()) {
        repository.deleteById(adminId);
        map.put("url", "/diancan/admin/list");
        return "Tip/success";
    } else if (currentAdmin.getAdminType() == AdminStatusEnum.SUPER_ADMIN.getCode()) {
        // 管理员只能删除普通员工和自己的信息
        if (adminToDelete.getAdminType() == AdminStatusEnum.YUANGONG.getCode() || 
            Objects.equals(currentAdmin.getAdminId(), adminId)) {
            repository.deleteById(adminId);
            map.put("url", "/diancan/admin/list");
            return "Tip/success";
        } else {
            map.put("msg", "你没有权限删除这个管理员的信息");
            map.put("url", "/diancan/admin/list");
            return "Tip/error";
        }
    } else {
        map.put("msg", "你没有权限执行这个操作");
        map.put("url", "/diancan/admin/list");
        return "Tip/error";
    }
}

}


