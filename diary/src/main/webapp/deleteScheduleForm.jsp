<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// scheduleListByDate에서 넘어온 값: scheduleNumber
	
	/* 유효성 검사 */
	if(request.getParameter("scheduleNumber")==null
	|| request.getParameter("scheduleNumber").equals("")){
		response.sendRedirect("./scheduleListByDate.jsp");
		return;
	}

	//디버깅
	int scheduleNumber = Integer.parseInt(request.getParameter("scheduleNumber"));
	System.out.println("deleteScheduleAction scheduleNumber: "+scheduleNumber);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteScheduleForm</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	 	table, td {table-layout: fixed}
	 	.center {text-align:center}
	</style>
</head>
<body>
	 <div><!-- 상단 네비게이션 -->
		  <ul class="nav nav-tabs">	
              <li class="nav-item"><a class="nav-link" href="./home.jsp">홈으로</a></li>
              <li class="nav-item"><a class="nav-link" href="./noticeList.jsp">공지 리스트</a></li>
              <li class="nav-item"><a class="nav-link" href="./scheduleList.jsp">캘린더</a></li>
          </ul>
     </div>  
     <div class="container mt-3"> 
		<form action="./deleteScheduleAction.jsp" method="post">
			<table class="table table-bordered table-sm">
				<tr class="center">
					<td colspan="2" class="table-danger"><h2>&#10006;일정 삭제</h2></td>
				</tr>
				<tr><!-- 공백이라서 처리 불가능 한 값을 Action에서 처리해, Form에서 오류메세지로 표시해줌 -->
					<%
						if(request.getParameter("msg")!=null){
					%>
							<td colspan="2" class="center"><%="오류: "+request.getParameter("msg")%></td>
					<%
						}
					%>
				</tr>
				<tr class="center">
					<td>schedule_number</td><!-- number값은 달라지면 안되기 때문에, 입력하지 못하도록 readonly -->
					<td><input type="number" name="scheduleNumber" value="<%=scheduleNumber%>" readonly="readonly" class="center"></td>
				</tr>
				<tr class="center">
					<td>schedule_pw</td><!-- where절에서 Pw같은지 확인할 것. -->
					<td><input type="password" name="schedulePw" class="center"></td>
				</tr>
				<tr class="center">
					<td colspan="2"><button type="submit" class="btn btn-outline-secondary">삭제</button></td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>