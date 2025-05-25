package com.team1.aplusmaker.domain.ProblemRecordGroup;

import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.ProblemRecord.ProblemRecord;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "problem_record_group")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProblemRecordGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="problem_record_group_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private Member user;

    @Column(name="create_at")
    private LocalDateTime createdAt=LocalDateTime.now();

    @Column(nullable = false)
    private String subject;
    private String keyword;

    @Column(name="question_type")
    private int questionType;

    @OneToMany(mappedBy = "group", cascade = CascadeType.ALL)
    private List<ProblemRecord> records = new ArrayList<>();
}
