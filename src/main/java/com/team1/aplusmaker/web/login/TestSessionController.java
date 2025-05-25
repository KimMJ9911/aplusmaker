package com.team1.aplusmaker.web.login;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestSessionController{

    @GetMapping("/test-login")
    public String testLogin(HttpSession session) {
        // 테스트용 userId 세팅
        session.setAttribute("userId", 1L); // 또는 "user001" 같은 사용자 ID 문자열도 가능

        System.out.println("세션에 userId=1 설정 완료!");
        return "redirect:/"; // 홈으로 리다이렉트하거나 원하는 페이지로
    }
}
