package com.team1.aplusmaker.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GroupSummaryDTO {
    private Long id;
    private String keyword;
    private String subject;
    private String recordTypeName;
}