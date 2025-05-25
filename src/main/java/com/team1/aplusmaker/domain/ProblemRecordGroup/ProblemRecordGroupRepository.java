package com.team1.aplusmaker.domain.ProblemRecordGroup;

import com.team1.aplusmaker.domain.Member.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProblemRecordGroupRepository extends JpaRepository<ProblemRecordGroup, Long> {
    List<ProblemRecordGroup> findTop10ByUserOrderByCreatedAtDesc(Member user);

    List<ProblemRecordGroup> findByUser_Id(Long userId);
}
