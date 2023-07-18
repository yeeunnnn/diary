<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<!--  noticeOne에서 받아온 noticeNo 값!
	<a href="./updateNoticeForm.jsp?noticeNo=<noticeNo%>">수정</a>-->
<%
	/* 1. 유효성 검사 */
	//유효성 검사 추가의 결과물은. 내가 만족하지 않는 것의 분기까지.
	if(request.getParameter("noticeNo")==null){
		response.sendRedirect("./noticeList.jsp");
		return;
	}
		//값이 넘어오면 noticeNo에 값을 넣어주어라.
		int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
		System.out.println("넘어온 값:" + noticeNo );
		
	/* 2. DB */
	//(1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("updateNoticeForm DB 드라이버 실행 성공");
	//(2) conn으로 접속 연결 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("DB 접속 값: " + conn);
	//(3) 쿼리 만들기 (수정 페이지에 보여줄 값을 불러오기.)
	//너무 길어서 sql 변수에 sql문 저장
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ? ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);//stmt의 첫번째 물음표 값을 noticeNo로 바꾼다.
	System.out.println("noticeNo값 잘 받아옴: " + stmt);
	
	/* 3. 받아온 값 반영 */
	ResultSet rs = stmt.executeQuery();
	
	Notice notice = null;//int totalCnt; ArrayList<Notice> 일수도 있으니. 항상 한가지이지는 않음
	if(rs.next()){
		notice = new Notice();//선언
		notice.noticeNo = rs.getInt("notice_no");
		notice.noticeTitle = rs.getString("notice_title");
		notice.noticeContent = rs.getString("notice_content");
		notice.noticeWriter = rs.getString("notice_writer");
		notice.createdate = rs.getString("createdate");
		notice.updatedate = rs.getString("updatedate");
	}
		
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateNoticeForm</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	 	table, td {table-layout: fixed}
	 	.center {text-align:center}
	 	.none {text-decoration: none;}
	 	.black {color:#000000; text-decoration: none;}
	</style>
</head>
<body>
	<div><!-- Navigation-->
		  <ul class="nav nav-tabs">	
              <li class="nav-item"><a class="nav-link" href="./home.jsp">홈으로</a></li>
              <li class="nav-item"><a class="nav-link" href="./noticeList.jsp">공지 리스트</a></li>
              <li class="nav-item"><a class="nav-link" href="./scheduleList.jsp">캘린더</a></li>
          </ul>
      </div>
    <div class="container mt-3" class="center">
	<!-- get과 post의 차이
	get: 값을 보여주며 넘길지(구글 검색창에서 보이고, 즐겨찾기에 추가하고 싶을 때)
	post: 가려서 넘김
		1.contents가 너무 많음. 주소창에 너무 많은 양이 보이니까.
		2. 수정하려면 비밀번호도 보여지는데, 보여주기 싫음-->
	<form action="./updateNoticeAction.jsp" method="post">

		<table class="table table-bordered">
			<tr class="center"><!-- 1행. -->
				<td colspan="2" class="table-danger"><h3>&#9986;공지 수정</h3></td>
			</tr>
			<tr><!-- 2행. 오류메세지 -->
				<td colspan="2" class="center">
					<%
						if(request.getParameter("msg") != null){
					%>
						<%="오류 발생: "+request.getParameter("msg")%>
						
					<%	
						//action페이지로 잘못된 접근이거나 null, 공백이면 안됨.		
						}
					%>
				</td>
			</tr>
			<tr class="center"><!-- 3행. 일치하는지 확인할 값 No, Pw -->
				<td>
					notice_no
				</td>
				<td><!-- where절에서 일치하는지 확인 -->
					<input type="number" name="noticeNo" value="<%=notice.noticeNo%>" readonly="readonly" class="center"><!-- 프로그램 안에서는 다 카멜 표현식. DB는 안먹으니까 언더바!(바꿔주는 라이브러리도 있음) -->
				</td>
			</tr>
			<tr class="center"><!-- 4행. -->
				<td>
					notice_pw
				</td>
				<td>
					<input type="password" name="noticePw" class="center">
				</td>
			</tr>
			<tr class="center"><!-- 5행. 실제 수정할 내용!! set 안에 적기-->
				<td>
					notice_title
				</td>
				<td>
					<input type="text" name="noticeTitle" value="<%=notice.noticeTitle%>" class="center">
				</td>
			</tr>
			<tr class="center"><!-- 6행. -->
				<td>
					notice_content
				</td>
				<td class="center">
					<textarea class="form-control" id="comment" rows="5" cols="80" name="noticeContent"><%=notice.noticeContent%></textarea>
				</td>
			</tr>
			<tr class="center"><!-- 7행. 값 받지 않음. input 태그안에 있는 것만 Action으로 보낼 수 있음! -->
				<td>
					notice_writer
				</td>
				<td>
					<%=notice.noticeWriter%>
				</td>
			</tr>
			<tr class="center"><!-- 8행. -->	
				<td>
					notice_create
				</td>
				<td>
					<%=notice.createdate%>
				</td>
			</tr>
			<tr class="center"><!-- 9행. update날짜는 Now로 값 받음 -->	
				<td>
					notice_update
				</td>
				<td>
					<%=notice.updatedate%>
				</td>
			</tr>
		</table>
		<div class="center">
			<button type="submit" class="btn btn-outline-secondary">수정</button>
		</div>
	</form>
</div>
</body>
</html>