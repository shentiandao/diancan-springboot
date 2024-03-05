package com.qcl.yichang;

import com.qcl.meiju.ResultEnum;


public class DianCanException extends RuntimeException{

    private Integer code;

    public DianCanException(ResultEnum resultEnum) {
        super(resultEnum.getMessage());

        this.code = resultEnum.getCode();
    }

    public DianCanException(Integer code, String message) {
        super(message);
        this.code = code;
    }
}
