<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %><!-- select문 할 때만 쓰는거 -->
<%@ page import = "vo.*" %>
<%
	if(request.getParameter("noticeNo") == null){//null이면 실행이 안됨.
		response.sendRedirect("./noticeList.jsp"); //tomcat이 Response.response.머시기머시기 실행해줌.
										     //블록 끝낼 수 있어서 return문을 즐겨씀. null일 때 tomcat이 home으로 가라고 "말만" 한 것. "누가 보내는지는 모르지만" 끝내라.
		return;		//null이 아니면 return문을 만나지 않으니 계속 실행됨.
					//1) 코드 진행 종료 2)반환값을 남길 때
	}
		
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	//(1)
	Class.forName("org.mariadb.jdbc.Driver");//드라이브 로딩하는 거고, 첫번째로 해야함
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");//Connection 타입의 conn 변수 생성. 연결된 타입. 계속 00님과 통화가 유지될 수 있게. 전화 걸렸다고 휴대폰 버려버리면 안됨.
	//(2)
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ? ";//notice_no의 ?값을 조회.
	PreparedStatement stmt = conn.prepareStatement(sql); //쿼리가 만들어져야되는데, 물음표때문에 안만들어짐. 미완성된 statement. 실행전에 완성을 시켜야 stmt를 출력.
	stmt.setInt(1, noticeNo);//stmt의 첫번째 물음표 값을 noticeNo 변수로 바꾼다.
	System.out.println(stmt + "<--stmt");
	//(3)
	ResultSet rs = stmt.executeQuery();
	Notice notice = null;//int tatalCnt; ArrayList<Notice> 일수도 있으니. vo타입이 항상 한가지 이지는 않음.
	if(rs.next()){
		notice = new Notice();
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
	<title>noticeOne</title>
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
	<table class="table table-bordered">
		<tr class="center">
			<td colspan="2" class="table-danger"><h3>&#128220;노트 상세</h3></td>
		</tr>
			<tr class="center">
				<td>note_no</td>
				<td><%=notice.noticeNo%></td>
			</tr>
			<tr class="center">
				<td>note_title</td>
				<td><%=notice.noticeTitle%></td>
			</tr>
			<tr class="center">
				<td>note_content</td>
				<td><%=notice.noticeContent%></td>
			</tr>
			<tr class="center">
				<td>note_writer</td>
				<td><%=notice.noticeWriter%></td>
			</tr>
			<tr class="center">
				<td>createdate</td>
				<td><%=notice.createdate%></td>
			</tr>
			<tr class="center">
				<td>updatedate</td>
				<td><%=notice.updatedate%></td>
			</tr>
		</table>

	<div class="center">
		<a href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-outline-secondary">수정</a>
		<a href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-outline-secondary">삭제</a> <!-- 비밀번호 맞으면 삭제.-->
	</div>
</div>
</body>
</html>