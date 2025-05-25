package com.team1.aplusmaker.domain.Problems;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProblemsRepository extends JpaRepository<Problems, Long> {
    //커스텀 해줘야함
    @Query("SELECT p FROM Problems p WHERE p.questionType = :type AND p.keywords LIKE %:keyword% ORDER BY function('RAND')")
    List<Problems> findRandomByQuestionTypeAndKeywords(
            @Param("type") int type,
            @Param("keyword") String keyword,
            Pageable pageable
    );


}