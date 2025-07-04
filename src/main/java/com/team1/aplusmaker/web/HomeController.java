package com.team1.aplusmaker.web;

import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.Member.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Controller
@RequiredArgsConstructor
public class HomeController {
    private final MemberRepository memberRepository;
    
    @GetMapping({"/", "/home"})
    public String home(Model model) {
        // 인증 정보 확인
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        boolean isAuthenticated = authentication != null &&
                authentication.isAuthenticated() &&
                !authentication.getName().equals("anonymousUser");

        // 사용자 데이터 추가
        Map<String, String> user = new HashMap<>();
        if (isAuthenticated) {
            String username = authentication.getName();
            user.put("username", username);
            
            // 사용자의 닉네임 가져오기
            Optional<Member> memberOpt = memberRepository.findByUsername(username);
            if (memberOpt.isPresent()) {
                Member member = memberOpt.get();
                user.put("nickname", member.getNickname());
                user.put("id", String.valueOf(member.getId()));
            }
        } else {
            user.put("username", "게스트");
        }
        model.addAttribute("user", user);

        return "home";
    }
}