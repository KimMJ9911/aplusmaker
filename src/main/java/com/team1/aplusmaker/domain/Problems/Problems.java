package com.team1.aplusmaker.domain.Problems;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "problems")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class Problems {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="problem_id")
    private Long id;

    private String subject;
    private String keywords;

    @Column(name="question_text")
    private String questionText;

    @Column(name="answer_text")
    private String answerText;

    @Column(name="question_type")
    private int questionType;

    @Column(name="create_at")
    private LocalDateTime createdAt;
}
