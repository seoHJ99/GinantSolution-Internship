<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
session="false" %> <%@page import="java.util.List"%> <%@page
import="com.com.com.vo.BoardVO"%> <%@ page language="java"
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ taglib
prefix="d" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

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

    <c:forEach var="board" items="${board}">
    <fmt:parseDate var="date" value="${board.regDate }" pattern="yyyy-mm-dd" />

      <tr>
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
        <td>${board.approval }</td>
        <td>${board.state}</td>
      </tr>
    </c:forEach>
    </table>
    <!-- <div>      
      <c:if test="${page.currentPage ne 1}">
      <a id="first" href="/?page=1">[처음]</a>
    </c:if>
      <c:if test="${page.startPage - page.rangeSize > 0}">
        <a id="prev" href="/?page=${page.startPage -1 }">[이전]</a>
      </c:if>
      <c:forEach var="pageNum" begin="${page.startPage }" end="${page.endPage }">
          <c:choose>
              <c:when test="${pageNum eq  page.currentPage}">
                  <span style="font-weight: bold;"><a class="pageLink" href="#" onClick="">${pageNum }</a></span> 
              </c:when>
              <c:otherwise>
                  <a class="pageLink" href="/?page=${pageNum}">${pageNum }</a> 
              </c:otherwise>
          </c:choose>
      </c:forEach>
      <c:if test="${page.startPage + page.rangeSize < page.pageTotal}">
        <a id="next" href="/?page=${page.endPage +1 }">[다음]</a>
      </c:if>
      <c:if test="${page.currentPage ne page.pageTotal}">
        <a id="last" href="/?page=${page.pageTotal}">[맨끝]</a>
      </c:if>
  </div> -->
</div>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>