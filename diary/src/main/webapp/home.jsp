<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="vo.*" %>
<%
	//(1) DB 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("home DB Driver");
	//(2) Connection 접속 유지
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("home DB conn: "+conn);
	//(3) 공지 사항 쿼리 생성
	String sql1="select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0,5"	; // 날짜순으로 최근 공지 5개
	PreparedStatement stmt1 = conn.prepareStatement(sql1);//문자열을 실제 mariadb가 읽을 수 있게.
	System.out.println("home stmt1: "+stmt1);
	//(3-1) 쿼리 읽을 수 있도록 반영
	ResultSet rs1 = stmt1.executeQuery();
	//Result rs 형 변환.
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs1.next()){
		Notice n = new Notice();
		n.noticeNo = rs1.getInt("noticeNo");
		n.noticeTitle = rs1.getString("noticeTitle");
		n.createdate = rs1.getString("createdate");
		noticeList.add(n);
	}
	//(4) 오늘 일정 쿼리 생성	
	String sql2 = "select schedule_number scheduleNumber, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,10) scheduleMemo from schedule where schedule_date = curdate() order by schedule_time asc";
	//(4-1) 쿼리 읽을 수 있도록 반영
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println("home stmt2: "+stmt2);
	ResultSet rs2 = stmt2.executeQuery();
	//(4-2) resultset을 vo타입으로 변경
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs2.next()){
		Schedule s = new Schedule();
		s.scheduleNumber = rs2.getInt("scheduleNumber");
		s.scheduleDate = rs2.getString("scheduleDate");
		s.scheduleTime = rs2.getString("scheduleTime");
		s.scheduleMemo = rs2.getString("scheduleMemo");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
        <!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
		<style>
		 	table, td {table-layout: fixed}
		 	.center {text-align:center}
		 	.black {color:#000000; text-decoration: none;}
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
      <div class="container">
      		<div class="p-5 text-black text-center" >
	      		<table class="table">
		      		<tr>
		      			<th><h3 class="center">- 프로젝트 개요 -</h3></th>
		      			<th><h3 class="center">- 개발 내용 -</h3></th>
		      			<th><h3 class="center">- 개발 환경 -</h3></th>
		      		</tr>
		      		<tr>
		      			<td>
			 	 			<p>
				  				제목 : 다이어리<br>
				  				기간 : 2023-04-05 ~ 2023-04-30<br>
				  				인원 : 1명
							</p>
			 	 		</td>
			 	 		<td>
			 	 			<p>
				  				- 일정이 포함된 달력 구현 및 페이징<br>
				  	&nbsp;&nbsp;(Java 기본 API Calendar Class 사용)<br>
				  				- 일정 조회와 입력, 수정, 삭제 기능 구현<br>
				  				- 노트 조회와 입력, 수정, 삭제 및 페이징
							</p>
			 	 		</td>
			 	 		<td>
			 	 			<p>
				  				 Language: HTML5, CSS, Java, SQL<br>
								 Library: BootStrap5<br>
								 Database: MariaDB(3.1.3)<br>
								 WAS Apache: Tomcat(10.1.7)<br>
								 OS: window11<br>
								 TOOL: Eclipse, HeidiSQL
							</p>
			 	 		</td>
			 	 	</tr>	
				</table>
			</div>
			<table class="table"><!--첫번째 테이블. 날짜 순 최근 공지 5개-->
				<tr class="center">
					<td colspan="2">
						<h2>&#128227;노트</h2>
					</td>
				</tr>
				<tr class="center">
					<th class="table-danger">노트번호</th>
					<th class="table-danger">등록일</th>
				</tr>
			<%//resultset을 vo타입으로 바꾸어, for each문으로 ArrayList를 실행
				for(Notice n : noticeList){
			%>
				<tr class="center">
					<td>
						<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>" class="black">
							<%=n.noticeTitle%>
						</a>
					</td>
					<td>
						<%=n.createdate.substring(0, 10)%><!-- java와 mariadb의 날짜 타입이 같지 않음. createdate 데이터를 0부터 10개 가져와라(뒤에있는 시간 자르려고) -->
					</td>
					<%
					}
					%>
					</tr>
			</table>
			
			<br>
			<br>
			
			<table class="table"><!--첫번째 테이블. 날짜 순 최근 공지 5개-->
				<thead>
					<tr>
						<td colspan="3">
							<h2 class="center">&#128204;오늘의 일정</h2>
						</td>
					</tr>
					<tr class="center">
						<th class="table-danger">schedule_date</th>
						<th class="table-danger">schedule_time</th>
						<th class="table-danger">schedule_memo</th>
					</tr>
				</thead>
				<tbody>
			<%
				for(Schedule s : scheduleList){
			%>
				<tr class="center">
					<td>
						<%=s.scheduleDate%>
					</td>
					<td>
						<%=s.scheduleTime%>
					</td>
					<td>
						<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNumber%>" class="black">
							<%=s.scheduleMemo%>
						</a>
					</td>
				</tr>
			<%		
				}
			%>
				</tbody>
			</table>
	<div class="mt-5 p-4 text-white text-center"> </div>
	</div>			
</body>
</html>