package com.qcl.repository;

import com.qcl.bean.LoginHistory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;

public interface LoginHistoryRepository extends JpaRepository<LoginHistory, Integer> {
    /**
     * 2023年11月29日
     * 可用:角色查询、历史登录时间
     */
    Page<LoginHistory> findByRole(String role, Pageable pageable);
    Page<LoginHistory> findByLoginTimeBetween(Date start, Date end, Pageable pageable);
    Page<LoginHistory> findByRoleAndLoginTimeBetween(String role, Date start, Date end, Pageable pageable);
}
