package com.team1.aplusmaker.web;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
@RequiredArgsConstructor
public class HomeController {
    @GetMapping("")
    public String homeLogin() {
        return "/home";
    }

    @GetMapping("home-exam")
    public String homeEx() {
        return "/exam";
    }

    @GetMapping("home-posts")
    public String homeExam() {
        return "/posts";
    }

}
