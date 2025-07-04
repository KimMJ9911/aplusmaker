package com.team1.aplusmaker.domain.Comments;

import org.springframework.data.domain.Limit;
import org.springframework.data.jpa.repository.JpaRepository;
import com.team1.aplusmaker.domain.Articles.*;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CommentsRepository extends JpaRepository<Comments, Long> {

    List<Comments> findCommentsByArticle_id(Long articleId, Limit limit);

    long countByArticle_id(@Param("articleId") Long articleId);

    @Modifying
    @Query("DELETE FROM Comments c WHERE c.article.id = :articleId")
    void deleteByArticleId(@Param("articleId") Long articleId);

    List<Comments> findCommentsByArticleId(Long articlesId);
    
    // 사용자별 댓글 수 카운트
    Long countByUser_Id(Long userId);
}
