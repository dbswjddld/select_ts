<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>update</title>
	<script src= "https://code.jquery.com/jquery-3.4.1.js"></script>
	<script>
	var sql = "";
	
	$(function(){
		dfChk();
		statusChk();
		$('input:radio[name=datafile]').eq(0).attr("checked", true);
		$("#updbtn").click(check);
		
		$("#trupd").click(function(){
			$(this).parent().parent().find("td:eq(1)").attr("style","background:gold");
			var $sizetd = $(this).parent().parent().find("td:eq(1)");
			var oldValue = $(sizetd).text(); // 기존 size
			
			var $sizeunit = $("<select>").attr("id","sizeunit")
							.append($("<option>").val("M").text("MB"))
							.append($("<option>").val("K").text("KB"))
							.append($("<option>").val("G").text("GB"))
							.append($("<option>").val("T").text("TB")); // 용량 단위

			$(sizetd).empty()
					.append($("<input>").attr("type","text").attr("id","size").val(oldValue))
					.append($sizeunit);
			// 용량td 수정
			
			/* var $btntd = $(this).parents().find("td[id='btntd']");
			$(btntd).empty()
					.append($("<input>").attr("type","button").attr("id","trupd").val("수정완료"))
					.append($("<input>").attr("type","button").attr("id","trcancel").val("취소하기"));
			 */// 버튼 td 수정
			
			$("#trupd").click(function(){
				var filename = $(this).parent().parent().find("td[id='filename']").text();
				var size = $(sizetd).find("#size").val();
				var sizeunit = $(sizetd).find("#sizeunit").val();
				console.log(filename);
				console.log(size);
				console.log(sizeunit);
			});
			// 수정완료 버튼 클릭
		});
		// 기존 데이터파일 수정하기
		
	});
	
	function trUpdate(filename, size){
		sql += "ALTER DATABASE DATAFILE '" + filename + "' RESIZE " + size;
	}
	// 기존의 데이터파일 '수정하기'버튼 클릭
	
	function statusChk(){
		switch("${ts.getStatus()}") {
		case "ONLINE":
			$("#online").attr("checked", true);
			break;
		case "OFFLINE":
			$("#offline").attr("checked", true);
			break;
		case "READ ONLY":
			$("#readonly").attr("checked", true);
		}
	}
	// 시작시 status를 체크
	
	function dfChk(){
		if($("tbody tr").length == 1) {
			$("#delbtn").attr("disabled", true);
		} else {
			$("#delbtn").attr("disabled", false);
		}
	}
	// 데이터파일 개수 체크 (한개면 삭제 버튼 비활성화)
	
	function getPath(filename){
		console.log(filename)
		var arr = filename.split("\\");
		var num = arr.length;
		var str = "";
		for(i = 0; i < num - 1; i++){
			str += arr(i);
			str += "\\";
		}
		return str;
	}
	// filename에서 경로와 이름 분리 -> 수정해야함 (filename에서 \가 완전히 사라진채로 옴...)
	
	function check(){
		var oldName = "${ts.getTablespaceName()}";
		var newName = $("#tsname").val();
		
		if(newName != oldName) {
			sql += "ALTER TABLESPACE " + oldName + " RENAME TO " + newName + ";";
		}
		// 테이블스페이스 이름 
		
		var status = $("input[name='status']:checked").val();
		if("${ts.getStatus()}" == "OFFLINE")
			sql += "ALTER TABLESPACE " + newName + " online;";
			// 오프라인 상태였다면, 먼저 온라인 상태로 바꾼다
		sql += "ALTER TABLESPACE " + newName + " " + status + ";";
		// 상태 변경 (상태 변하든 안변하든 실행 - 수정했을때만 바뀌게 하는 방법 없을까?)
		
		$("#sql").val(sql);
		$("#frm").attr("action", "TSupdate.do").submit();
		// submit
	}
	</script>
</head>
<body>
	<form name = "frm" id = "frm" method = "post">
		<input type = "hidden" name = "sql" id = "sql">
		<h1>테이블 스페이스</h1>
		이름 <input type = "text" id = "tsname" value = "${ts.getTablespaceName()}">
		상태  
			<input type = "radio" name = "status" id = "online" value = "read write">
				<label for = "online">read write</label>
			<input type = "radio" name = "status" id = "readonly" value = "read only">
				<label for = "readonly">read only</label>
			<input type = "radio" name = "status" id = "offline" value = "offline normal">
				<label for = "offline">offline</label>
		<h1>데이터 파일</h1>
		<input id = "addbtn" type = "button" value = "추가">
		<table border = "1" id = "tb1">
			<thead>
				<tr>
					<th>이름</th>
					<th>용량 (MB)</th>
					<th></th>
				</tr>
			</thead>
			
			<tbody>
			<c:forEach items = "${df}" var = "df">
				<tr>
					<td id = "filename">${df.getFileName()}</td>
					<td id = "sizetd">${df.getBytes()}</td>
					<td id = "btntd">
						<input id = "trupd" type = "button" value = "용량수정">
						<input id = "delbtn" type = "button" value = "삭제">
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		<input type = "button" id = "updbtn" value = "수정">
	</form>
</body>
</html>