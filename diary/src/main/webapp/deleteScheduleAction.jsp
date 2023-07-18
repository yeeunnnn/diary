<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	/* 
		deleteScheduleForm 으로부터
		받아온 값: scheduleNumber, schedulePw
		대조에 사용할 값: scheduleNumber, schedulePw
	*/
/* 1. 인코딩 */
	request.setCharacterEncoding("utf-8");

/* 2. 유효성 검사 */
	if(request.getParameter("scheduleNumber")==null
	|| request.getParameter("scheduleNumber").equals("")){
		response.sendRedirect("./scheduleListByDate.jsp");
		return;
	}

	String msg = null;
	if(request.getParameter("schedulePw")==null
	|| request.getParameter("schedulePw").equals("")){
		msg="schedule Pw is required";
	}
	
	if(msg != null){
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNumber="+request.getParameter("scheduleNumber")+"&msg="+msg);
		return;
	}
	//공백이 아니면 변수로 받기
	int scheduleNumber = Integer.parseInt(request.getParameter("scheduleNumber"));
	String schedulePw = request.getParameter("schedulePw");
	
/* 3. DB */
	//(1) DB 드라이버 실행
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("deleteScheduleAction Driver");
	//(2) DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("deleteScheduleAction Conn: "+conn);
	//(3) DB 삭제 쿼리 생성
	String sql = "delete from schedule where schedule_number = ? and schedule_pw = ? ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//물음표 값 변수로 바꿔주기
	stmt.setInt(1, scheduleNumber);//number는 readonly라서 새로운 값이 들어오지 않지만 대조하기 위함.
	stmt.setString(2, schedulePw);//입력받은 Pw값이 일치하면 Form으로 보내기.
	System.out.println("deleteScheduleAction stmt: "+stmt);
	//(4) 쿼리를 반영
	int row = stmt.executeUpdate();
	System.out.println("deleteScheduleAction row is: "+row);
	
/* 4. Redirect */
	if(row==0){ //삭제된 행이 없다면 Form에서 msg 오류메세지를 띄우도록 키 값을 보내줌.
		msg="incorrect Pw";
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNumber="+scheduleNumber+"&msg="+msg);
	} else { //삭제된 행을 확인할 수 있도록 '일정 목록'이 있는 scheduleListByDate로 보내기
		response.sendRedirect("./scheduleListByDate.jsp");
		return;
	}
	
%>
