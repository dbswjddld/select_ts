<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>tablespace</title>
	<script src = "https://code.jquery.com/jquery-3.4.1.js"></script>
	<script>
	$(document).ready(function(){
		$('input:radio[name=tablespace]').eq(0).attr("checked", true);
		// 첫 번째 라디오 자동 체크
		
		$("#updbtn").click(function(){
			$("#frm").attr("action","TSupdateForm.do");
			$("#frm").submit();
		});
		// 수정 버튼 클릭
		
		$("#delbtn").click(function(){
			var reply = confirm("삭제하시겠습니까?");
			if (reply == true) { // 확인
				$("#frm").attr("action", "TSdelete.do");
				$("#frm").submit();
			}
		});
		// 삭제 버튼 클릭
		
		$("#crebtn").click(function(){
			$("#frm").attr("action", "TScreateForm.do");
			$("#frm").submit();
		});
		// 생성 버튼 클릭
	});
	</script>
</head>
<body>
	<form id = "frm" method = "post">
	<table border = "1">
	<thead>
		<tr>
			<th></th>
			<th>tablespace name</th>
			<th>status</th>
			<th>total MB</th>
			<th>used MB</th>
			<th>free MB</th>
			<th>used percent</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="dto">
			<tr>
				<td><input type = "radio" id = "ts_radio" name = "tablespace" value = "${dto.getTablespaceName()}"></td>
				<td>${dto.getTablespaceName()}</td>
				<td>${dto.getStatus()}</td>
				<td>${dto.getTotal()}</td>
				<td>${dto.getUsed()}</td>
				<td>${dto.getFree()}</td>
				<td>${dto.getUsedPer()} %</td>
			</tr>
		</c:forEach>
	</tbody>
	</table>
	<input id = "updbtn" type = "button" value = "수정">
	<input id = "delbtn" type = "button" value = "삭제">
	<input id = "crebtn" type = "button" value = "생성">
	<div id = "show"></div>
	</form>
</body>
</html>