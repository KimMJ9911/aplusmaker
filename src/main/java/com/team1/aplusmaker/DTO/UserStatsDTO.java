package com.team1.aplusmaker.DTO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserStatsDTO {
    private long problemCount;  // 문제 풀이 수
    private long postCount;     // 게시글 수
    private long commentCount;  // 댓글 수
    private long likeCount;     // 찜한 게시글 수
} 