package com.team1.aplusmaker.DTO;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
//게시글 작성 뷰에서 쓸 DTO
public class ArticleFormDTO {
    private String subjectName;
    private String keywords;
    private String questionText;
    private String answerText;
}