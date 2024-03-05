package com.qcl.controller;

import com.qcl.api.ResultVO;
import com.qcl.bean.AdminInfo;
import com.qcl.bean.WxOrderRoot;
import com.qcl.global.GlobalConst;
import com.qcl.meiju.AdminStatusEnum;
import com.qcl.repository.AdminRepository;
import com.qcl.response.WxOrderResponse;
import com.qcl.meiju.ResultEnum;
import com.qcl.utils.ApiUtil;
import com.qcl.yichang.DianCanException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 卖家端订单
 */
@Controller
@RequestMapping("/adminOrder")
@Slf4j
public class AdminOrderController {
    @Autowired
    AdminRepository adminRepository;
    @Autowired
    private WxOrderUtils wxOrder;

    //订单列表
    @GetMapping("/list")
    public String list(@RequestParam(value = "page", defaultValue = "1") Integer page,
                       @RequestParam(value = "size", defaultValue = "20") Integer size,
                       @RequestParam(value = "queryDate", required = false) String queryDateStr,
                       HttpServletRequest req,
                       ModelMap map) {
        //最新的订单在最前面
        PageRequest request = PageRequest.of(page - 1, size, Sort.by(Sort.Direction.DESC, "updateTime"));
        Page<WxOrderResponse> orderDTOPage = wxOrder.findList(request);
        /**
         * 2023年11月30日
         */
        if (!StringUtils.isEmpty(queryDateStr)) {
            // 如果传递了查询日期，解析为Date类型
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date queryDate;
            try {
                queryDate = sdf.parse(queryDateStr);
            } catch (ParseException e) {
                // 处理日期解析异常
                log.error("日期解析错误", e);
                // 其他处理，比如返回错误页面
                return "error";
            }

            // 使用新添加的方法进行按日期范围查询
            orderDTOPage = wxOrder.findByDate(queryDate, request);
        } else {
            // 否则，使用原有的方法进行查询
            orderDTOPage = wxOrder.findList(request);
        }
        log.error("后台显示的订单列表={}", orderDTOPage.getTotalElements());
        log.error("后台显示的订单列表={}", orderDTOPage.getContent());
        // 创建一个Map来存储每天的总订单金额
        Map<String, BigDecimal> dailyOrderAmount = new HashMap<>();
        for (WxOrderResponse orderDTO : orderDTOPage.getContent()) {
            // 使用SimpleDateFormat将Date转换为String
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String date = sdf.format(orderDTO.getCreateTime());
            // 如果Map中已经有了这个日期，那么将新的订单金额添加到已有的金额上
            if (dailyOrderAmount.containsKey(date)) {
                dailyOrderAmount.put(date, dailyOrderAmount.get(date).add(orderDTO.getOrderAmount()));
            } else {
                // 否则，将这个日期和订单金额添加到Map中
                dailyOrderAmount.put(date, orderDTO.getOrderAmount());
            }
        }

        // 创建一个Map来存储每天的最新订单
        Map<String, WxOrderResponse> latestOrderMap = new HashMap<>();
        for (WxOrderResponse orderDTO : orderDTOPage.getContent()) {
            // 使用SimpleDateFormat将Date转换为String
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String date = sdf.format(orderDTO.getCreateTime());
            // 如果Map中已经有了这个日期，那么比较新的订单和已有的订单的创建时间，只保留最新的订单
            if (!latestOrderMap.containsKey(date) || orderDTO.getCreateTime().after(latestOrderMap.get(date).getCreateTime())) {
                latestOrderMap.put(date, orderDTO);
            }
        }


    // 将Map添加到模型中
        map.addAttribute("latestOrderMap", latestOrderMap);
        map.put("dailyOrderAmount", dailyOrderAmount);
        map.put("orderDTOPage", orderDTOPage);
        map.put("currentPage", page);
        map.put("size", size);
        AdminInfo admin = (AdminInfo) req.getSession().getAttribute("admin");
        if (admin == null) {
            // 如果admin对象是null，重定向用户到登录页面
            // return "redirect:/diancan/loginView";
            return "redirect:/BFFXHT";
        }
        // 将管理员的信息添加到模型中
        map.addAttribute("admin", admin);
        return "order/list";
    }

    //只有取消的订单才可以删除
    @GetMapping("/remove")
    public String remove(@RequestParam(value = "orderId", required = false) Integer orderId,
                         ModelMap map) {
        wxOrder.remove(orderId);
        map.put("url", "/diancan/adminOrder/list");
        return "Tip/success";
    }

    //取消订单
    @GetMapping("/cancel")
    public String cancel(@RequestParam("orderId") int orderId,
                         ModelMap map) {
        try {
            WxOrderResponse orderDTO = wxOrder.findOne(orderId);
            wxOrder.cancel(orderDTO);
        } catch (DianCanException e) {
            map.put("msg", e.getMessage());
            map.put("url", "/diancan/adminOrder/list");
            return "Tip/error";
        }

        map.put("msg", ResultEnum.ORDER_CANCEL_SUCCESS.getMessage());
        map.put("url", "/diancan/adminOrder/list");
        return "Tip/success";
    }

    //退菜，把某个菜品订单删除，营业额里相应减除金额
    @GetMapping("/tuicai")
    public String tuicai(@RequestParam("orderId") int orderId,
                         @RequestParam("detailId") int detailId,
                         ModelMap map) {
        try {
            wxOrder.tuicai(orderId, detailId);
        } catch (DianCanException e) {
            map.put("msg", e.getMessage());
            map.put("url", "/diancan/adminOrder/list");
            return "Tip/error";
        }

        map.put("msg", ResultEnum.ORDER_CANCEL_SUCCESS.getMessage());
        map.put("url", "/diancan/adminOrder/list");
        return "Tip/success";
    }

    //订单详情
    @GetMapping("/detail")
    public String detail(@RequestParam("orderId") int orderId,
                         HttpServletRequest req,
                         ModelMap map) {
        WxOrderResponse orderDTO = new WxOrderResponse();
        try {
            orderDTO = wxOrder.findOne(orderId);
        } catch (DianCanException e) {
            map.put("msg", e.getMessage());
            map.put("url", "/diancan/adminOrder/list");
            return "Tip/error";
        }

        map.put("orderDTO", orderDTO);
        // 校验是管理员还是员工
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(GlobalConst.COOKIE_TOKEN)) {
                    String cookieValue = cookie.getValue();
                    log.info("获取到存储的cookie={}", cookieValue);
                    if (!StringUtils.isEmpty(cookieValue)) {
                        AdminInfo adminInfo = adminRepository.findByAdminId(Integer.parseInt(cookieValue));
                        if (adminInfo != null && Objects.equals(AdminStatusEnum.SUPER_ADMIN.getCode(), adminInfo.getAdminType())) {
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
        return "order/detail";
    }

    //上菜完成订单
    @GetMapping("/finish")
    public String finished(@RequestParam("orderId") int orderId,
                           ModelMap map) {
        try {
            WxOrderResponse orderDTO = wxOrder.findOne(orderId);
            wxOrder.finish(orderDTO);
        } catch (DianCanException e) {
            map.put("msg", e.getMessage());
            map.put("url", "/diancan/adminOrder/list");
            return "Tip/error";
        }

        map.put("msg", ResultEnum.ORDER_FINISH_SUCCESS.getMessage());
        map.put("url", "/diancan/adminOrder/list");
        return "Tip/success";
    }

    //导出菜品订单到excel
    @GetMapping("/export")
    public String export(HttpServletResponse response, ModelMap map) {
        try {
            wxOrder.exportOrderToExcel(response);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msg", "导出excel失败");
            map.put("url", "/diancan/adminOrder/list");
            return "Tip/error";
        }
        map.put("url", "/diancan/adminOrder/list");
        return "Tip/success";
    }
/**
 * 2023年11月28日
 */

}
