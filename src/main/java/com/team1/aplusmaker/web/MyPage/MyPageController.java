package com.team1.aplusmaker.web.MyPage;

import com.team1.aplusmaker.DTO.MyPageDTO;
import com.team1.aplusmaker.DTO.PasswordChangeDTO;
import com.team1.aplusmaker.domain.Articles.Articles;
import com.team1.aplusmaker.domain.Likes.Likes;
import com.team1.aplusmaker.domain.Likes.LikesRepository;
import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.Member.MemberRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Transactional
@RequestMapping("mypage")
public class MyPageController {
    private final PasswordEncoder passwordEncoder;
    private final MyPageService myPageService;
    private final MemberRepository memberRepository;
    private final LikesRepository likesRepository;
    /**
     * 이해를 돕기 위해 간단한 타임리프 인터페이스를 my_page.html 이 아닌 mypage.html에 맞춰 구동하도록 만들었습니다.
     * 참고 하시면서 연결해 주시면 감사하겠습니다.
     */

    @GetMapping("")
    public String myPage(
            Authentication authentication,
            @RequestParam(name = "showFavorites", required = false, defaultValue = "false") boolean showFavorites,
            Model model) {

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId = memberRepository.findIdByUsername(username);
        Member member = memberRepository.findById(userId).orElse(null);

        // 기본 프로필 정보 로드
        MyPageDTO dto = myPageService.getProfile(username);
        model.addAttribute("profile", dto);
        model.addAttribute("passwordChangeDto", new PasswordChangeDTO());
        model.addAttribute("user", member);
        
        // 사용자 활동 통계 로드
        model.addAttribute("stats", myPageService.getUserStats(userId));

        // 찜한 게시글 목록 (요청 시에만 로드)
        if (showFavorites) {
            List<Likes> likeList = likesRepository.findTop10ByUserIdOrderByCreatedAtDesc(userId);
            List<Articles> favorites = new ArrayList<>();
            for (Likes like : likeList) {
                favorites.add(like.getArticle());
            }
            model.addAttribute("favorites", favorites);
            model.addAttribute("showFavorites", true);
        }

        return "mypage";
    }
    @PostMapping("")
    public String updateProfile(Authentication authentication ,
                                @ModelAttribute("profile") MyPageDTO dto,
                                Model model) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Member member = memberRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException(username));
        myPageService.updateUserProfile(userDetails.getUsername() , dto);
        model.addAttribute("profile", dto);
        model.addAttribute("success", "개인정보가 수정되었습니다.");
        model.addAttribute("passwordChangeDto", new PasswordChangeDTO()); // 비번 변경 폼용
        model.addAttribute("user", member); //인사용..
        return "/mypage";
    }

    @PostMapping("/password")
    public String changePassword(Authentication authentication ,
                                 @ModelAttribute("passwordChangeDto") PasswordChangeDTO dto,
                                 Model model) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Member member = memberRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException(username));
        try {
            myPageService.changePassword(userDetails.getUsername(), dto);
            model.addAttribute("pwSuccess", "비밀번호가 변경되었습니다.");
        } catch (Exception e) {
            model.addAttribute("pwError", e.getMessage());
        }
        // 폼 초기화 및 기존 정보 전달
        model.addAttribute("profile", myPageService.getProfile(userDetails.getUsername()));
        model.addAttribute("passwordChangeDto", new PasswordChangeDTO());
        model.addAttribute("user", member); //인사용..
        return "/mypage";
    }

}
