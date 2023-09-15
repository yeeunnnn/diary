<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
/* scheduleList에서 받아온 string 타입의 년/월/일 */

/*1. 한글 인코딩 : form action 타입이 post일 때, 넘어오는 값이 한글이 있을 때. */
	request.setCharacterEncoding("utf-8");

/*2. 유효성 검사 */
	//숫자가 아닌 값(오타 등)이 들어옴을 방지. 공백이면 다시 List 페이지로 보내기
	if(request.getParameter("y")==null
	|| request.getParameter("m")==null
	|| request.getParameter("d")==null
	|| request.getParameter("y").equals("")
	|| request.getParameter("m").equals("")
	|| request.getParameter("d").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	//아니면 받아온 값을 이 jsp에서 사용할 변수에 받기
	int y = Integer.parseInt(request.getParameter("y"));
	//자바 API에서 12월 11일을 넘겨주면 -> mariadb에서는 12월 12일.
	int m = Integer.parseInt(request.getParameter("m"))+1; //0부터 시작하기 때문에 1을 더함. 
	int d = Integer.parseInt(request.getParameter("d"));
	//디버깅
	System.out.println("scheduleListByDate parameter y: "+y);
	System.out.println("scheduleListByDate parameter m: "+m);
	System.out.println("scheduleListByDate parameter d: "+d);
	
	//input type에 월과 일이 원 값은 String인데 int라서 오류가 나니까 앞/뒤에 ""붙여줌.
	String strM = m+"";
	if(m<10){
		strM="0"+strM;
	}
	String strD = d+"";
	if(d<10) {
		strD ="0"+strD;
	}
	
/* 3. DB */
	//(1) DB 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("scheduleListByDate db driver");
	//(2) DB 접속 (connection, driverManager import)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("scheduleListByDate db is connected: ");
	//(3) 쿼리 만들기
	String sql = "select schedule_number scheduleNumber, schedule_date scheduleDate, schedule_time scheduleTime, schedule_color scheduleColor, schedule_memo scheduleMemo, createdate, updatedate, schedule_pw schedulePw from schedule where schedule_date = ? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//물음표 값 변수로 설정.
	stmt.setString(1, y + "-" + strM + "-" + strD);
	System.out.println("scheduleListByDate stmt 출력: "+stmt);
	//(4)쿼리를 읽을 수 있는 ResultSet 실행
	ResultSet rs = stmt.executeQuery();
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNumber = rs.getInt("scheduleNumber");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleColor = rs.getString("scheduleColor");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		s.schedulePw = rs.getString("schedulePw");
		scheduleList.add(s);
	}
	
/* Redirection */	
	//action이 아니니까 Redirect로 보내줄 곳없음.
	
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>scheduleListByDate</title>
	<style>
		table, th, td {text-align:center; table-layout: fixed}
		.center {text-align:center}
		.right {text-align:right}
	</style>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
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
	
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-bordered">
			<tr class="center">
				<td colspan="2" class="table-danger">
					<h2 class="center">&#9997;일정 입력</h2>
				</td>
			</tr>
			<tr>
				<th>schedule_date</th>
				<td>
					<input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly" class="center">
					<!-- disabled면 안되고, readonly면 됨. -->
				</td>
			</tr>
			<tr>
				<th>schedule_time</th>
				<td>
					<input type="time" name="scheduleTime" class="center">
				</td>
			</tr>
			<tr>
				<th>schedule_color</th>
				<td>
					<input type="color" name="scheduleColor" value="#000000" class="center">
				</td>
			</tr>
			<tr>
				<th>schedule_memo</th>
				<td><textarea class="form-control" rows="5" name="scheduleMemo"></textarea></td>
			</tr>
			<tr>
				<th>schedule_pw</th>
				<td><input type="password" name="schedulePw" class="center"></td>
			</tr>
			<tr>
				<td colspan="2"><button type="submit" class="btn btn-outline-danger">입력</button></td>
			</tr>
		</table>
	</form>
	<div> </div>
	<table class="table table-bordered">
		<tr class="center">
			<td colspan="6" class="table-danger">
				<h2 class="center">&#128197;<%=y%>년 <%=m%>월 <%=d%>일 일정 목록</h2>
			</td>
		</tr>
		<tr>
			<th>schedule_time</th>
			<th>schedule_memo</th>
			<th>createdate</th>
			<th>updatedate</th>
			<th>수정</th><!-- 상세보기를 하지 않을 것. 페이징을 한다면 최소 20개 이상의 목록..하루 스케줄 20개인 사람이 없을테니... -->
			<th>삭제</th>
		</tr>
		<%
			for(Schedule s : scheduleList){
		%>
			<tr>
				<td><%=s.scheduleTime%></td>
				<td><%=s.scheduleMemo%></td>
				<td><%=s.createdate%></td>
				<td><%=s.updatedate%></td>
				<td><a href="./updateScheduleForm.jsp?scheduleNumber=<%=s.scheduleNumber%>" class="btn btn-outline-secondary">수정</a></td><!--  pw 만드려면 테이블에 pw 추가. 기본값 '1234' -->
				<td><a href="./deleteScheduleForm.jsp?scheduleNumber=<%=s.scheduleNumber%>" class="btn btn-outline-secondary">삭제</a></td>
			</tr>
		<%
			}
		%>
	</table>
	</div>
</body>
</html>