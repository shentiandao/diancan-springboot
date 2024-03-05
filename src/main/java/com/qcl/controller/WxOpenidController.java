package com.qcl.controller;

import com.google.gson.Gson;
import com.qcl.api.ResultVO;
import com.qcl.bean.UserInfo;
import com.qcl.bean.WxOpenid;
import com.qcl.global.GlobalConst;
import com.qcl.push.AccessToken;
import com.qcl.utils.ApiUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

/**
 * 获取小程序用户的openid
 */
@RestController
@RequestMapping("/user")
@Slf4j
public class WxOpenidController {


    @GetMapping("/getOpenid")
    public String getUserInfo(@RequestParam("code") String code) {
        RestTemplate restTemplate = new RestTemplate();
        Map<String, String> params = new HashMap<>();
        params.put("APPID", GlobalConst.APPID);  //appid
        params.put("APPSECRET", GlobalConst.APPSECRET);  //appsecret
        params.put("CODE", code);  //code

        ResponseEntity<String> responseEntity = restTemplate.getForEntity(
                "https://api.weixin.qq.com/sns/jscode2session?appid={APPID}&secret={APPSECRET}&js_code={CODE}&grant_type=authorization_code",
                String.class, params);
        String body = responseEntity.getBody();
        WxOpenid object = new Gson().fromJson(body, WxOpenid.class);
        log.info("返回的openid={}", object);
        return object.getOpenid();
    }
}
