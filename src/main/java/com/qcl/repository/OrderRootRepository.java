package com.qcl.repository;

import com.qcl.bean.WxOrderRoot;

import com.qcl.response.WxOrderResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;


public interface OrderRootRepository extends JpaRepository<WxOrderRoot, Integer> {


    List<WxOrderRoot> findByBuyerOpenidAndOrderStatus(String buyerOpenid, Integer orderStatus, Sort updateTime);

    List<WxOrderRoot> findAll(Specification specification);

    /**
     *2023年11月30日
     */
    // 查询指定日期范围内的订单
    List<WxOrderRoot> findByCreateTimeBetween(Date startDate, Date endDate, Sort sort);
}
