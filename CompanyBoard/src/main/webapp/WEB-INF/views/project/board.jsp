<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
session="false" %> <%@page import="java.util.List"%> <%@page
import="com.com.com.vo.BoardVO"%> <%@ page language="java"
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ taglib
prefix="d" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
  <head>
    <title>board</title>

    <style>
      .tr:hover{
        background-color:#CCCCCC;
      }
      .tr{
        cursor: pointer;
      }
    </style>
  </head>
  <body>
      <div>${employee.name}(
        <c:choose>
          <c:when test="${employee.originalAuthority == 1}">
            사원
          </c:when>
          <c:when test="${employee.originalAuthority == 2}">
            대리
          </c:when>
          <c:when test="${employee.originalAuthority == 3}">
            과장
          </c:when>
          <c:when test="${employee.originalAuthority == 4}">
            부장
          </c:when>
        </c:choose>
        )
        <c:if test="${representation != null}">
          -
  
        ${representation.name}(
        <c:choose>
          <c:when test="${representation.originalAuthority == 1}">
            사원
          </c:when>
          <c:when test="${representation.originalAuthority == 2}">
            대리
          </c:when>
          <c:when test="${representation.originalAuthority == 3}">
            과장
          </c:when>
          <c:when test="${representation.originalAuthority == 4}">
            부장
          </c:when>
        </c:choose>
        )
      </c:if>
        님, 환영합니다.
      <form action="/project/logout/action">
        <input type="submit" value="로그아웃"/>
      </form>
      </div>
    <div>
    <form id="searchForm" action="/project/search" method="get">
      <input type="hidden" name="authority" value="${employee.authority}">
      <input type="hidden" name="name" value="${employee.name}">
      <input type="hidden" name="id" value="${employee.id}">

      <select name="findBy" id="findBy" >
        <option value="">선택</option>
        <option value="title">제목</option>
        <option value="name">작성자</option>
        <option value="approval">결재자</option>
        <option value="titleAndCon">제목+내용</option>
        <input type="hidden" value="${aa}">
        <input type="hidden" value="${aa}">
      </select>
      <input type="text" name="content" id="searchCon" value="${map.content}"/>
      <select name="state" id="state">
        <option value="">모두</option>
        <option value="TEMP">임시 저장</option>
        <option value="REJECT">반려</option>
        <option value="READY">결재 대기</option>
        <option value="PROCESS">결재중</option>
        <option value="DONE">결재 완료</option>
      </select>
    </div>
    <input type="date" id="startDate" name="startDate"/> ~
    <input type="date" id="endDate" name="endDate" />
    <input type="button" id="searchBtn" value="검색" />
  </form>
    <div>
      <input type="button" value="글쓰기" onclick="location.href='/project/writing';" />
      <c:if test="${employee.authority == '3' || employee.authority == '4'}">
        <input type="button" id="representation" value="대리 결제">
      </c:if>
    </div>
    <div id="container">
    <table border="1" id="boardTable">
      <tr>
        <td><input type="checkbox" id="allChk" /></td>
        <th>글번호</th>
        <th>작성자</th>
        <th>제목</th>
        <th>작성일</th>
        <th>결재일</th>
        <th>결재자</th>
        <th>결재 상태</th>
      </tr>

    <d:forEach var="board" items="${board}">
    <fmt:parseDate var="date" value="${board.regDate }" pattern="yyyy-mm-dd" />

      <tr id="${board.seq}" class="tr">
        <td>
            <input type="checkbox" id="${board.seq}" class="boardChk">
        </td>
        <td>${board.seq}</td>
        <td>${board.name }</td>
        <td><a href="/project/board/${board.seq}">${board.title }</a></td>
        <td>    
          <fmt:formatDate pattern="yyyy-mm-dd" value="${date}" />
        </td>
        <td>${board.approDate }</td>
        <td>${board.approval }
          <c:if test="${not empty board.representApproval && board.state !='반려' && board.state !='임시저장'}">
            <br>(${board.representApproval}) 
          </c:if>
        </td>
        <td>${board.state}</td>
      </tr>
      </d:forEach>
    </table>
</div>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script>
      // 검색어 넣어두기
      $("#findBy").val('${map.findBy}');
      $("#startDate").val('${map.startDate}');
      $("#endDate").val('${map.endDate}');
      $("#state").val('${map.state}')

      // 일반 검색
      $("#searchBtn").on("click",function(){
        if($("#findBy").val() == '' && $("#searchCon").val() != ""){
          alert('검색 분류를 선택해 주세요!')
        }else{
          if($("#searchCon").val() == ""){
            location.href="/project/board"
          }
          $("#searchForm").submit();
        }
      })

      // ajax 검색
      $("#state").on("change", function(){
        if($("#state").val() == ''){
          location.href="/project/board";
        }
        stateSearch();
      })

      function stateSearch(){
        $.ajax({
          type: "post",
          url: "/project/state/search",
          dataType: "text",
          data: {"state" : $("#state").val() },
          traditional: true,
          success: function (result) {
            console.log(result);
            $("#container").html(result);
          },
        });
      }

      // 테이블 한줄마다 링크 걸기
      $(".tr").each(function(index, element){
        $(element).on("click", function(){
          location.href="/project/board/" + $(this).attr("id");
        })
      });

      // 대리결제 창 띄우기
      $("#representation").on("click", function(){
        let left = Math.ceil(( window.screen.width - 500)/2);
        let top = Math.ceil(( window.screen.height - 400 )/2);
        window.open("/project/representation","aa", "width = 500, height=400, left="+left+",top="+top);
      });
    </script>
  </body>
</html>
