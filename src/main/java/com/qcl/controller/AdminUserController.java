package com.qcl.controller;

import com.qcl.bean.AdminInfo;
import com.qcl.bean.UserInfo;
import com.qcl.global.GlobalConst;
import com.qcl.meiju.AdminStatusEnum;
import com.qcl.repository.AdminRepository;
import com.qcl.repository.UserRepository;
import com.qcl.request.UserAdminForm;
import com.qcl.yichang.DianCanException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.math.BigDecimal;
import java.util.List;
import java.util.Objects;

/**
 * 用户管理
 */
@Controller
@RequestMapping("/adminUser")
@Slf4j
public class AdminUserController {
    @Autowired
    AdminRepository repository;

    @Autowired
    UserRepository userRepository;

    //管理员页面相关
    @GetMapping("/list")
    public String list(HttpServletRequest request, ModelMap map) {
        List<UserInfo> userList = userRepository.findAll();
        map.put("userList", userList);

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
        return "user/list";
    }

    //管理员详情页
    @GetMapping("/index")
    public String index(@RequestParam(value = "openid", required = false) String openid,
                        HttpServletRequest req,
                        ModelMap map) {
        UserInfo userInfo = userRepository.findByOpenid(openid);
        map.put("userInfo", userInfo);
        AdminInfo admin = (AdminInfo) req.getSession().getAttribute("admin");
        if (admin == null) {
            // 如果admin对象是null，重定向用户到登录页面
            // return "redirect:/diancan/loginView";
            return "redirect:/BFFXHT";
        }
        // 将管理员的信息添加到模型中
        map.addAttribute("admin", admin);
        return "user/index";
    }

    //保存/更新
    @PostMapping("/save")
    public String save(@Valid UserAdminForm form,
                       BindingResult bindingResult,
                       ModelMap map) {
        log.info("SellerForm={}", form);
        form.setMoney(form.getMoney()==null?0:form.getMoney());

        if (bindingResult.hasErrors()) {
            map.put("msg", bindingResult.getFieldError().getDefaultMessage());
            map.put("url", "/diancan/adminUser/list");
            return "Tip/error";
        }
        UserInfo userInfo = new UserInfo();
        try {

            userInfo = userRepository.findByOpenid(form.getOpenid());
//            BeanUtils.copyProperties(form, userInfo);

            userInfo.setUsername(form.getUsername());
            userInfo.setPhone((form.getPhone()));
            userInfo.setMoney(userInfo.getMoney().add(BigDecimal.valueOf(form.getMoney())));
            userRepository.save(userInfo);
        } catch (DianCanException e) {
            map.put("msg", e.getMessage());
            map.put("url", "/diancan/adminUser/list");
            return "Tip/error";
        }

        map.put("url", "/diancan/adminUser/list");
        return "Tip/success";
    }
}
