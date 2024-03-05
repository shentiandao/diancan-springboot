package com.qcl.controller;

import com.qcl.bean.AdminInfo;
import com.qcl.bean.LoginHistory;
import com.qcl.repository.AdminRepository;
import com.qcl.repository.LoginHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

@Controller
@RequestMapping("/shouye")
public class AdminIndexController {
    @Autowired
    AdminRepository adminRepository;//人员接口
    @Autowired
    LoginHistoryRepository loginHistoryRepository; // 登录历史接口

    @GetMapping("/list")
    public String showHomePage(ModelMap model, HttpServletRequest request,
                            @RequestParam(value = "page", defaultValue = "1") Integer page,
                            @RequestParam(value = "size", defaultValue = "10") Integer size,
                           @RequestParam(value = "role", required = false) String role,
                           @RequestParam(value = "start", required = false)
                           @DateTimeFormat(pattern = "yyyy-MM-dd") Date start,
                           @RequestParam(value = "end", required = false)
                           @DateTimeFormat(pattern = "yyyy-MM-dd") Date end) {
        // 从session中获取管理员的信息
        AdminInfo admin = (AdminInfo) request.getSession().getAttribute("admin");
        if (admin == null) {
            // 如果admin对象是null，重定向用户到登录页面
            return "redirect:/BFFXHT";
        }
        // 将管理员的信息添加到模型中
        model.addAttribute("admin", admin);
        // 获取分页的登录历史记录
        Pageable pageable = PageRequest.of(page - 1, size, Sort.by(Sort.Direction.DESC, "loginTime"));//按照登录时间降序排序
        Page<LoginHistory> loginHistoryPage = loginHistoryRepository.findAll(pageable);
        
        /**
         * 2023年12月1日
         */

        if (role == null && (start == null || end == null)) {
            loginHistoryPage = loginHistoryRepository.findAll(pageable);
        } else if (role != null && (start == null || end == null)) {
            loginHistoryPage = loginHistoryRepository.findByRole(role, pageable);
        } else if (role == null && (start != null && end != null)) {
            loginHistoryPage = loginHistoryRepository.findByLoginTimeBetween(start, end, pageable);
        } else {
            loginHistoryPage = loginHistoryRepository.findByRoleAndLoginTimeBetween(role, start, end, pageable);
        }
        model.addAttribute("loginHistoryPage", loginHistoryPage);



        // 传递当前页码和每页记录数到模板
        model.addAttribute("currentPage", page);
        model.addAttribute("size", size);
        // 将role参数添加到模型中
        model.addAttribute("role", role);
         // 将start和end参数添加到模型中
        model.addAttribute("start", start);
        model.addAttribute("end", end);
        return "shouye/list";
    }
}