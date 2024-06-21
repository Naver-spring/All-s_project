package bit.naver.controller;

import bit.naver.entity.*;
import bit.naver.mapper.StudyGroupMapper;
import bit.naver.mapper.UsersMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/studyGroup")
public class StudyGroupController {

    @Autowired
    private StudyGroupMapper studyGroupMapper;

    @Autowired
    private UsersMapper usersMapper;


    // 스터디 리스트 조회 페이지로 이동
    @RequestMapping("/studyGroupList")
    public String getMyStudies(Model model, HttpSession session) {
        // 세션에서 현재 사용자 정보 가져오기 (예: 로그인한 사용자 정보)
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx();

        // DB에서 해당 사용자가 참여 중인 스터디 목록 조회
        List<StudyList> myStudies = studyGroupMapper.getMyStudies(userIdx);

        model.addAttribute("myStudies", myStudies);


        return "studyGroup/studyGroupList";
    }

    // 스터디 생성 폼을 위한 GET 요청 처리
    @GetMapping("/studyGroupCreate")
    public String getStudyGroupCreate(Model model) {
        model.addAttribute("studyGroup", new StudyGroup()
        );
        return "studyGroup/studyGroupCreate";
    }

    @RequestMapping("/studyGroupMain")
    public String getStudyGroupMain(@RequestParam("studyIdx") Long studyIdx, Model model) {
        StudyGroup study = studyGroupMapper.getStudyById(studyIdx);
        List<StudyMembers> members = studyGroupMapper.getStudyMembers(studyIdx);
        model.addAttribute("study", study);
        model.addAttribute("members", members);
        return "studyGroup/studyGroupMain"; // 스터디 상세 정보를 보여줄 JSP 페이지
    }

    // 스터디 생성을 위한 POST 요청 처리
    @PostMapping("/studyGroupCreate")
    public String insertCreateStudyGroup(@ModelAttribute("studyGroup") StudyGroup study, BindingResult result, HttpSession session, Principal principal) {
        if (result.hasErrors()) {
            return "studyGroup/studyGroupCreate";
        }

        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx();

        // 여기서 studyLeaderIdx를 user의 username에서 가져오는 로직
        // 예시로 구현하면 아래와 같이 userRepository.findByUsername(user.getUsername()).getUserIdx()를 호출


        study.setStudyLeaderIdx(userIdx);
        study.setStartDate(new Date());
        study.setEndDate(new Date());
        study.setStatus(StudyStatus.RECRUITING);
        study.setCreatedAt(new Date());


        studyGroupMapper.insertStudy(study);

        // StudyMembers 테이블에 스터디 리더로 데이터 삽입
        StudyMembers studyMember = new StudyMembers();
        studyMember.setStudyIdx(studyGroupMapper.findStudyIdx(userIdx));
        studyMember.setUserIdx(userIdx);
        studyMember.setRole("LEADER");
        studyMember.setStatus("ACCEPTED");
        studyMember.setCreatedAt(LocalDateTime.now());
        studyMember.setUpdatedAt(LocalDateTime.now());

        studyGroupMapper.insertStudyMember(studyMember);

        return "/studyGroup/studyGroupList";
    }




}
