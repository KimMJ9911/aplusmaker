package com.team1.aplusmaker.web.login.LoginDefault;

import com.team1.aplusmaker.DTO.MemberDTO;
import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.Member.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

@Service
@RequiredArgsConstructor
public class LoginService {
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    public void register(MemberDTO memberDTO) {
        Member member = new Member();

        member.setUsername(memberDTO.getUsername());
        member.setPassword(passwordEncoder.encode(memberDTO.getPassword()));
        member.setName(memberDTO.getName());
        member.setNickname(memberDTO.getNickname());
        member.setEmail(memberDTO.getEmail());
        member.setPhone(memberDTO.getPhone());
        member.setBirthDate(memberDTO.getBirth_date());
        member.setEmail(memberDTO.getEmail());
        member.setCollegeAuth(memberDTO.getColl_auth());
        memberRepository.save(member);
    }


}
