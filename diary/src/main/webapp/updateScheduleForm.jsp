<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	/* scheduleListByDate.jsp 에서 scheduleNumber 값을 받아옴 */
	
/* 1. 한글 인코딩 */
	request.setCharacterEncoding("utf-8");

/* 2. 유효성 검사 */
	//만약 받아온 scheduleNumber값이 null or 공백이면 다시 scheduleListByDate로 보내기.
	if(request.getParameter("scheduleNumber")==null
		|| request.getParameter("scheduleNumber").equals("")) {
		response.sendRedirect("./scheduleListByDate.jsp?");
		return;
	}
	//그렇지 않으면 변수에 Number 값을 받아 사용.
	int scheduleNumber = Integer.parseInt(request.getParameter("scheduleNumber"));
	System.out.println("updatescheduleForm scheduleNumber: " +scheduleNumber );

/* 3. DB에서 수정할 값 불러오기(원래 입력되어져 있는 값을 보여주고자) */
	//(1) DB 드라이버 로딩 roading? loading?
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("updatescheduleForm driver");
	//(2) DB 접속 유지(Connection, DriverManager import)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("updatescheduleForm is Connected: "+conn);
	//(3) 쿼리 생성(select로 읽기만 하기.)
	String sql = "select schedule_number scheduleNumber, schedule_date scheduleDate, schedule_time scheduleTime, schedule_color scheduleColor, schedule_memo scheduleMemo, createdate, updatedate from schedule where schedule_number=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("updatescheduleForm stmt: "+stmt);
	//(4) 쿼리 속성을 변수로 변경
	stmt.setInt(1, scheduleNumber);
	System.out.println("stmt 변경된 scheduleNumber: "+stmt);
	
/* 쿼리 반영 */
	//읽기만 하려고 하면 executeupdate아니고 executeQuery.
	ResultSet rs = stmt.executeQuery();
	System.out.println("scheduleNumber executeQuery stmt: "+stmt);
	
	Schedule schedule = null;
	if(rs.next()){
	schedule = new Schedule();
	schedule.scheduleNumber = rs.getInt("scheduleNumber");
	schedule.scheduleDate = rs.getString("scheduleDate");
	schedule.scheduleTime = rs.getString("scheduleTime");
	schedule.scheduleColor = rs.getString("scheduleColor");
	schedule.scheduleMemo = rs.getString("scheduleMemo");
	schedule.createdate = rs.getString("createdate");
	schedule.updatedate = rs.getString("updatedate");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateScheduleForm</title>
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
	<!-- Navigation-->
      <div>
		  <ul class="nav nav-tabs">	
              <li class="nav-item"><a class="nav-link" href="./home.jsp">홈으로</a></li>
              <li class="nav-item"><a class="nav-link" href="./noticeList.jsp">노트 리스트</a></li>
              <li class="nav-item"><a class="nav-link" href="./scheduleList.jsp">캘린더</a></li>
          </ul>
      </div>
		<div class="container mt-3">
			<form action="./updateScheduleAction.jsp" method="post">
				<table class="table table-bordered table-sm">
					<tr class="table-danger">
						<td colspan="2" class="center"><h2>&#9986;일정 수정</h2></td>
					</tr>
					<tr class="center">
					<%
						if(request.getParameter("msg")!= null){
					%>
							<td colspan="2"><%="오류: "+request.getParameter("msg")%></td>
					<%			
							}
					%>
					</tr>
					<tr class="center"><!-- number는 고치지 못하게. where 절에서 일치하는지 확인-->
						<td>schedule_number</td>
						<td>
							<input type="number" name="scheduleNumber" value="<%=schedule.scheduleNumber%>" readonly="readonly" class="center">
						</td>
					</tr>
					<tr class="center"><!-- number말고는 새로 입력할 수 있도록. Placeholder처럼 intput에 기존에 입력된 값(쿼리)를 보여줌. -->
						<td>schedule_date</td>
						<td>
							<input type="date" name="scheduleDate" value="<%=schedule.scheduleDate%>" class="center">
						</td>
					</tr>
					<tr class="center">
						<td>schedule_time</td>
						<td>
							<input type="time" name="scheduleTime" value="<%=schedule.scheduleTime%>" class="center">
						</td>
					</tr>
					<tr class="center">
						<td>schedule_color</td>
						<td>
							<input type="color" name="scheduleColor" value="<%=schedule.scheduleColor%>" class="center">
						</td>
					</tr>
					<tr class="center">
						<td>schedule_memo</td>
						<td><!-- textarea 안에는 value가 들어가지 못함. 밖에 표현식으로 써주기. -->
							<textarea class="form-control" rows="5" id="comment" name="scheduleMemo"><%=schedule.scheduleMemo%></textarea>
						</td>
					</tr>
					<tr class="center"><!-- where 절에서 일치하는지 확인 -->
						<td>
							notice_pw
						</td>
						<td>
							<input type="password" name="schedulePw" class="center"><!-- 프로그램 안에서는 다 카멜 표현식. DB는 안먹으니까 언더바!(바꿔주는 라이브러리 있음) -->
						</td>
					</tr>
					<tr class="center">
						<td>createdate</td>
						<td>
							<%=schedule.createdate%>
						</td>
					</tr>
					<tr class="center"><!-- 수정한 시간은 다 다르니까 Action에서 now로 수정함 -->
						<td>updatedate</td>
						<td>
							<%=schedule.updatedate%>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="center"><button type="submit" class="btn btn-outline-secondary">수정</button></td>
					</tr>
				</table>
			</form>
		</div>
</body>
</html>