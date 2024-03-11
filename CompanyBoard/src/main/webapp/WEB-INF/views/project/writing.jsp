<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
session="false" %> <%@ page language="java" contentType="text/html;
charset=UTF-8" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>글쓰기</title>
  </head>
  <body>
    <div>
      <div>
        <table border="1">
          <tr>
            <th>결제요청</th>
            <th>과장</th>
            <th>부장</th>
          </tr>
          <tr>
            <td>
              <input type="checkbox" onclick="return false" ${board2.state eq
              "결재대기" || board2.state eq "결재중" || board2.state eq "결재완료" ?
              "CHECKED" : ""} />
            </td>
            <td>
             <input type="checkbox" onclick="return false" ${board2.state eq 
             "결재중" || board2.state eq "결재완료" ? 'checked' : ''} />

            </td>
            <td><input type="checkbox" onclick="return false" ${board2.state eq "결재완료" ? "CHECKED" : ""} /></td>
          </tr>
        </table>
      </div>
      <form id="mainForm" action="">
        <input type="hidden" name="seq" id="seq" value="${board2.seq}" />
        <input type="hidden" id="state" name="state" value="${board2.state}" />
        <input type="hidden" id="approval" name="approval" value="${id}">
        <input type="hidden" id="name" name="name" value="${id}">
        <input type="hidden" id="representApproval" name="representation" value="${representation}">
        <c:if test="${board2 == null}">
          <input type="hidden" name="first", value="ture">
        </c:if>
        <div>
          <label for="writer">작성자</label>
          <input
            type="text"
            id="writer"
            value="${board2.name}${name}"
            readonly
          />
          <br />
          <label for="seq">글번호</label>
          <input type="text" id="seq" name="seq" value="${board2.seq}" readonly>
          <input type="hidden" id="id" name="id" value="${board2.id}${id}" readonly/>
          <br />
          <label for="title">제목</label>
          <input
            type="text"
            id="title"
            name="title"
            value="${board2.title}"
            ${board2.state eq "결재대기" || board2.state eq "결재중" || board2.state eq "결재완료" ? "READONLY" : "" }
          /><br />
          <div>내용:</div>
          <textarea name="content" id="content" cols="30" rows="10"
          ${board2.state eq "결재대기" || board2.state eq "결재중" || board2.state eq "결재완료" ? "READONLY" : "" }
          >${board2.content}</textarea>
          <br />
          <c:if
            test="${ board2 != null && ((board2.state == '결재대기' && authority == 3) 
            || (board2.state == '결재중' && authority == 4) )
            || (authority == 4 && originalAuthority ==3)}"
          >
            <input type="button" value="반려" id="reject" />
          </c:if>
          <c:if
            test="${ (board2.state eq '반려' && board2.id == id)
             || (board2.state eq '임시저장')
             || board2 == null}"
          >
            <input type="button" value="임시저장" id="save" />
          </c:if>
         
          <c:if
            test="${
               board2.state eq '임시저장' 
            || (board2.state eq '반려' && board2.id == id)
            || (authority == 3 && board2.state eq '결재대기') 
            || board2 == null 
            || (board2.state eq '결재중' && authority == 4) 
            || (authority == 4 && originalAuthority ==3)
             }"
          >
            <input type="button" value="결제" id="requestApproval" />
          </c:if>
        </div>
      </form>
      <div>
        결제 이력
        <table border="1">
          <tr>
            <th>번호</th>
            <th>결재일</th>
            <th>결재자</th>
            <th>결재상태</th>
          </tr>
          <c:forEach var="board2" items="${list}">
            <tr>
              <td>${board2.no}</td>
              <td>${board2.approDate}</td>
              <td>${board2.approval}</td>
              <td>${board2.state}</td>
            </tr>
          </c:forEach>
        </table>
      </div>
    </div>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>

    <script>
      // 임시저장 
      $("#save").on("click", function () {
        $("#mainForm").attr("action", "/project/board/save");
        $("#state").val("TEMP");
        $("#mainForm").submit();
      });

      // 결제 버튼 처리
      $("#requestApproval").on("click", function () {
        $("#mainForm").attr("action", "/project/board/request");
        let currentState = $("#state").val();
        if(currentState == '임시저장' || currentState == '반려'){
          $("#state").val("READY");
          $("#approval").val("");
        }else if(currentState == '결재대기'){
          $("#state").val("PROCESS");
        }else if(currentState == '결재중'){
          $("#state").val("DONE");
        }else{
          $("#state").val("READY");
        }
        $("#mainForm").submit();
      });

      // 반려처리
      $("#reject").on("click", function () {
        $("#mainForm").attr("action", "/project/board/reject");
        $("#state").val("REJECT");
        $("#mainForm").submit();
      });
    </script>
  </body>
</html>
