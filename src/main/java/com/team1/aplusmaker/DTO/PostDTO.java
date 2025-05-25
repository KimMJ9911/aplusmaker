package com.team1.aplusmaker.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostDTO {
    private Long articleId;
    private String subjectName;
    private String keywords;
    private String questionText;
    private String answerText;
    private LocalDateTime createdAt;
    private String authorNickname;
    private Long authorId;

    private Long commentCount;
    private Long likeCount;

}
