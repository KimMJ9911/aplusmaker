package com.team1.aplusmaker.web.MyPage;

import com.team1.aplusmaker.DTO.MyPageDTO;
import com.team1.aplusmaker.DTO.PasswordChangeDTO;
import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.Member.MemberRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Transactional
public class MyPageService {
    private final PasswordEncoder passwordEncoder;
    private final MemberRepository memberRepository;

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
}
