package com.team1.aplusmaker.domain.Articles;

import com.team1.aplusmaker.domain.Member.Member;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "articles")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class Articles {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="article_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private Member user;
    @Column(name="subject_name")
    private String subjectName;
    private String keywords;
    @Column(name="question_text")
    private String questionText;
    @Column(name="answer_text")
    private String answerText;
    @Column(name="created_at")
    private LocalDateTime createdAt;
}