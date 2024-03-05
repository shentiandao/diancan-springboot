package com.qcl.controller;

import com.qcl.bean.AdminInfo;
import com.qcl.bean.Paihao;
import com.qcl.meiju.ResultEnum;
import com.qcl.push.SendWxMessage;
import com.qcl.repository.PaihaoRepository;
import com.qcl.utils.TimeUtils;
import com.qcl.yichang.DianCanException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 排号相关
 */
@Controller
@RequestMapping("/adminPaihao")
@Slf4j
public class AdminPaihaoController {

    @Autowired
    PaihaoRepository repository;
    @Autowired
    SendWxMessage wxSend;

    /*
     * 页面相关
     * */
    @GetMapping("/list")
    public String list(@RequestParam(value = "page", defaultValue = "1") Integer page,
                       @RequestParam(value = "size", defaultValue = "10") Integer size,
                       HttpServletRequest req, ModelMap map) {
        //获取小桌未入座的用户
        List<Paihao> listSmall = repository.findByDayAndRuzuoAndTypeOrderByNum(TimeUtils.getYMD(), false, 0);
        //获取大桌未入座的用户
        List<Paihao> listBig = repository.findByDayAndRuzuoAndTypeOrderByNum(TimeUtils.getYMD(), false, 1);
        PageRequest request = PageRequest.of(page - 1, size, Sort.by(Sort.Direction.DESC, "createTime"));
        Page<Paihao> paihaoPage = repository.findAll(request);
        map.put("paihaoPage", paihaoPage);
        map.put("currentPage", page);
        map.put("size", size);
        map.put("listSmall", listSmall);
        map.put("listBig", listBig);
        AdminInfo admin = (AdminInfo) req.getSession().getAttribute("admin");
        if (admin == null) {
            // 如果admin对象是null，重定向用户到登录页面
            // return "redirect:/diancan/loginView";
            return "redirect:/BFFXHT";
        }
        // 将管理员的信息添加到模型中
        map.addAttribute("admin", admin);
        return "paihao/list";
    }

    @GetMapping("/ruzhuo")
    public String ruzhuo(@RequestParam("id") int id, ModelMap map) {
        try {
            Paihao paihao = repository.findById(id).orElse(null);
            if (paihao == null) {
                throw new DianCanException(ResultEnum.PAIHAO_NOT_EXIST);
            }
            if (paihao.getRuzuo()) {
                throw new DianCanException(ResultEnum.PAIHAO_STATUS_ERROR);
            }
            paihao.setRuzuo(true);
            repository.save(paihao);
            //发送订阅消息给当前排号用户
            wxSend.pushOneUser(id);
        } catch (DianCanException e) {
            map.put("msg", e.getMessage());
            map.put("url", "/diancan/adminPaihao/list");
            return "Tip/error";
        }

        map.put("url", "/diancan/adminPaihao/list");
        return "Tip/success";
    }
    /**
     * 2023年12月17日
     * 拒绝入座
     */
    @GetMapping("/reject")
    public String reject(@RequestParam("id") int id, ModelMap map) {
        try {
            Paihao paihao = repository.findById(id).orElse(null);
            if (paihao == null) {
                throw new DianCanException(ResultEnum.PAIHAO_NOT_EXIST);
            }
            if (paihao.getRuzuo()) {
                throw new DianCanException(ResultEnum.PAIHAO_STATUS_ERROR);
            }
            paihao.setRuzuo(false);
            repository.save(paihao);
        } catch (DianCanException e) {
            map.put("msg", e.getMessage());
            map.put("url", "/diancan/adminPaihao/list");
            return "Tip/error";
        }

        map.put("url", "/diancan/adminPaihao/list");
        return "Tip/success";
    }
}
