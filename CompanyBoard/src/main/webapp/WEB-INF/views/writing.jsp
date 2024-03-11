<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
session="false" %> <%@ page language="java" contentType="text/html;
charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        <c:set var="board" value="${board}" />
        <input type="hidden" id="seq" value="${seq}">
        <c:choose>
          <c:when test="${not empty board.TITLE }">
            <label for="writer">작성자</label>
            <input type="text" id="writer" value="${board.WRITER}" /><br>
            <label for="id">id</label>
            <input type="text" id="id" value="${board.ID}" /> <br>
            <label for="title">제목</label>
            <input type="text" id="title" value="${board.TITLE}" /><br>
            <div>내용:</div>
            <textarea name="content" id="content" cols="30" rows="10">
                <c:out value="${board.CONTENT}"></c:out>
            </textarea>
            <br>
            <c:forEach var="file" items="${fileList}">
              <form action="/download/${file.realName}/">
                <span>${file.realName}</span>
                <input type="hidden" name="listSeq" value="${seq}">
                <input id="${file.realName}" type="button" class="downFile" value="파일 다운">
              <br>
            </form>
            </c:forEach>

            <input type="button" value="수정" id="commit2" />
          </c:when>
          <c:otherwise>
            <label for="writer">작성자</label>
            <input type="text" id="writer" /><br>
            <label for="id">id</label>
            <input type="text" id="id" /><br>
            <label for="title">제목</label>
            <input type="text" id="title" /><br>
            <div>내용:</div>
            <textarea
              name="content"
              id="content"
              cols="30"
              rows="10"
            ></textarea>
            <br />
            <form id="fileForm" enctype="multipart/form-data">
              <div id="fileDiv">
                <div>
                  <input
                    type="file"
                    name="file1"
                    accept="image/*"
                    class="file"
                    onchange="checkFile(this)"
                  />
                </div>
              </div>
            </form>
            <input type="button" value="등록" id="commit" />
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>

    <script>
      
      $(".downFile").each(function(index, element){
        $(element).on("click",function( element ){
          // downFileCommit(this);
          const form = element.target.closest("form");
          form.submit();
        });
      });
      
      function downFileCommit(name){
        let listSeq = $("#seq").val();
        let fileName = $(name).attr("id");
        $.ajax({
          type: "GET",
          url: "/download/"+ fileName + "/?listSeq=" +listSeq,
          dataType: "text",
           success: function (data, message, xhr) { 
		       	if (xhr.readyState == 4 && xhr.status == 200) {
		       		// 성공했을때만 파일 다운로드 처리하고
		       		let disposition = xhr.getResponseHeader('Content-Disposition');
              console.log(xhr); 
              let imgSrc =  "data:image/gif;base64," + xhr.responseText;

// 이미지를 생성하고 표시합니다.
let img = new Image();
img.src = imgSrc;
console.log(img);

// 이미지를 화면에 추가하거나 다른 조작을 수행할 수 있습니다.
document.body.appendChild(img);




		       		let filename; 
		       		if (disposition && disposition.indexOf('attachment') !== -1) { 
		       			let filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
		       			let matches = filenameRegex.exec(disposition); 
		       			if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, ''); 
		       		} 
		       		let blob = new Blob([data]); 
		       		let link = document.createElement('a'); 
		       		link.href = window.URL.createObjectURL(blob); 
		       		link.download = filename; 
		       		link.click(); 
		       	}else{   
		       	    //실패했을때는 alert 메시지 출력
		       		alertPopup("다운로드에 실패하였습니다."); 
		    	   } 
		       } 
         })
       }

      function checkFile(file) {
        checkFileExtension(file);
        if ($(file).val() != "") {
          checkImageSize(file);
        }
      }

      function plustInputFile() {
        let fileCount = $(".file").length + 0;
        let html =
          '<div><input type="file" name=file' +
          fileCount +
          ' accept="image/*" class="file" onchange="checkFile(this)" /></div>';
        $("#fileDiv").append(html);
      }

      function checkFileExtension(file) {
        const imageExtension = ["jpg", "gif", "png", "jpeg", "bmp", "tif"];
        let fileExtension = file.files[0].name.substr(
          file.files[0].name.lastIndexOf(".") + 1
        );
        fileExtension = fileExtension.toLowerCase();
        let imageOnly = false;
        for (const extension of imageExtension) {
          if (extension == fileExtension) {
            imageOnly = true;
            break;
          }
        }
        if (imageOnly == false) {
          $(file).val("");
          alert("이미지 파일만 넣을수 있습니다.");
        }
      }

      function checkImageSize(file) {
        let image = new Image();
        let reader = new FileReader();
        let fileWidth = 0;
        let fileHeight = 0;
        reader.readAsDataURL(file.files[0]);
        reader.onload = function (e) {
          image.src = e.target.result;
          image.onload = function () {
            fileWidth = this.width;
            fileHeight = this.height;
            if (fileWidth > 500 || fileHeight > 500) {
              $(file).val("");
              alert("500 * 500 이하의 이미지만 첨부 가능!");
            } else {
              plustInputFile();
            }
          };
        };
      }

      // function fileCommit(formData) {
      //   $.ajax({
      //     url: "/upload",
      //     type: "post",
      //     data: formData,
      //     cache: false,
      //     contentType: false,
      //     processData: false,
      //     success: function (data, jqXHR, textStatus) {},
      //   });
      // }

      function commit(data) {
        // 서버와 통신
        $.ajax({
          type: "post",
          url: "/writing",
          cache: false,
          contentType: false,
          processData: false,
          data: data,
          success: function (result) {
            if (result == "0") {
              alert("성공적으로 등록되었습니다.");
              location.href = "/";
            } else {
              alert("글 등록 실패");
            }
          },
        });
      }

      $("#commit").on("click", function () {
        const data = {
          writer: $("#writer").val(),
          id: $("#id").val(),
          title: $("#title").val(),
          content: $("#content").val(),
        };
        let formData = new FormData($("#fileForm")[0]);
        formData.append("writer", data.writer);
        formData.append("id", data.id);
        formData.append("title", data.title);
        formData.append("content", data.content);
        commit(formData);
      });

      function commit2(data) {
        let no = "${board.NO}";
        // 서버와 통신
        $.ajax({
          type: "post",
          url: "/board/" + no,
          dataType: "text",
          data: data,
          success: function (result) {
            if (result == "0") {
              alert("성공적으로 수정되었습니다.");
              location.href = "/";
            } else {
              alert("글 등록 실패");
            }
          },
        });
      }

      $("#commit2").on("click", function () {
        const data = {
          writer: $("#writer").val(),
          id: $("#id").val(),
          title: $("#title").val(),
          content: $("#content").val(),
        };
        commit2(data);
      });
    </script>
  </body>
</html>
