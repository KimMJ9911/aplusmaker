package com.team1.aplusmaker.web.login.LoginDefault;

import com.team1.aplusmaker.DTO.MemberDTO;
import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.Member.MemberRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@RequestMapping("")
@Controller
@Slf4j
@RequiredArgsConstructor
public class LoginController {
    private final MemberRepository memberRepository;
    private final LoginService loginService;
    private final PasswordEncoder passwordEncoder;

    @GetMapping("login")
    public String login(@RequestParam(value = "error" , required = false) String error , Model model) {

        if (error != null) {
            model.addAttribute("loginError", error);
        }
        return "login";
    }

    @GetMapping("register")
    public String register() {
        return "register";
    }

    @PostMapping("register")
    public String register(MemberDTO memberDTO) {
        loginService.register(memberDTO);
        return "redirect:/login";
    }

    @PostMapping("logout")
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return "redirect:/login?logout";
    }

    @PostMapping("delete-user")
    public String deleteUser(@AuthenticationPrincipal Member member) {
        return "redirect:/logout";
    }
}
