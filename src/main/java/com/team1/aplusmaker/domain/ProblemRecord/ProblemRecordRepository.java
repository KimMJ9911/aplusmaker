package com.team1.aplusmaker.domain.ProblemRecord;


import com.team1.aplusmaker.domain.Problems.Problems;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProblemRecordRepository extends JpaRepository<ProblemRecord, Long> {

    @Query("SELECT r FROM ProblemRecord r JOIN FETCH r.problem WHERE r.group.id = :groupId")
    List<ProblemRecord> findByGroupId(@Param("groupId") Long groupId);

    void deleteByGroupId(Long groupId);
    
    // 사용자별 문제 풀이 수 카운트
    @Query("SELECT COUNT(pr) FROM ProblemRecord pr WHERE pr.group.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);
}
