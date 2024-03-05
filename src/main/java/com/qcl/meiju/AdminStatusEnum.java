package com.qcl.meiju;

import lombok.Getter;


@Getter
public enum AdminStatusEnum implements CodeNumEnum {
    //3：超级管理员可以管理所有，2：管理员可以管理所有(同等身份不可以)，1：员工只可以管理菜品和订单
    SUPER_SUPER_ADMIN(0, "超级管理员"),
    SUPER_ADMIN(2, "管理员"),
    YUANGONG(1, "员工");

    private Integer code;
    private String message;

    AdminStatusEnum(Integer code, String message) {
        this.code = code;
        this.message = message;
    }

    public Integer getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
