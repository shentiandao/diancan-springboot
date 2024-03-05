package com.qcl.request;

import lombok.Data;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

@Data
public class UserAdminForm {
    //买家姓名
    @NotEmpty(message = "用户名必填")
    private String username;
    //买家手机号
    @NotEmpty(message = "手机号必填")
    private String phone;
    //买家微信openid
    @NotEmpty(message = "openid必填")
    private String openid;

//    @NotEmpty(message = "余额必填")
    private Long money;

    private String zhuohao;
    private String renshu;
}
