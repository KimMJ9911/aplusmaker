package com.team1.aplusmaker.domain.Articles;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ArticlesRepository extends JpaRepository<Articles, Long> {
    // 사용자별 게시글 수 카운트
    Long countByUser_Id(Long userId);
}

