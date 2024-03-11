<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
session="false" %> <%@page import="java.util.List"%> <%@page
import="com.com.com.vo.BoardVO"%> <%@ page language="java"
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ taglib
prefix="d" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<table border="1" id="boardTable">
  <tr>
    <td><input type="checkbox" id="allChk" /></td>
    <th>글번호</th>
    <th>작성자(id)</th>
    <th>제목</th>
    <th>등록일</th>
    <th>수정일</th>
    <th>조회수</th>
  </tr>

<d:forEach var="list" items="${boardList}">
<fmt:parseDate var="date" value="${list.writeDate }" pattern="yyyy-mm-dd" />

  <tr>
    <td>
        <input type="checkbox" id="${list.no}" class="boardChk">
    </td>
    <td>${list.no }</td>
    <td>${list.writer }(${list.id })</td>
    <td><a href="/board/${list.no}">${list.title }</a></td>
    <td>    
      <fmt:formatDate pattern="yyyy-mm-dd" value="${date}" />
    </td>
    <td>${list.modifyDate }</td>
    <td>${list.count }</td>
  </tr>
  </d:forEach>
</table>

<div id="ajaxPage">
  <c:if test="${page.startPage - page.rangeSize > 0}">
    <a id="prev" href="/search/ajax?page=${page.startPage -1 }">[이전]</a>
  </c:if>
  <c:forEach var="pageNum" begin="${page.startPage }" end="${page.endPage }">
      <c:choose>
          <c:when test="${pageNum eq  page.currentPage}">
              <span style="font-weight: bold;"><a class="pageLink" href="#" onClick="">${pageNum }</a></span> 
          </c:when>
          <c:otherwise>
              <a class="pageLink" href="${url}${pageNum}" onClick="">${pageNum }</a> 
          </c:otherwise>
      </c:choose>
  </c:forEach>
  <c:if test="${page.startPage + page.rangeSize < page.pageTotal}">
    <a id="next"  href="${url}${page.endPage +1 }">[다음]</a>
  </c:if>
</div>