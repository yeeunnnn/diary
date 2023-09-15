<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//validation 요청값 유효성 검사. 안넘어오면 안됨
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo +" <-- deleteNoticeForm Param noticeNo");//deleteNoticeForm에서 Parameter값 noticeNo를 사용하기 때문에.
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteNoticeForm</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	 	table, td {table-layout: fixed}
	 	.center {text-align:center}
	 	.none {text-decoration: none;}
	</style>
</head>
<body>
	<div><!-- Navigation-->
		  <ul class="nav nav-tabs">	
              <li class="nav-item"><a class="nav-link" href="./home.jsp">홈으로</a></li>
              <li class="nav-item"><a class="nav-link" href="./noticeList.jsp">노트 리스트</a></li>
              <li class="nav-item"><a class="nav-link" href="./scheduleList.jsp">캘린더</a></li>
          </ul>
      </div>
	<div class="container mt-3">
	<form action="./deleteNoticeAction.jsp" method="post">
		<table class="table table-bordered">
			<tr class="center">
				<td colspan="2" class="table-danger"><h3>&#10006;노트 삭제</h3></td>
			</tr>
			<tr class="center">
				<td>note_no</td><!-- text 타입으로 하면 String과 int가 같지 않아 오류가 남.
				<td><input type="text" name="noticeNo" value="< %=noticeNo%>"></td>-->
			<td>
				<input type="number" name="noticeNo" value="<%=noticeNo%>" readonly="readonly" class="center">
			</td>
			</tr>
			<tr class="center">
				<td>note_pw</td>
				<td><input type="password" name="noticePw" class="center"></td>
			</tr>
			<tr>
				<td colspan="2" class="center">
				<button type="submit" class="btn btn-outline-secondary">삭제</button>
			</td>
			</tr>
		</table>	
	</form>
	</div>	
</body>
</html>