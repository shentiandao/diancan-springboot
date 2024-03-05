package com.qcl.controller;

import com.qcl.bean.AdminInfo;
import com.qcl.meiju.AdminStatusEnum;
import com.qcl.global.GlobalConst;
import com.qcl.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.util.StringUtils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.util.Objects;

@Controller
public class FoodCarController {

    @Autowired
    AdminRepository adminRepository;

    @GetMapping("/xiaoche/list")
    public ModelAndView list(HttpServletRequest request,
                            ModelMap map) {
        AdminInfo adminInfo = (AdminInfo) request.getSession().getAttribute("admin");
        boolean isAdmin = false;
        // 校验是管理员还是员工
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(GlobalConst.COOKIE_TOKEN)) {
                    String cookieValue = cookie.getValue();
                    if (!StringUtils.isEmpty(cookieValue)) {
                        adminInfo = adminRepository.findByAdminId(Integer.parseInt(cookieValue));
                        if (adminInfo != null && (Objects.equals(AdminStatusEnum.SUPER_ADMIN.getCode(), adminInfo.getAdminType()) || Objects.equals(AdminStatusEnum.SUPER_SUPER_ADMIN.getCode(), adminInfo.getAdminType()))) {
                            map.put("isAdmin", true);
                        }
                    }
                }
            }
        }
        ModelAndView mav = new ModelAndView("/xiaoche/list");
        return mav;
    }
}