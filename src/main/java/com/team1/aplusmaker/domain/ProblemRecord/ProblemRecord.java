package com.team1.aplusmaker.domain.ProblemRecord;

import com.team1.aplusmaker.domain.ProblemRecordGroup.ProblemRecordGroup;
import com.team1.aplusmaker.domain.Problems.Problems;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "problem_records")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProblemRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="problem_record_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id")
    private ProblemRecordGroup group;

    @ManyToOne
    @JoinColumn(name = "problem_id")
    private Problems problem;
}
