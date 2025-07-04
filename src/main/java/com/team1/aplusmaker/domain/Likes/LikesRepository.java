package com.team1.aplusmaker.domain.Likes;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LikesRepository extends JpaRepository<Likes, Long> {
    long countByArticle_id( Long articleId);
    boolean existsByArticle_idAndUser_Id(Long articleId, Long userId);
    List<Likes> findTop10ByUserIdOrderByCreatedAtDesc(Long userId);
    Likes findByArticle_idAndUser_Id(Long articleId, Long userId);

    @Modifying
    @Query("DELETE FROM Likes l WHERE l.article.id = :articleId")
    void deleteByArticleId(@Param("articleId") Long articleId);
    
    // 사용자별 찜한 게시글 수 카운트
    Long countByUser_Id(Long userId);
}