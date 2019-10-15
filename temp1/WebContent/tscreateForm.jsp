<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>create tablespace</title>
	<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
	<script>
	function formCheck(){
		var tsname = $("#tsname").val();
		var datafile = "";
		$("tbody>tr").each(function(){
			var path = $(this).find("#path").val();
			var filename = $(this).find("#filename").val();
			var size = $(this).find("#size").val();
			var sizeunit = $(this).find("#sizeunit").val();
			
			if(isNaN(size)){
				alert("용량은 숫자만 입력할 수 있습니다!");
				return false;
			}
			
			datafile += " '" + path + "\\" + filename + ".dbf' size " + size + sizeunit + ","
		});
		datafile = datafile.substring(0, datafile.length-1); // 맨 마지막 , 제거
		// 데이터파일 입력한 값을 '경로\데이터파일명.dbf' 용량, ... 로 양식에 맞게 만들어 datafile의 값에 저장
		
		var type = $("#type:checked").val(); // 타입 뭘 체크했는지 확인
		
		var tstype = "";
		var filetype = " datafile ";
		var plus = " LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO";
		// permanent 타입인 경우
		
		if(type == 'temporary') { // temporary 타입인경우
			tstype = "temporary ";
			filetype = " tempfile ";
			plus = " EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M";
		} else if (type == 'undo') { // undo 타입인경우
			tstype = "undo ";
			plus = " RETENTION NOGUARANTEE";
		}
		
		var sql = "create " + tstype + "tablespace " + tsname + filetype + datafile + plus;
		$("#sql").val(sql);
		console.log(sql);
	}
	
	// 데이터파일 추가
	function add(){
		var $path = $("<input>").attr("type","text").attr("id","path").attr("required",true); // 경로 입력칸
		var $filename = $("<input>").attr("type","text").attr("id","filename").attr("required",true); // 이름 입력칸
		var $size = $("<input>").attr("type","text").attr("id","size").attr("required",true); // 용량 입력칸
		var $sizeunit = $("<select>").attr("id","sizeunit")
									.append($("<option>").val("M").text("MB"))
									.append($("<option>").val("K").text("KB"))
									.append($("<option>").val("G").text("GB"))
									.append($("<option>").val("T").text("TB")); // 용량 단위
		var $btn = $("<input>").attr("type","button").attr("id","delbtn").val("삭제")
							.click(function(){	$(this).parent().parent().remove();	}); // 삭제 버튼
		
		var $tr = $("<tr>").append($("<td>").append($path))
						.append($("<td>").append($filename))
						.append($("<td>").append($size).append($sizeunit))
						.append($("<td>").append($btn)); // 위의 칸들을 하나의 tr로 붙임
		$("#tb1").append($tr); // 테이블에 tr 추가
	}
	
	$(function(){
		$("#btn").click(formCheck);
		$("#addbtn").click(add);
	});
	</script>
</head>
<body>
	<form onsubmit = "formCheck()" method = "post" action = "TScreate.do">
	<input type = "hidden" id = "sql" name = "sql">
		<h1>테이블 스페이스</h1>
		테이블 스페이스 이름 <input type = "text" id = "tsname" required> <br>
		타입
		<input type = "radio" id = "type" name = "type" value = "permanent" checked> Permanent
		<input type = "radio" id = "type" name = "type" value = "temporary"> Temporary
		<input type = "radio" id = "type" name = "type" value = "undo"> Undo
		
		<h1>데이터 파일</h1>
		
		<table border = "1" id = "tb1">
			<thead>
				<tr>
					<th>경로</th>
					<th>이름</th>
					<th>용량</th>
					<th><input type = "button" id = "addbtn" value = "추가"></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type = "text" id = "path" required value = "C:\oraclexe\app\oracle\oradata\XE"></td>
					<td><input type = "text" id = "filename" required></td>
					<td>
						<input type = "text" id = "size" required>
						<select id = "sizeunit">
							<option value = "M">MB</option>
							<option value = "K">KB</option>
							<option value = "G">GB</option>
							<option value = "T">TB</option>
						</select>
					</td>
					<td></td>
				</tr>
			</tbody>
		</table>
		<input type = "submit" id="btn" value = "생성">
	</form>
</body>
</html>