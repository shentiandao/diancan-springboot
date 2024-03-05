package com.qcl.controller;

import com.qcl.bean.AdminInfo;
import com.qcl.bean.LoginHistory;
import com.qcl.global.GlobalConst;
import com.qcl.meiju.ResultEnum;
import com.qcl.repository.AdminRepository;
import com.qcl.repository.LoginHistoryRepository;
import com.qcl.utils.CookieUtil;
import com.qcl.yichang.DianCanException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

@Controller
@Slf4j
public class LoginAdminController {

    @Autowired
    AdminRepository repository;

    @Autowired
    LoginHistoryRepository loginHistoryRepository;


    @GetMapping("/loginAdmin")
    @ResponseBody
    public String loginAdmin(@RequestParam("phoneOrname") String phoneOrname,
                            @RequestParam("password") String password,
                            HttpServletResponse response,
                            HttpServletRequest request) {
        //这里的phoneOrname代表 手机号或者用户名
        System.out.println("执行了登录查询");
        AdminInfo admin = repository.findByPhoneOrUsername(phoneOrname, phoneOrname);
        log.info("查询到得admininfo={}", admin);
        if (admin != null && admin.getPassword().equals(password)) {
            log.info("登录成功的token={}", admin.getAdminId());//用adminid做cookie
            //有效期2小时
            CookieUtil.set(response, GlobalConst.COOKIE_TOKEN, "" + admin.getAdminId(), 7200);

            // 将管理员的信息添加到session中
            request.getSession().setAttribute("admin", admin);
            request.getSession().setMaxInactiveInterval(180 * 60);

            // 添加一条新的登录历史记录
            LoginHistory loginHistory = new LoginHistory();
            loginHistory.setUsername(admin.getUsername());
//            loginHistory.setRole(admin.getAdminType() == 1 ? "员工" : "管理员");
            switch (admin.getAdminType()) {
                case 0:
                    loginHistory.setRole("超级管理员");
                    break;
                case 1:
                    loginHistory.setRole("员工");
                    break;
                case 2:
                    loginHistory.setRole("管理员");
                    break;
                default:
                    loginHistory.setRole("未知");
            }
            loginHistory.setLoginTime(new Date());
            loginHistoryRepository.save(loginHistory);

            return "登录成功";
        } else {
            throw new DianCanException(ResultEnum.LOGIN_FAIL);
        }
    }

    @GetMapping("/logoutAdmin")
    public String logout(HttpServletRequest request,
                         HttpServletResponse response,
                         ModelMap map) {
        //1. 从cookie里查询
        Cookie cookie = CookieUtil.get(request, GlobalConst.COOKIE_TOKEN);
        if (cookie != null) {
            //2. 清除cookie
            CookieUtil.set(response, GlobalConst.COOKIE_TOKEN, null, 0);
        }
        map.put("msg", ResultEnum.LOGOUT_SUCCESS.getMessage());
        map.put("url", "/diancan/adminOrder/list");
        return "Tip/success";
    }
    @GetMapping("/BFFXHT")
    public String redirectToLogin() {
        return "zujian/loginView";
}
}