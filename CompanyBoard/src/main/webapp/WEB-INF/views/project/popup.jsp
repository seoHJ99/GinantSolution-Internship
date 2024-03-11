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
    <title>Document</title>
  </head>
  <body>
    <div>
      <form action="" id="form">
        <div>
          대리결제자:
          <select name="id" id="id">
            <option value="" authority="">선택</option>
            <c:forEach var="emp" items="${emplist}">
              <option value="${emp.id}" authority="${emp.authority}">
                ${emp.name}
              </option>
            </c:forEach>
          </select>
        </div>
        <div>
          직급:
          <input id="grade" type="text" readonly />
        </div>
        <div>
          대리자:
          <input
            type="text"
            value="${user.name} - ${user.authority eq 3 ? '과장':'' || user.authority eq 4 ? '부장':''}"
            readonly
          />
          <input type="hidden" name="authority" value="${user.authority}" />
        </div>
        <input type="button" id="cancle" value="취소" />
        <input type="button" id="submmit" value="승인" />
      </form>
    </div>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script>
      // 취소 버튼
      $("#cancle").on("click", function () {
        window.self.close();
      });

      // 승인 버튼
      $("#submmit").on("click", function () {
        $("#form").attr("action", "/project/representation/submmit");
        $("#form").submit();
      });

      // 직급 글자 바꾸기
      $("#id").on("change", function () {
        let authority = $("#id option:selected").attr("authority");
        if (authority == 1) {
          $("#grade").val("사원");
        } else if (authority == 2) {
          $("#grade").val("대리");
        } else if (authority == 3) {
          $("#grade").val("과장");
        } else {
          $("#grade").val("");
        }
      });
    </script>
  </body>
</html>
