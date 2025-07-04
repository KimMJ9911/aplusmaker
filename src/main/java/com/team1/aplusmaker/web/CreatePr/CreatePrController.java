package com.team1.aplusmaker.web.CreatePr;

import com.team1.aplusmaker.DTO.ArticleFormDTO;
import com.team1.aplusmaker.DTO.GroupSummaryDTO;
import com.team1.aplusmaker.domain.Member.*;
import com.team1.aplusmaker.domain.ProblemRecord.*;
import com.team1.aplusmaker.domain.ProblemRecordGroup.*;
import com.team1.aplusmaker.domain.Problems.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@Controller
@RequiredArgsConstructor
@Transactional
public class CreatePrController {

    private final ProblemsRepository problemsRepository;
    private final ProblemRecordGroupRepository groupRepository;
    private final ProblemRecordRepository recordRepository;
    private final MemberRepository memberRepository;

    private static final Map<Integer, String> typeNames = Map.of(
            0, "주관식",
            1, "객관식",
            2, "단답형",
            3, "O/X",
            4, "서술형"
    );

    @GetMapping("/exam")
    public String showForm(Authentication authentication , Model model) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        //유저의 아이디를 받고
        String username = userDetails.getUsername();
        //유저 아이디로 pk찾기
        Long userId= memberRepository.findIdByUsername(username);

        //멤버 객체를 id로찾아온다
        Member member = memberRepository.findByUsername(username).orElse(null);
        List<ProblemRecordGroup> groups = groupRepository.findByUser_Id(userId);

        model.addAttribute("user", member);
        model.addAttribute("results", null);
        model.addAttribute("history", toGroupSummaryDTO(groups));
        model.addAttribute("recentRecords", groups);
        model.addAttribute("group", null);
        model.addAttribute("problems", null);
        model.addAttribute("memberId", username);

        return "exam";
    }

    @PostMapping("/exam")
    public String recommendQuestions(@RequestParam int count,
                                     @RequestParam int type,
                                     @RequestParam String keyword,
                                     @RequestParam String subject,
                                     Authentication authentication,
                                     Model model) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        //유저의 아이디를 받고
        String username = userDetails.getUsername();
        //유저 아이디로 pk찾기
        Long userId= memberRepository.findIdByUsername(username);

        Member member = memberRepository.findById(userId).orElse(null);

        List<Problems> problems = problemsRepository.findRandomByQuestionTypeAndKeywords(type, keyword, count);

        ProblemRecordGroup group = new ProblemRecordGroup();
        group.setUser(member);
        group.setQuestionType(type);
        group.setKeyword(keyword);
        group.setSubject(subject);
        groupRepository.save(group);

        for (Problems p : problems) {
            ProblemRecord record = new ProblemRecord();
            record.setGroup(group);
            record.setProblem(p);
            recordRepository.save(record);
        }

        List<ProblemRecordGroup> groups = groupRepository.findByUser_Id(userId);

        model.addAttribute("user", member);
        model.addAttribute("results", problems);
        model.addAttribute("history", toGroupSummaryDTO(groups));
        model.addAttribute("recentRecords", groups);
        model.addAttribute("group", group);
        model.addAttribute("problems", problems);
        model.addAttribute("memberId", userId);
        return "exam";
    }

    @GetMapping("/exam/view/{recordId}")
    public String viewRecord(@PathVariable Long recordId, Authentication authentication, Model model) {
        // 이 과정도 중복되는데 함수화?
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId= memberRepository.findIdByUsername(username);

        //멤버 엔티티 객체 id를 통해 가져오고
        Member member = memberRepository.findById(userId).orElse(null);
        //문제 질문기록 가져오고
        List<ProblemRecord> records = recordRepository.findByGroupId(recordId);
        //그 기록에 대한 문제들 리스트로 가져오고
        List<Problems> problems = records.stream().map(ProblemRecord::getProblem).toList();

        ProblemRecordGroup group = groupRepository.findById(recordId).orElse(null);
        //중복되는거 함수화 ?
        List<ProblemRecordGroup> groups = groupRepository.findByUser_Id(userId);

        model.addAttribute("user", member);
        model.addAttribute("results", problems);
        model.addAttribute("history", toGroupSummaryDTO(groups));
        model.addAttribute("recentRecords", groups);
        model.addAttribute("group", group);
        model.addAttribute("problems", problems);
        model.addAttribute("memberId", userId);
        return "exam";
    }
    
    @GetMapping("/exam/delete/{groupId}")
    public String deleteViewGroup(@PathVariable Long groupId, Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId = memberRepository.findIdByUsername(username);

        ProblemRecordGroup group = groupRepository.findById(groupId).orElse(null);
        //비정상적인 상황
        if (group == null || !group.getUser().getId().equals(userId)) {
            return "redirect:/exam";
        }

        //그룹 안 레코드 삭제 후 그룹 삭제
        recordRepository.deleteByGroupId(groupId);
        groupRepository.delete(group);

        return "redirect:/exam";
    }
    
    @GetMapping("/exam/to-post/{groupId}")
    public String toPostFromGroup(@PathVariable Long groupId,
                                  Authentication authentication,
                                  Model model) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId = memberRepository.findIdByUsername(username);

        ProblemRecordGroup group = groupRepository.findById(groupId).orElse(null);
        if (group == null || !group.getUser().getId().equals(userId)) {
            return "redirect:/exam";
        }

        List<ProblemRecord> records = recordRepository.findByGroupId(groupId);
        List<Problems> problems = records.stream().map(ProblemRecord::getProblem).toList();

        // 그룹에 여러문제일 때, 문자열 버퍼로 이어붙여서 DTO에 주기
        StringBuilder questions = new StringBuilder();
        StringBuilder answers = new StringBuilder();
        for (int i = 0; i < problems.size(); i++) {
            Problems p = problems.get(i);
            questions.append("Q").append(i + 1).append(". ").append(p.getQuestionText()).append("\n\n");
            answers.append("A").append(i + 1).append(". ").append(p.getAnswerText()).append("\n\n");
        }
        //버퍼는 스트링으로 바꿔서주입
        ArticleFormDTO article = new ArticleFormDTO();
        article.setSubjectName(group.getSubject());
        article.setKeywords(group.getKeyword());
        article.setQuestionText(questions.toString());
        article.setAnswerText(answers.toString());
        //수정모드가 아닌곳에, if문으로 만약 값이 있다면 폼 채워서 주기
        model.addAttribute("user", group.getUser());
        model.addAttribute("editMode", false);
        model.addAttribute("article", article);

        return "postRegister";
    }


    private List<GroupSummaryDTO> toGroupSummaryDTO(List<ProblemRecordGroup> groups) {
        List<GroupSummaryDTO> result = new ArrayList<>();
        for (ProblemRecordGroup g : groups) {
            GroupSummaryDTO dto = new GroupSummaryDTO();
            dto.setId(g.getId());
            dto.setKeyword(g.getKeyword());
            dto.setSubject(g.getSubject());
            dto.setRecordTypeName(typeNames.getOrDefault(g.getQuestionType(), "기타"));
            result.add(dto);
        }
        return result;
    }
}