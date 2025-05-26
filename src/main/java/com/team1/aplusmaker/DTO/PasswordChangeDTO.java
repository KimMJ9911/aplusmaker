package com.team1.aplusmaker.DTO;

import lombok.Data;

@Data
public class PasswordChangeDTO {
    private String currentPassword;
    private String newPassword;
}
