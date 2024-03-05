package com.qcl.bean;

import lombok.Data;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.Id;
import java.math.BigDecimal;


@Entity
@Data
@EntityListeners(AuditingEntityListener.class)
public class TotalMoney {
    @Id
    private String time;
    private BigDecimal totalMoney;
}
