<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    if (request.getProtocol().equals("HTTP/1.1"))
        response.setHeader("Cache-Control", "no-cache");
%>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<c:set var="currentURI" value="${pageContext.request.requestURL}" />

<head>
    <meta charset="UTF-8">
    <title>All's</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<div class="menu">
    <input type="hidden" id="hiddenid" value="${userVo.userIdx}">
    <!-- 로그인하지 않은 경우 -->
    <sec:authorize access="isAnonymous()">
        <button class="button-disabled timestart" onclick="alert('로그인 후 이용해주세요')">공부 시작</button>
    </sec:authorize>
    <!-- 로그인한 경우 -->
    <sec:authorize access="isAuthenticated()">
    <button class="primary-default timestart" onclick="timerOpen()">공부 시작</button>
    </sec:authorize>
    <div id="lnb" class="lnb">
        <ul class="main-menu">
            <li class="menu-item">
                <div id="mainMenu" class="menu-area">
                    <a href="${root}/main" class="menu-top">대시보드</a>
                </div>
            </li>
            <li class="menu-item">
                <div class="menu-area menu-icon flex-between">
                    <a href="#" class="menu-top menu-text">공부</a>
                    <button class="tertiary-default">
                        <i class="bi bi-chevron-up"></i>
                        <span class="hide">메뉴 열기/닫기</span>
                    </button>
                </div>
                <ul class="submenu">
                    <li class="submenu-item">
                        <div id="noteMenu" class="menu-area">
                            <form method="POST" action="<c:url value='${root }/studyNote/noteList' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">내 공부노트</button>
                            </form>
                        </div>
                    </li>
                    <li class="submenu-item">
                        <div id="calendarMenu" class="menu-area">
                            <form method="POST" action="<c:url value='${root}/calendar' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">캘린더</button>
                            </form>
                        </div>
                    </li>
                    <li class="submenu-item dropdown">
                        <div class="menu-area menu-icon flex-between">
                            <a href="${root}/studyGroup/studyGroupList" class="menu-text">스터디</a>
                            <button class="tertiary-default">
                                <i class="bi bi-dash-lg"></i>
                                <span class="hide">메뉴 열기/닫기</span>
                            </button>
                        </div>
                        <ul class="dropdown-menu">
                            <li class="dropdown-item">
                                <div id="studyMenu" class="menu-area">
                                    <form method="POST" action="<c:url value='${root}/studyGroup/studyGroupList' />">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="link-button">내 스터디</button>
                                    </form>
                                </div>
                            </li>
                            <li class="dropdown-item">
                                <div id="recruitMenu" class="menu-area">
                                    <form method="POST" action="<c:url value='${root}/studyRecruit/recruitList' />">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="link-button">스터디 모집</button>
                                    </form>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li class="submenu-item">
                        <div id="referencesMenu"  class="menu-area">
                            <form method="POST" action="<c:url value='${root }/studyReferences/referencesList' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">공부 자료</button>
                            </form>
                        </div>
                    </li>
                    <li class="submenu-item">
                        <div id="siteMenu"  class="menu-area">
                            <a href="${root}/studyReferences/referencesSite">관련 사이트</a>
                        </div>
                    </li>
                </ul>
            </li>
            <li class="menu-item">
                <div class="menu-area menu-icon flex-between">
                    <a href="#" class="menu-top menu-text">내 정보</a>
                    <button class="tertiary-default">
                        <i class="bi bi-chevron-up"></i>
                        <span class="hide">메뉴 열기/닫기</span>
                    </button>
                </div>
                <ul class="submenu">
                    <li class="submenu-item">
                        <div id="mypageMenu"  class="menu-area">
                            <form method="POST" action="<c:url value='${root }/myPage/myPageInfo' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">나의 정보</button>
                            </form>
<%--                            <form method="POST" action="<c:url value='${root }/Users/userInfoProcess' />">--%>
<%--                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />--%>
<%--                                <button type="submit" class="link-button">나의 정보</button>--%>
<%--                            </form>--%>
                        </div>
                    </li>
                    <li class="submenu-item">
                        <div id="usereditMenu"  class="menu-area">
                            <form method="POST" action="<c:url value='${root }/Users/userEdit' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">정보 수정</button>
                            </form>
                        </div>
                    </li>
                    <li class="submenu-item">
                        <div id="userdeletMenu"  class="menu-area">
                            <form method="POST" action="<c:url value='${root}/Users/userdelete'/>">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">회원 탈퇴</button>
                            </form>
                        </div>
                    </li>
                </ul>
            </li>
        </ul>
    </div>
    <%-- 로그인한 사용자에게만 표시 --%>
    <sec:authorize access="isAuthenticated()">
        <div class="studyTime">
            <h3 class="">오늘의 공부 시간</h3>
            <div class="flex-between">
                <div class="todoTitle">Total</div>
                <p class="totalstudytime"></p>
            </div>
            <div class="flex-between">
                <div class="todoTitle">Today</div>
                <p id="todaystudytime"></p>
            </div>
        </div>
    </sec:authorize>
</div>
<script>
    // 컨텍스트 루트 및 현재 URI 설정
    const contextPath = 'http://localhost:8080/WEB-INF/views/';
    const currentURI = '${currentURI}';

    // 현재 URI에서 컨텍스트 루트를 제거한 경로
    const relativePath = currentURI.substring(contextPath.length);

    console.log(relativePath)

    // 특정 경로에 따라 클래스 추가
    if (relativePath.startsWith('/main')) {
        document.getElementById('mainMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('/studyNote')) {
        document.getElementById('noteMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('calendar')) {
        document.getElementById('calendarMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('studyGroup')) {
        document.getElementById('studyMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('studyRecruit')) {
        document.getElementById('recruitMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('/studyReferences') && !relativePath.startsWith('/studyReferences/referencesSite')) {
        document.getElementById('referencesMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('/studyReferences/referencesSite')) {
        document.getElementById('siteMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('/myPage')) {
        document.getElementById('mypageMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('Users/userEdit')) {
        document.getElementById('usereditMenu').classList.add('menu-select');
    } else if (relativePath.startsWith('Users/userDelete')) {
        document.getElementById('userdeletMenu').classList.add('menu-select');
    }

    //숫자 계산
    function formatTime(seconds) {
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        const s = seconds % 60;
        const hDisplay = h > 0 ? h + '시간 ' : '';
        const mDisplay = m > 0 ? m + '분 ' : '';
        const sDisplay = s > 0 ? s + '초' : '';
        return hDisplay + mDisplay + sDisplay;
    }
    fetch(`/include/updateTime?userIdx=${userVo.userIdx}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // 데이터에서 total_study_time과 today_study_time 값을 추출
            const totalStudyTime = data.totalStudyTime;
            const todayStudyTime = data.todayStudyTime;

            console.log("totalStudyTime: "+totalStudyTime);
            console.log("todayStudyTime: "+todayStudyTime)

            // HTML 요소에 데이터를 삽입
            document.querySelectorAll('.totalstudytime').forEach(element => {
                if(totalStudyTime==0){
                    element.innerText = "-";
                }else {
                    element.innerText = formatTime(totalStudyTime);
                }
            });
            if(todayStudyTime==0){
                document.getElementById('todaystudytime').innerText = "-"
            }else {
                document.getElementById('todaystudytime').innerText = formatTime(todayStudyTime);
            }
        })
        .catch(error => {
            console.error('There has been a problem with your fetch operation:', error);
        });

</script>

