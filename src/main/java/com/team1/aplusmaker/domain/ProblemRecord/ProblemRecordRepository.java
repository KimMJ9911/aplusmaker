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
}
