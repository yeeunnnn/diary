<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import= "java.sql.PreparedStatement" %>

<%
	//깨질 수 있으니 문자값 받을 땐 제일 먼저 인코딩 해주기.
	request.setCharacterEncoding("utf-8");//post방식
	
	//validation
	if(request.getParameter("noticeTitle") == null
		|| request.getParameter("noticeContent") == null
		|| request.getParameter("noticeWriter") == null
		|| request.getParameter("noticePw") == null
		|| request.getParameter("noticeTitle").equals("")
		|| request.getParameter("noticeContent").equals("")
		|| request.getParameter("noticeWriter").equals("")
		|| request.getParameter("noticePw").equals("") ){ //
		
		response.sendRedirect("./insertNoticeForm.jsp"); //명시한 주소로 가라고 지시한 것. 계~속 진행됨. 끝나고 싶으면 return을 꼭 써줘야함.
		//home.jsp에서 넘어온 값 유효성 검사. (만약 이래도 넘어온 값이 공백이라면 주소창에 get방식으로 유효성 검사해줘야함.) client에서 한번(자바스크립트, 클라이언트 내에서 이벤트 담당. 버튼 눌렀을 때 공백있는지 검색), backend에서 하는 것도 한번.
		return;
	}
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");


	//값들을 DB 테이블에 입력
	
	/*
	String sql = "insert "
		"insert into notice
		(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate
		) values('" + noticeTitle + "', '" ++ ')" //문자열이라 "" 붙여줘야함. int 값이면 작은따옴표 없애야.
	*/ //누군가 PreparedStatement를 만들었기 때문에, 매개변수로 문자열 쿼리 보낼때 값을 넣지 말고 물음표로 대신해도 됨.
	
	/*
	insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate
	) values(?,?,?,?,NOW(),NOW()) //NOW()는 시간까지. current는 날짜만. ?는 값에 대해서만 넣는 것.	
	*/
	
	//1. db 쓸 거다
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("insertNoticeAction 드라이버 로딩 성공");
	
	//2) mariadb에 로그인 후 접속정보 반환받기
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234"); //반환타입 conn. 대문자 클래스이름.static메소드. "여기 안에"
	System.out.println("insertNoticeAction conn 성공" + conn); //참조타입(String 등), 기본타입이 아니면 이상한 숫자:메모리 숫자 나옴. @ 뒤에는 주소를 암호화시킨 값.
	
	//3)쿼리 생성.
	String sql="insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,NOW(),NOW())";//긴 내용이라 변수안에 집어넣기.
	PreparedStatement stmt = conn.prepareStatement(sql);

	//물음표(?) 4개에 대해서.
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	int row = stmt.executeUpdate();// row는 디버깅용. 1이면 1행 입력 성공. 0이면 입력된 행이 없는거.
	//conn.commit(); //안해도 됨(conn.setAutoCommit(true) true가 디폴트값.) "최종적으로 반영 하세요" 하는것. select는 원래 데이터를 가져와서 메모리에 있는 걸 쓰는 건데 insert는 메모리에만 데이터 입력해놓은것임. 최종 반영을 해줘야함. 아니면 반영되어있지만 실제 물리적 파일에 저장하지 말라고 하는게 rollback.
	//확인 row 값 이용한 디버깅
	System.out.println("insertNoticeAction row 성공" + row);

	//redirection
	response.sendRedirect("./noticeList.jsp");//입력된 값을 List에 보내라.
%>
