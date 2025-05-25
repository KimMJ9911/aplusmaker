package com.team1.aplusmaker.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class MemberDTO {
    private Long id;
    private String username;
    private String password;
    private String name;
    private String nickname;
    private LocalDate birth_date;
    private String email;
    private String p_check;
    private String phone;
    private String coll_auth;
}
