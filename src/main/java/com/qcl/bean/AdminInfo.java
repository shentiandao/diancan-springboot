package com.qcl.bean;

import com.qcl.meiju.AdminStatusEnum;
import com.qcl.utils.EnumUtil;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.Date;
import java.util.Objects;


@Entity
@Data
@EntityListeners(AuditingEntityListener.class)
public class AdminInfo {
    @Id
    @GeneratedValue
    private Integer adminId;
    private String phone;
    private String username;
    private String password;
    private Integer adminType;//0超级管理员，1员工，2管理员
    @CreatedDate//自动添加创建时间的注解
    private Date createTime;
    @LastModifiedDate//自动添加更新时间的注解
    private Date updateTime;

    //    @Transient//忽略映射
    public AdminStatusEnum getAdminStatusEnum() {
        return EnumUtil.getByCode(this.adminType, AdminStatusEnum.class);
    }

    public boolean isSuperAdmin() {
        return Objects.equals(AdminStatusEnum.SUPER_ADMIN.getCode(), this.adminType);
    }
}
