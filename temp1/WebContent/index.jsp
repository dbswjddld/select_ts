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
	<table border = "1">
	<thead>
		<tr>
			<th>tablespace name</th>
			<th>status</th>
			<th>total MB</th>
			<th>used MB</th>
			<th>free MB</th>
			<th>used percent</th>
		</tr>
	</thead>
		<c:forEach items="${list}" var="dto">
			<tr>
				<td>${dto.getTablespaceName()}</td>
				<td>${dto.getStatus()}</td>
				<td>${dto.getTotal()}</td>
				<td>${dto.getUsed()}</td>
				<td>${dto.getFree()}</td>
				<td>${dto.getUsedPer()} %</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>