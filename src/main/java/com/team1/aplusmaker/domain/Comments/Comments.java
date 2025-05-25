package com.team1.aplusmaker.domain.Comments;

import com.team1.aplusmaker.domain.Articles.Articles;
import com.team1.aplusmaker.domain.Member.Member;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "comments")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class Comments {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="comment_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "article_id")
    private Articles article;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private Member user;

    private String content;
    @Column(name="created_at")
    private LocalDateTime createdAt;
}
