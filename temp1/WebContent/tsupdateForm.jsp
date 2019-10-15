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
		$(".trupd").click(trEdit);		// 기존 데이터파일 수정하기
		$("#addbtn").click(trAdd);
	});
	function trAdd(){ // 행 추가
		$("#addbtn").attr("disabled", true);
	
		var $filename =  $("<input>").attr("type","text").attr("id","newFilename"); // 이름 입력칸
		var $size = $("<input>").attr("type","text").attr("id","newSize"); // 용량 입력칸
		var $sizeunit = $("<select>").attr("id","newSizeunit")
									.append($("<option>").val("M").text("MB"))
									.append($("<option>").val("K").text("KB"))
									.append($("<option>").val("G").text("GB"))
									.append($("<option>").val("T").text("TB")); // 용량 단위
		var $okbtn = $("<input>").attr("type","button").attr("id","okbtn").val("수정완료").click(trAddOk);
		var $canbtn = $("<input>").attr("type","button").attr("id","canbtn").val("취소").click(trAddCan);

		$("#tb1").append($("<tr>")
					.append($("<td>").append($filename).append("<br>").append("경로\\파일이름.dbf 형식으로 작성하시오"))
					.append($("<td>").append($size))
					.append($("<td>").append($sizeunit))
					.append($("<td>").append($okbtn).append($canbtn))
				);
	} // 행 추가
	
	function trAddOk(){
		$("#addbtn").attr("disabled",false); // tr 추가 버튼 활성화
		
		var filename = $("#newFilename").val();
		var size = $("#newSize").val();
		var sizeunit = $("#newSizeunit").val();
		var tablespace = "${ts.getTablespaceName()}";
		
		sql += "ALTER TABLESPACE " + tablespace + " ADD DATAFILE '" + filename + "' SIZE " + size + sizeunit + ";";
		
		$("tr:last").remove();
		var $tr = $("<tr>").append($("<td>").text(filename))
							.append($("<td>").text(size))
							.append($("<td>").text(sizeunit))
							.append($("<td>").append($("<input>").attr("type","button").attr("class","trupd").val("용량수정").click(trEdit)));
		$("#tb1").append($tr);
	}
	
	function trAddCan(){ // 행 추가를 취소했을 때
		$("#addbtn").attr("disabled",false);
		$("tr:last").remove();
	}
	
	function trEdit(){ // 수정하기 버튼 클릭
		//$(this).parent().parent().find("td:eq(1)");
		var oldValue = $(this).parent().parent().find("td:eq(1)").text(); // 기존 size
		
		var $sizeunit = $("<select>").attr("id","sizeunit")
						.append($("<option>").val("M").text("MB"))
						.append($("<option>").val("K").text("KB"))
						.append($("<option>").val("G").text("GB"))
						.append($("<option>").val("T").text("TB")); // 용량 단위

		$(this).parent().parent().find("td:eq(1)")
				.empty()
				.append($("<input>").attr("type","text").attr("id","size").val(oldValue));
		// 용량td 수정
		$(this).parent().parent().find("td:eq(2)")
				.empty()
				.append($sizeunit);
		
		$(this).parent().parent().find("td:eq(3)")
				.empty()
				.append($("<input>").attr("type","button").attr("id","trupd2").val("수정완료"))
				.append($("<input>").attr("type","button").attr("id","trcancel").val("취소하기"));
		// 버튼 td 수정
		 
		$(".trupd").attr("disabled", true); // 다른 행의 '용량수정' 버튼 비활성화
		
		$("#trupd2").click(function(){ // 수정완료 버튼 클릭
			var size = $(sizetd).find("#size").val();
			var sizeunit = $("#sizeunit").val();
			var filename = $(this).parent().parent().find("td[id='filename']").text();
			
			sql += "ALTER DATABASE DATAFILE '" + filename + "' RESIZE " + size + sizeunit + ";";
			
			$(".trupd").attr("disabled", false); // 다른 행의 '용량수정' 버튼 활성화
			
			$(this).parent().parent().find("td:eq(1)")	// 사이즈 열 원래대로 (새로 입력한 값으로 대체)
					.empty()
					.text(size);
			
			$(this).parent().parent().find("td:eq(2)")
					.empty()
					.text(sizeunit);
			
			$(this).parent()	// 버튼 열 원래대로
					.empty()
					.append($("<input>").attr("type","button").attr("class","trupd").val("용량수정").click(trEdit));
			
		});  // 수정완료 버튼 클릭
		
		$("#trcancel").click(function(){	// 취소하기 버튼 클릭
			$(".trupd").attr("disabled", false); // 다른 행의 '용량수정' 버튼 활성화
			
			$(this).parent().parent().find("td:eq(1)")	// 사이즈 열 원래대로 (새로 입력한 값으로 대체)
				.empty()
				.text(oldValue);
			
			$(this).parent().parent().find("td:eq(2)")
					.empty()
					.text("M");
			
			$(this).parent()	// 버튼 열 원래대로
				.empty()
				.append($("<input>").attr("class","trupd").attr("type","button").val("용량수정").click(trEdit));

		});	// 취소하기 버튼 클릭
	}
	
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
					<th>용량</th>
					<th>용량 단위</th>
					<th></th>
				</tr>
			</thead>
			
			<tbody>
			<c:forEach items = "${df}" var = "df">
				<tr>
					<td id = "filename">${df.getFileName()}</td>
					<td id = "sizetd">${df.getBytes()}</td>
					<td>M</td>
					<td id = "btntd">
						<input class = "trupd" type = "button" value = "용량수정">
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		<input type = "button" id = "updbtn" value = "수정">
	</form>
</body>
</html>