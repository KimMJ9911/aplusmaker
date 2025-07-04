package com.team1.aplusmaker.web.Articles;

import com.team1.aplusmaker.DTO.PostDTO;
import com.team1.aplusmaker.domain.Articles.Articles;
import com.team1.aplusmaker.domain.Articles.ArticlesRepository;
import com.team1.aplusmaker.domain.Comments.Comments;
import com.team1.aplusmaker.domain.Comments.CommentsRepository;
import com.team1.aplusmaker.domain.Likes.Likes;
import com.team1.aplusmaker.domain.Likes.LikesRepository;
import com.team1.aplusmaker.domain.Member.Member;
import com.team1.aplusmaker.domain.Member.MemberRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Transactional
public class ArticlesController {

    private final ArticlesRepository articlesRepository;
    private final MemberRepository memberRepository;
    private final CommentsRepository commentsRepository;
    private final LikesRepository likesRepository;

    @GetMapping("/posts")
    public String showPostList(Authentication authentication, Model model) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        //유저의 아이디를 받고
        String username = userDetails.getUsername();
        //유저 아이디로 멤버 pk찾기
        Long userId= memberRepository.findIdByUsername(username);
        Member member = memberRepository.findById(userId).orElse(null);
        //createAt 기준으로 모든 게시글 찾아서 List에 넣기(역순)
        List<Articles> articles = articlesRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
        //웹에 전달을 위해 postDTO 리스트 생성
        List<PostDTO> postDTOArrayList = new ArrayList<>();
        //모든 게시글들 postDTO리스트에 넣는다(postDTO로 만들어서)
        for (Articles article : articles) {
            postDTOArrayList.add(toPostDTO(article));
        }
        //자기가 누른 찜 리스트 생성(이것도 createAt 기준 역순)
        List<Likes> likeList = likesRepository.findTop10ByUserIdOrderByCreatedAtDesc(userId);
        //찜 리스트
        List<Articles> favorites = new ArrayList<>();
        for (Likes like : likeList) {
            favorites.add(like.getArticle());
        }
        //모델에 넣어서 전달
        //찜 리스트
        model.addAttribute("favorites", favorites);
        //ㅇㅇ님 환영합니다 위해 user 객체 전달
        model.addAttribute("user", member);
        //게시글 관련 dto
        model.addAttribute("postSummaries", postDTOArrayList);


        return "posts";
    }

    @GetMapping("/posts/{articlesId}")  //
    public String viewPost(@PathVariable Long articlesId, Authentication authentication, Model model) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId= memberRepository.findIdByUsername(username);

        Member member = memberRepository.findById(userId).orElse(null);
        Articles article = articlesRepository.findById(articlesId).orElse(null);
        //게시글 찾아봤는데 없으면 리다이렉트 (이런 경우가 있나?싶긴함)
        if (article == null) return "redirect:/posts";

        List<Comments> comments = commentsRepository.findCommentsByArticleId(articlesId);
        PostDTO postDto = toPostDTO(article);

        // 좋아요 개수
        Long likeCount = likesRepository.countByArticle_id(articlesId);

        // 내가 이미 좋아요를 눌렀는지 체크
        boolean likedByMe = false;
        if (userId != null) {
            likedByMe = likesRepository.existsByArticle_idAndUser_Id(articlesId, userId);
        }

        model.addAttribute("user", member);
        model.addAttribute("postContent", postDto);
        model.addAttribute("comments", comments);
        model.addAttribute("likeCount", likeCount);
        model.addAttribute("likedByMe", likedByMe);
        return "view";
    }
    @PostMapping("/posts/{articleId}/comments") // 댓글
    public String addComment(@PathVariable Long articleId,
                             @RequestParam String content,
                             Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId= memberRepository.findIdByUsername(username);

        Member member = memberRepository.findById(userId).orElse(null);
        Articles article = articlesRepository.findById(articleId).orElse(null);
        if (article == null || member == null) return "redirect:/posts";
        //새로운 코멘트 객체 생성, 객체 셋팅 후 저장
        Comments newComment = new Comments();
        newComment.setArticle(article);
        newComment.setUser(member);
        newComment.setContent(content);
        newComment.setCreatedAt(LocalDateTime.now());
        commentsRepository.save(newComment);

        return "redirect:/posts/" + articleId;
    }

    @PostMapping("/posts/{articleId}/comments/{commentId}/delete") // 댓글 삭제 처리
    public String deleteComment(@PathVariable Long articleId,
                                @PathVariable Long commentId,
                                Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId = memberRepository.findIdByUsername(username);

        Comments comment = commentsRepository.findById(commentId).orElse(null);
        if (comment != null && comment.getUser().getId().equals(userId)) {
            commentsRepository.deleteById(commentId);
        }
        return "redirect:/posts/" + articleId;
    }

    @PostMapping("/posts/{articleId}/comments/{commentId}/edit") // 댓글 수정 처리
    public String editComment(@PathVariable Long articleId,
                              @PathVariable Long commentId,
                              @RequestParam String content,
                              Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId = memberRepository.findIdByUsername(username);

        Comments comment = commentsRepository.findById(commentId).orElse(null);
        if (comment != null && comment.getUser().getId().equals(userId)) {
            comment.setContent(content);
            comment.setCreatedAt(LocalDateTime.now());
            commentsRepository.save(comment);
        }
        return "redirect:/posts/" + articleId;
    }


    @PostMapping("/posts/{articleId}/like") //좋아요
    public String toggleLike(@PathVariable Long articleId, Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId= memberRepository.findIdByUsername(username);

        Articles article = articlesRepository.findById(articleId).orElse(null);
        Member member = memberRepository.findById(userId).orElse(null);
        if (article == null || member == null) return "redirect:/posts";

        boolean exists = likesRepository.existsByArticle_idAndUser_Id(articleId, userId);
        if (exists) {
            Likes like = likesRepository.findByArticle_idAndUser_Id(articleId, userId);
            likesRepository.delete(like);
        } else {
            Likes like = new Likes();
            like.setArticle(article);
            like.setUser(member);
            like.setCreatedAt(LocalDateTime.now());
            likesRepository.save(like);
        }
        return "redirect:/posts/" + articleId;
    }

    @GetMapping("/posts/new") //글쓰기 폼
    public String showRegisterForm(Authentication authentication, Model model) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId= memberRepository.findIdByUsername(username);

        if (userId != null) {
            Member member = memberRepository.findById(userId).orElse(null);
            model.addAttribute("user", member);
        }
        model.addAttribute("editMode", false);
        return "postRegister"; // templates/Register.html을 렌더링 (대소문자 주의!)
    }

    @PostMapping("/posts/new") // 글쓰기 처리
    public String newPost(
            @RequestParam String subjectName,
            @RequestParam String keywords,
            @RequestParam String questionText,
            @RequestParam String answerText,
            Authentication authentication,
            Model model) {

        try {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            String username = userDetails.getUsername();
            Long userId= memberRepository.findIdByUsername(username);

            Member member = memberRepository.findById(userId).orElse(null);
            if (member == null) return "redirect:/posts";

            Articles article = new Articles();
            article.setUser(member);
            article.setSubjectName(subjectName);
            article.setKeywords(keywords);
            article.setQuestionText(questionText);
            article.setAnswerText(answerText);
            article.setCreatedAt(LocalDateTime.now());

            articlesRepository.save(article);

            // 저장된 게시글의 ID로 상세 페이지로 리다이렉트
            return "redirect:/posts/" + article.getId();
        } catch (Exception e) {
            // 오류 처리 - 폼으로 다시 돌아가기
            model.addAttribute("error", "게시글 저장 중 오류가 발생했습니다: " + e.getMessage());
            model.addAttribute("editMode", false);
            return "postRegister";
        }
    }

    @PostMapping("/posts/{articleId}/delete") // 글 삭제 처리
    public String deletePost(@PathVariable Long articleId, Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId= memberRepository.findIdByUsername(username);

        Articles article = articlesRepository.findById(articleId).orElse(null);
        if (article == null || !article.getUser().getId().equals(userId)) {
            return "redirect:/posts";
        }

        commentsRepository.deleteByArticleId(articleId);    // 댓글 같이 삭제
        likesRepository.deleteByArticleId(articleId);       // 좋아요 같이 삭제
        articlesRepository.delete(article);                 // 글 삭제
        return "redirect:/posts";
    }

    @GetMapping("/posts/{articleId}/edit") // 글 수정 폼
    public String editPostForm(@PathVariable Long articleId, Model model, Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId= memberRepository.findIdByUsername(username);
        //user Id가 존재하면
        if (userId != null) {
            Member member = memberRepository.findById(userId).orElse(null);
            model.addAttribute("user", member);
        }

        Articles article = articlesRepository.findById(articleId).orElse(null);
        if (article == null || !article.getUser().getId().equals(userId)) {
            return "redirect:/posts";
        }
        //수정한 글 다시 전달, 그리고 수정버튼 있어야하니 플래그 전달
        model.addAttribute("article", article);
        model.addAttribute("editMode", true); // 수정 모드 플래그
        return "postRegister"; //
    }

    @PostMapping("/posts/{articleId}/edit") // 글 수정 처리
    public String editPost(
            @PathVariable Long articleId,
            @RequestParam String subjectName,
            @RequestParam String keywords,
            @RequestParam String questionText,
            @RequestParam String answerText,
            Authentication authentication
    ) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        Long userId= memberRepository.findIdByUsername(username);

        Articles article = articlesRepository.findById(articleId).orElse(null);
        if (article == null || !article.getUser().getId().equals(userId)) {
            return "redirect:/posts";
        }

        article.setSubjectName(subjectName);
        article.setKeywords(keywords);
        article.setQuestionText(questionText);
        article.setAnswerText(answerText);
        articlesRepository.save(article);

        return "redirect:/posts/" + articleId;
    }


    private PostDTO toPostDTO(Articles article) {
        Long articleId = article.getId();
        Long commentCount = commentsRepository.countByArticle_id(articleId);
        Long likeCount = likesRepository.countByArticle_id(articleId);

        PostDTO dto = new PostDTO();
        dto.setArticleId(articleId);
        dto.setSubjectName(article.getSubjectName());
        dto.setKeywords(article.getKeywords());
        dto.setQuestionText(article.getQuestionText());
        dto.setAnswerText(article.getAnswerText());
        dto.setCreatedAt(article.getCreatedAt());
        dto.setAuthorNickname(article.getUser().getNickname());
        dto.setAuthorId(article.getUser().getId());
        dto.setCommentCount(commentCount);
        dto.setLikeCount(likeCount);

        return dto;
    }
}