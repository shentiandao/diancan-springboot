package com.qcl.repository;

import com.qcl.bean.Comment;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface CommentRepository extends JpaRepository<Comment, Integer> {
    List<Comment> findAllByOpenid(String openid);
    // 这个方法获取按照创建时间降序排序的评论
    Page<Comment> findAllByOrderByCreateTimeDesc(Pageable pageable);
    Page<Comment> findAllByOpenidOrderByCreateTimeDesc(String openid, Pageable pageable);
}
