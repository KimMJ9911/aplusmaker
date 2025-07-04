package com.team1.aplusmaker.web.login.LoginDefault;

import com.team1.aplusmaker.DTO.MemberDTO;
import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.Member.MemberRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
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
    public String register(Model model) {
        model.addAttribute("formObject", new MemberDTO());
        return "register";
    }

    @PostMapping("register")
    public String register(@Valid MemberDTO memberDTO, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            return "register";
        }
        
        try {
            loginService.register(memberDTO);
        } catch (DataIntegrityViolationException e) {
            bindingResult.reject("registerErr", "이미 존재하는 사용자입니다");
            return "register";
        } catch (Exception e) {
            bindingResult.reject("Err", "오류가 발생했습니다");
            return "register";
        }
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
