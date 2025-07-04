package com.team1.aplusmaker.web.MyPage;

import com.team1.aplusmaker.DTO.MyPageDTO;
import com.team1.aplusmaker.DTO.PasswordChangeDTO;
import com.team1.aplusmaker.DTO.UserStatsDTO;
import com.team1.aplusmaker.domain.Articles.ArticlesRepository;
import com.team1.aplusmaker.domain.Comments.CommentsRepository;
import com.team1.aplusmaker.domain.Likes.LikesRepository;
import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.Member.MemberRepository;
import com.team1.aplusmaker.domain.ProblemRecord.ProblemRecordRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;



@Service
@RequiredArgsConstructor
@Transactional
public class MyPageService {
    private final PasswordEncoder passwordEncoder;
    private final MemberRepository memberRepository;
    private final ArticlesRepository articlesRepository;
    private final CommentsRepository commentsRepository;
    private final LikesRepository likesRepository;
    private final ProblemRecordRepository problemRecordRepository;

    public MyPageDTO getProfile(String username) {
        Member member = memberRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("user not found."));

        MyPageDTO dto = new MyPageDTO();

        dto.setNickname(member.getNickname());
        dto.setName(member.getName());
        dto.setEmail(member.getEmail());
        dto.setPhone(member.getPhone());
        return dto;
    }

    public void changePassword(String username, PasswordChangeDTO dto) {
        Member member = memberRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("user not found"));
        if (!passwordEncoder.matches(dto.getCurrentPassword(), member.getPassword())) {
            throw new IllegalArgumentException("password incorrect");
        }
        member.setPassword(passwordEncoder.encode(dto.getNewPassword()));
        memberRepository.save(member);
    }

    public void updateUserProfile(String username, MyPageDTO myPageDTO) {
        Member member = memberRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("user not found."));
        member.setNickname(myPageDTO.getNickname());
        member.setName(myPageDTO.getName());
        member.setEmail(myPageDTO.getEmail());
        member.setPhone(myPageDTO.getPhone());

        member.setCollegeAuth(myPageDTO.getColl_auth());
    }
    
    /**
     * 사용자의 활동 통계를 조회합니다.
     * @param userId 사용자 ID
     * @return 사용자의 활동 통계 정보를 담은 DTO
     */
    public UserStatsDTO getUserStats(Long userId) {
        // 각 활동 수 조회
        long problemCount = problemRecordRepository.countByUserId(userId);
        long postCount = articlesRepository.countByUser_Id(userId);
        long commentCount = commentsRepository.countByUser_Id(userId);
        long likeCount = likesRepository.countByUser_Id(userId);
        
        // DTO 생성 및 반환
        return UserStatsDTO.builder()
                .problemCount(problemCount)
                .postCount(postCount)
                .commentCount(commentCount)
                .likeCount(likeCount)
                .build();
    }
    
    // 최근 활동 관련 메서드 제거됨
}
