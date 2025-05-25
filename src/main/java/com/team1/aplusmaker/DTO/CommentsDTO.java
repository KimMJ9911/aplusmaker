package com.team1.aplusmaker.DTO;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommentsDTO {
    private Long id;
    private String content;

    private String article_id; //articleId만 참조해서 테이블가져옴(fk)
}
