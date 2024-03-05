package com.qcl.bean;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import java.util.Date;

import javax.persistence.*;

import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;


@Entity//表示它是一个JPA实体类，可以映射到数据库表中
@Data
@EntityListeners(AuditingEntityListener.class)//表示该实体类使用了审计功能，可以自动记录创建时间
//@DynamicUpdate
//@DynamicInsert
public class Comment {

    @Id
    @GeneratedValue
    private int commentId;
    private String openid;
    private String name;
    private String avatarUrl;//头像
    private String content;

    /**
     * 添加星级功能
     * 时间:2023年12月1日
     * 可用性:yes
     */
    @Column(name = "star")
    private Integer star;
    /**
     * 评论对应订单
     * 时间:2024年1月13日
     * 可用性:
     */
    @Column(name = "order_id")
    private Integer orderId;

    @CreatedDate//自动添加创建时间的注解
    private Date createTime;


}
