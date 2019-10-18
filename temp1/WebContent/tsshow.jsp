<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Insert title here</title>
	</head>
<body>
	<h1>테이블 스페이스</h1>
		이름 ${ts.getTablespaceName()}<br>
		타입 ${ts.getContents()}<br>
		상태  ${ts.getStatus()}
	
	<h1>데이터 파일</h1>
	<table border = "1" id = "tb1">
			<thead>
				<tr>
					<th>이름</th>
					<th>전체 용량</th>
					<th>사용량</th>
				</tr>
			</thead>
			
			<tbody>
			<c:forEach items = "${df}" var = "df">
				<tr>
					<td>${df.getFileName()}</td>
					<td>${df.getBytes()}M</td>
					<td></td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
</body>
</html>