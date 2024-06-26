package bit.naver.controller;

import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.ResumesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.MyPageService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/myPage")
@RequiredArgsConstructor
public class MyPageController {

    @Autowired
    private UsersMapper usersMapper;

    private final UsersUserDetailsService usersUserDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MyPageService myPageService;

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    @RequestMapping("/myPageInfo")
    public String getMyPageInfo(Model model, HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);

        StudyReferencesEntity entity = new StudyReferencesEntity();
        entity.setUserIdx(user.getUserIdx());

        ResumesEntity entity2 = new ResumesEntity();
        entity2.setUserIdx(user.getUserIdx());

        List<StudyReferencesEntity> studyReferencesEntity = myPageService.getStudyReferencesList(entity);
        List<ResumesEntity> resumesEntity = myPageService.getResumesList(entity2);

        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("resumesEntity", resumesEntity);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);
        return "/myPage/myPageInfo";
    }

    @RequestMapping("/myPageLikePost")
    public String getLikePostList(Model model, @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                         @RequestParam(value = "searchOption", required = false) String searchOption,
                                         @RequestParam(value = "limits", required = false, defaultValue = "5") String limits,
                                         HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        String userIdx = String.valueOf(user != null ? user.getUserIdx() : 59); // 사용자 ID 가져오기
        List<StudyReferencesEntity> studyReferencesEntity = myPageService.getLikePostList(userIdx, searchKeyword, searchOption, limits);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("limits", limits);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);

        return "/myPage/myPageLikePost";
    }

    @RequestMapping("/insertLike")
    @ResponseBody
    public int insertLike(@ModelAttribute LikeReferencesEntity entity) {
        return myPageService.insertLike(entity);
    }

    @RequestMapping("/deleteLike")
    @ResponseBody
    public int deleteLike(@ModelAttribute LikeReferencesEntity entity) {
        return myPageService.deleteLike(entity);
    }

    @PostMapping("/uploadResume")
    @ResponseBody
    public Long uploadResume(@ModelAttribute StudyReferencesEntity entity1, @ModelAttribute ResumesEntity entity, MultipartFile uploadFile, HttpSession session,
                             HttpServletResponse response) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
        entity.setUserIdx(userIdx);

        if (uploadFile.getSize() > MAX_FILE_SIZE) {
            return 10L;
        }

        try {
            entity.setFileName(URLEncoder.encode(uploadFile.getOriginalFilename(), "UTF-8").replaceAll("\\+", "%20"));
            entity.setResumePath(uploadFile.getBytes());
        } catch (IOException e) {
            e.printStackTrace();
            return -1L;
        }

        return myPageService.uploadResume(entity, uploadFile);
    }


    @GetMapping(value = "/download")
    public void fileDownload(@RequestParam("resumeIdx") Long resumeIdx, HttpSession session,
                             HttpServletResponse response) {
        Users user = (Users) session.getAttribute("userVo");

        String userIdx = String.valueOf(user.getUserIdx()); // 사용자 ID 가져오기
        ResumesEntity entity = myPageService.getMyPageById(resumeIdx);
        System.out.println(entity.toString());

        String mimeType = "application/octet-stream";
        try {
            Path filePath = Paths.get(entity.getFileName());
            mimeType = Files.probeContentType(filePath);
        } catch (IOException e) {
            e.printStackTrace();
        }

        response.setContentType(mimeType);
        response.setHeader("Content-Disposition", "attachment; filename=\"" + entity.getFileName() + "\"");

        try (InputStream inputStream = new ByteArrayInputStream(entity.getResumePath());
             OutputStream outputStream = response.getOutputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/deleteResume")
    @ResponseBody
    public String deleteResume(@RequestParam("resumeIdx") String resumeIdx) {
        System.out.println("resumeIdx: " + resumeIdx);
        return myPageService.deleteResume(resumeIdx);
    }
}
