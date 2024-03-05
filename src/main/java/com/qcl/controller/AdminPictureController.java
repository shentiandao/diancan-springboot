package com.qcl.controller;

import com.qcl.api.ResultVO;
import com.qcl.bean.AdminInfo;
import com.qcl.bean.PictureInfo;
import com.qcl.global.GlobalConst;
import com.qcl.meiju.AdminStatusEnum;
import com.qcl.repository.AdminRepository;
import com.qcl.yichang.DianCanException;
import com.qcl.request.PictureForm;
import com.qcl.repository.PictureRepository;
import com.qcl.utils.ApiUtil;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Objects;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import lombok.extern.slf4j.Slf4j;

/**
 * 用户相关
 */
@Controller
@RequestMapping("/picture")
@Slf4j
public class AdminPictureController {
    @Autowired
    AdminRepository adminRepository;
    @Autowired
    PictureRepository repository;

    /*
     * 页面相关
     * */
    @GetMapping("/list")
    public String list(HttpServletRequest req, ModelMap map) {
    //通过调用 repository.findAll() 获取所有的轮播图列表，并将其放入 ModelMap 中传递给前端页面。
        List<PictureInfo> pictures = repository.findAll();
        map.put("categoryList", pictures);
        // 校验是管理员还是员工
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(GlobalConst.COOKIE_TOKEN)) {
                    String cookieValue = cookie.getValue();
                    log.info("获取到存储的cookie={}", cookieValue);
                    if (!StringUtils.isEmpty(cookieValue)) {
                        AdminInfo adminInfo = adminRepository.findByAdminId(Integer.parseInt(cookieValue));
                        if (adminInfo != null && (Objects.equals(AdminStatusEnum.SUPER_ADMIN.getCode(), adminInfo.getAdminType()) || Objects.equals(AdminStatusEnum.SUPER_SUPER_ADMIN.getCode(), adminInfo.getAdminType()))) {
                            map.put("isAdmin", true);
                        }
                    }
                }
            }
        }
        AdminInfo admin = (AdminInfo) req.getSession().getAttribute("admin");
        if (admin == null) {
            // 如果admin对象是null，重定向用户到登录页面
            // return "redirect:/diancan/loginView";
            return "redirect:/BFFXHT";
        }
        // 将管理员的信息添加到模型中
        map.addAttribute("admin", admin);
        return "picture/list";
    }

    @GetMapping("/index")
    public String index(@RequestParam(value = "picId", required = false) Integer picId,HttpServletRequest req,
                        ModelMap map) {
        PictureInfo picture = repository.findByPicId(picId);
        map.put("category", picture);

        /**
         * 2023年12月3日
         * 防止员工地址绕弯进入修改界面
         */
         // 获取当前登录的管理员的adminId
        Integer currentAdminId = null;
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(GlobalConst.COOKIE_TOKEN)) {
                    String cookieValue = cookie.getValue();
                    if (!StringUtils.isEmpty(cookieValue)) {
                        currentAdminId = Integer.parseInt(cookieValue);
                    }
                }
            }
        }

        // 判断当前登录的管理员是否有权限修改选定的管理员信息
        boolean canEdit = false;
        if (currentAdminId != null) {
            AdminInfo currentAdminInfo = adminRepository.findByAdminId(currentAdminId);
            if (currentAdminInfo != null && 
                (currentAdminInfo.getAdminType() == AdminStatusEnum.SUPER_ADMIN.getCode() || 
                currentAdminInfo.getAdminType() == AdminStatusEnum.SUPER_SUPER_ADMIN.getCode())) {
                // 当前登录的管理员是超级管理员或管理员
                canEdit = true;
            }
        }
        map.put("canEdit", canEdit);


        AdminInfo admin = (AdminInfo) req.getSession().getAttribute("admin");
        if (admin == null) {
            // 如果admin对象是null，重定向用户到登录页面
            // return "redirect:/diancan/loginView";
            return "redirect:/BFFXHT";
        }
        // 将管理员的信息添加到模型中
        map.addAttribute("admin", admin);
        return "picture/index";
    }

    //删除轮播图
    @GetMapping("/remove")
    public String remove(@RequestParam(value = "picId", required = false) Integer picId,
                         ModelMap map) {
        repository.deleteById(picId);
        map.put("url", "/diancan/picture/list");
        return "Tip/success";
    }

    //保存/更新
    @PostMapping("/save")
    public String save(@Valid PictureForm form,
                       BindingResult bindingResult,
                       ModelMap map) {
        log.info("SellerForm={}", form);
        if (bindingResult.hasErrors()) {
            map.put("msg", bindingResult.getFieldError().getDefaultMessage());
            map.put("url", "/diancan/picture/index");
            return "Tip/error";
        }
        PictureInfo picture = new PictureInfo();
        try {
            if (form.getPicId() != null) {
                picture = repository.findByPicId(form.getPicId());
            }
            BeanUtils.copyProperties(form, picture);
            repository.save(picture);
        } catch (DianCanException e) {
            map.put("msg", e.getMessage());
            map.put("url", "/diancan/picture/index");
            return "Tip/error";
        }

        map.put("url", "/diancan/picture/list");
        return "Tip/success";
    }


    /*
     * 返回json给小程序
     * */
    @GetMapping("/getAll")
    @ResponseBody
    public ResultVO getUserInfo() {
        List<PictureInfo> pictures = repository.findAll();
        return ApiUtil.success(pictures);
    }

}
