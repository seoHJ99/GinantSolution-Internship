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
   #spinner {
    display: none;
  width: 50px;
  height: 50px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  box-sizing: border-box;

  border-top-color: red;
  border-bottom-color: red;

  border-radius: 100%;
  animation: spin 1s ease-in-out infinite;
  }
  @keyframes spin {
  100%
  {
    transform: rotate(180deg);
  }
}


    </style>
  </head>
  <body>
    <form id="searchForm" action="/search" method="get">
    <div>
      <select name="findBy" id="findBy">
        <option value="title">제목</option>
        <option value="writer">작성자</option>
        <option value="content">내용</option>
        <option value="tiNcon">제목+내용</option>
      </select>
      <input type="text" name="content" id="searchCon" value="${content}"/>
      <input type="submit" id="searchBtn" value="검색" />
      <input type="button" id="ajaxBtn" value="비동기 검색">
      <div id="spinner"></div>
    </div>
    <input type="date" name="startDate" /> ~
    <input type="date" name="endDate" />
    <select name="pageSize" id="">
      <option value="10">10</option>
      <option value="30">30</option>
      <option value="50">50</option>
    </select>
  </form>
    <div>
      <input type="button" value="등록" onclick="location.href='/writing';" />
      <input type="button" value="삭제" id="delete" />
    </div>
    <div id="container">
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
    <div>      
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
  </div>
</div>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script>     
      let curretnUrl = window.location.href;
      let page = $(element).text();
      let paramPage = getParameter("page");
      let startDate = getParameter("startDate");
      let endDate = getParameter("endDate");
      let findBy = getParameter("findBy");
      let content = getParameter("content");
    $(".pageLink").each(function(index, element){

        if(paramPage != ""){
          curretnUrl = curretnUrl.replace(paramPage, "");
         if(paramPage.includes("?")){
            $(element).attr("href", curretnUrl + "?page="+page);
          }else{
            $(element).attr("href", curretnUrl + "&page="+page);
         }
         $("#next").attr("href", curretnUrl+"&page="+(Number(page)+1));
         if(index==0){
          $("#prev").attr("href", curretnUrl+"&page="+(Number(page)-1));
         }
      }else{
        if(paramPage == "" && startDate == "" && endDate == "" && findBy == "" && content==""){
          $(element).attr("href", curretnUrl + "?page="+page);
        }else{
          $(element).attr("href", curretnUrl + "&page="+page);
        }
        $("#next").attr("href", curretnUrl+"&page="+(Number(page)+1));
          if(index==0){
            $("#prev").attr("href", curretnUrl+"?page="+(Number(page)-1));
        }
    }

    if(findBy == ""){
      $("#next").attr("href", "?page="+(Number(page)+1));
      $("#prev").attr("href", "?page="+(Number(page)-5));
    }
  });
   


      $("#ajaxBtn").on("click", function(){
        ajaxSearch();
      })

    function ajaxSearch(page=1){
      let param = $("#searchForm").serialize()+"&page="+page;
      $.ajax({
        type:"get",
        url:"/search/ajax?"+ param ,
        dataType:"text",
        data: {},
        beforeSend: function(xhr){
          $("#spinner").css("display", "block");
        },
        complete: function(){
          $("#spinner").css("display", "none");
        },
        success: function(result){
          $("#container").html(result);
          let lastPage = 0;
          let prevPage = 0;
          $(".pageLink").each(function(index, element){
            let page = $(element).text();
            if(index ==0){
              prevPage = page; 
            }
            $(element).attr("href","javascript:ajaxSearch("+page+")");
            lastPage = page;
          });
          $("#next").attr("href", "javascript:ajaxSearch("+ (Number(lastPage)+1) +")");
          $("#prev").attr("href", "javascript:ajaxSearch("+ (Number(prevPage)-1) +")");
        },
      })
    }
    
    function getParameter(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
        
    return results === null ? "" : decodeURIComponent(results[0].replace(/\+/g, " "));
}

      function deleteTrans(data) {
        // 서버와 통신
        $.ajax({
          type: "post",
          url: "/delete",
          dataType: "text",
          data: { data: data },
          traditional: true,
          success: function (result) {
            if (result == "0") {
              alert("성공적으로 삭제되었습니다.");
              location.href = "/";
            } else {
              alert("삭제 실패");
            }
          },
        });
      }

      $("#delete").on("click", function () {
        let idArr = [];
        // let str = "";
        $(".boardChk").each(function (index, element) {
          if ($(element).is(":checked")) {
            let checkedId = $(element).attr("id");
            idArr.push(checkedId);
            // str += ","+checkedId;
          }
        });
        deleteTrans(idArr);
        // deleteTrans(str);
      });

      function allCheck() {
        if ($("#allChk").is(":checked")) {
          $(".boardChk").each(function (index, element) {
            $(element).prop("checked", true);
          });
        } else {
          $(".boardChk").each(function (index, element) {
            $(element).prop("checked", false);
          });
        }
      }

      $("#allChk").change(function () {
        allCheck();
      });
    </script>
  </body>
</html>
