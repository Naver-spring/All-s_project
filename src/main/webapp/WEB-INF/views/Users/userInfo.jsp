<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<%--<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/> --%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>
<%--이제 필요없는 코드 --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 정보 > 내 정보 > All's</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
        });
    </script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
<jsp:include page="${root}/WEB-INF/views/include/timer.jsp"/>
<jsp:include page="${root}/WEB-INF/views/include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section>
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="${root}/WEB-INF/views/include/navbar.jsp"/>
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="${root}/WEB-INF/views/include/navbar.jsp"/>
            </div>
            <div id="content">
                <h1>${userVo.name} 님의 회원 정보</h1>
                <%-- 로그인한 사용자에게만 정보 표시 --%>


                <sec:authorize access="isAuthenticated()">
                    <c:if test="${not empty error}">
                        <p>${error}</p>
                    </c:if>
                    <c:if test="${not empty msg1}">
                        <p>${msg1}: ${msg2}</p>
                    </c:if>

                    <section class="userinfo">
                        <div class="userprofile">
                            <div class="profile-img">
                                <img src="${root}/resources/images/${userVo.profileImage}" alt="내 프로필">
                            </div>
                            <h3>${userVo.username}</h3>
                        </div>
                        <div class="userdata bgwhite">
                            <ul>
                                <li><b>이름</b></li>
                                <li>${userVo.name}</li>
                            </ul>
                            <ul>
                                <li><b>성별</b></li>
                                <li>${userVo.gender}</li>
                            </ul>
                            <ul>
                                <li><b>이메일</b></li>
                                <li>${userVo.email}</li>
                            </ul>
                            <ul>
                                <li><b>생년월일</b></li>
                                <li>${userVo.birthdate}</li>
                            </ul>
                            <ul>
                                <li><b>위치정보</b></li>
                                <li>${userVo.latitude}, ${userVo.longitude}</li>
                            </ul>
                            <ul>
                                <li><b>등급</b></li>
                                <li>${userVo.gradeIdx}</li>
                            </ul>
                            <ul>
                                <li><b>SNS 연동</b></li>
                                <li>${userVo.socialLogin}</li>
                            </ul>
                            <ul>
                                <li><b>가입날짜</b></li>
                                <li>${userVo.createdAt}</li>
                            </ul>
                        </div>
                    </section>
                    <section class="statistics">
                        <div class="graph-area" style="width: 200px; height: 50px;">
                            그래프 영역
                        </div>
                        <div class="total-activity flex-colum">
                            <button class="secondary-default flex-between">
                                <p class="activity-title">총 공부시간</p>
                                <p>150시간</p>
                            </button>
                            <button class="secondary-default flex-between">
                                <p class="activity-title">좋아요한 게시글</p>
                                <p>15개</p>
                            </button>
                            <button class="secondary-default flex-between">
                                <p class="activity-title">좋아요한 스터디</p>
                                <p>5개</p>
                            </button>
                        </div>
                    </section>
                    <section class="resume">
                        <div class="resume-title">
                            <h3>이력서</h3>
                            <a href="#">AI로 자소서 작성하기 →</a>
                        </div>
                        <div class="resume-file">
                            <div class="file-item">
                                <button class="file-delete">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                                <input type="file" id="resume1">
                                <label for="resume1">
                                    <p class="filename">이력서1.hwp</p>
                                    <div class="fileUpload">업로드↑</div>
                                </label>
                            </div>
                        </div>
                        <div class="resume-file non-file">
                            <div class="file-item">
                                <button class="file-delete">
                                </button>
                                <input type="file" id="resume2">
                                <label for="resume2">
                                    <p class="filename">이력서 파일을 업로드 해주세요</p>
                                    <div class="fileUpload">업로드↑</div>
                                </label>
                            </div>
                        </div>
                        <div class="resume-file non-file">
                            <div class="file-item">
                                <button class="file-delete">
                                </button>
                                <input type="file" id="resume3">
                                <label for="resume3">
                                    <p class="filename">이력서 파일을 업로드 해주세요</p>
                                    <div class="fileUpload">업로드↑</div>
                                </label>
                            </div>
                        </div>
                    </section>
                </sec:authorize>


            </div>
        </main>
    </section>



    <jsp:include page="${root}/WEB-INF/views/include/footer.jsp"/>
    <jsp:include page="../include/timer.jsp" />
</div>
</body>
</html>
