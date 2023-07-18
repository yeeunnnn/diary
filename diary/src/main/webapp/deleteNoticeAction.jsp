<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import= "java.sql.PreparedStatement" %>
<%
	//validation 요청값 유효성 검사. 안넘어오면 안됨
	if(request.getParameter("noticeNo") == null
	|| request.getParameter("noticePw") == null
	|| request.getParameter("noticeNo").equals("")
	|| request.getParameter("noticePw").equals("")) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	//디버깅 생략
	System.out.println(noticeNo + " <-- deleteNoticeAction Param noticeNo");
	System.out.println(noticePw + " <-- deleteNoticeAction Param noticePw");
	
	//delete from notice where notice_no=505 and notice_pw='1234' setString. 코드에서 물음표를 다른 글자로 치환하는 역할만 함.

	/*3. DB 생성 및 출력*/
	//(1) mariadb 사용할 것을 선언
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	//(2) 드라이버가 계속 돌아가게 접속(Connection와 DriverManager import)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("접속 성공" + conn);
	//(3) 만들고 싶은 쿼리대로 값을 받아와, 반영하기(PreparedStatement import)
	//쿼리 생성문이 너무 길어서 sql 변수에 저장해 사용.
	String sql="delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql); //stmt 변수에, 쿼리를 출력할 수 있게 준비시켜라.
	//물음표 값 지정해주기. now는 sql문(현재 날짜와 시간)
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	System.out.println(stmt + " <-- deleteNoticeAction stmt");
	
	//stmt.executeUpdate();//원래는 ResultSet으로 누른 값을 출력할 때 사용하는데, 여기서는 select 할 것이 없어 생략한다.
	int row = stmt.executeUpdate(); //만든 쿼리 값을 정수형태로 row 변수에 저장해 디버깅에 사용한다.
	System.out.println(row + " <-- deleteNoticeAction row");
	
	if(row == 0){ //비밀번호 틀려서 삭제행이 0행
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo); //화면에서 틀린 것 NoticeNO값 넘겨주기.
	} else {
		response.sendRedirect("./noticeList.jsp");
	}
	
%>