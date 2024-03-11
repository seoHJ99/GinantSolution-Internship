<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
session="false" %> <%@page import="java.util.List"%> <%@page
import="com.com.com.vo.BoardVO"%> <%@ page language="java"
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ taglib
prefix="d" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
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
      <form action="/project/login/action" id="form" method="post">
        <div>로그인</div>
        <input type="text" id="id" name="id" placeholder="id입력" /><br />
        <input
          type="text"
          id="password"
          name="password"
          placeholder="pw입력"
        /><br />
        <input type="button" id="loginBtn" value="로그인" />
      </form>
    </div>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script>
      $("#loginBtn").on("click", function () {
        if ($("#id").val() == "" || $("#password").val() == "") {
          alert("아이디, 비번을 입력해주세요");
        } else {
          $("#form").submit();
        }
      });
    </script>
  </body>
</html>
