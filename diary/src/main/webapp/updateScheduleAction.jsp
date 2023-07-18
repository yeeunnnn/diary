<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
/* 
	updateScheduleForm 으로부터
	받아온 값: scheduleNumber, scheduleDate, scheduleTime, scheduleColor, scheduleMemo, createdate, updatedate, schedulePw
	수정에 사용할 값: scheduleDate, scheduleTime, scheduleColor, scheduleMemo, updatedate(now)
	대조에 사용할 값: scheduleNumber, schedulePw
*/
	
/*1. 한글 인코딩 */
	request.setCharacterEncoding("utf-8");

/*2. 유효성 검사 (입력받아온 값만) */
	if(request.getParameter("scheduleNumber")==null
	||request.getParameter("scheduleNumber").equals("")){
		response.sendRedirect("./scheduleListByDate.jsp");
		return;
	}
	String msg = null;
	//받아온 값이 null이면 다시 Form으로 보내기
	if(request.getParameter("scheduleDate")==null
	||request.getParameter("scheduleDate").equals("")){
		msg = "scheduleDate is incorrect";		
	} else if(request.getParameter("scheduleTime")==null
	||request.getParameter("scheduleTime").equals("")){
		msg = "scheduleTime is incorrect";
	} else if(request.getParameter("scheduleColor")==null
	||request.getParameter("scheduleColor").equals("")){
		msg = "scheduleColor is incorrect";
	} else if(request.getParameter("scheduleMemo")==null
	||request.getParameter("scheduleMemo").equals("")){
		msg = "scheduleMemo is incorrect";
	} else if(request.getParameter("schedulePw")==null
	||request.getParameter("schedulePw").equals("")){
		msg = "schedulePw is incorrect";
	}

		if(msg != null){
			response.sendRedirect("./updateScheduleForm.jsp?scheduleNumber="+request.getParameter("scheduleNumber")+"&msg="+msg);
			return;
		}
	//null이 아니면 값을 변수에 받기
	int scheduleNumber = Integer.parseInt(request.getParameter("scheduleNumber"));
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	//디버깅
	System.out.println("updateScheduleAction의 param scheduleNumber: "+scheduleNumber);
	System.out.println("updateScheduleAction의 param scheduleDate: "+scheduleDate);
	System.out.println("updateScheduleAction의 param scheduleTime: "+scheduleTime);
	System.out.println("updateScheduleAction의 param scheduleColor: "+scheduleColor);
	System.out.println("updateScheduleAction의 param scheduleMemo: "+scheduleMemo);
	System.out.println("updateScheduleAction의 param schedulePw: "+schedulePw);
	
/* 3. DB 연결 및 수정 쿼리 */
	//(1) DB 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("updateScheduleAction Driver");
	//(2) Connection. DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("updateScheduleAction conn: "+conn);
	//(3) 쿼리 생성
	String sql="update schedule set schedule_date=?, schedule_time=?, schedule_color=?, schedule_memo=?, updatedate=NOW() where schedule_number=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setInt(5, scheduleNumber);
	stmt.setString(6, schedulePw);
	System.out.println("updateScheduleAction stmt 수정: "+stmt);
	
	//(4) 쿼리 반영
	int row = stmt.executeUpdate();
	System.out.println("row is: " + row);
	
	/* 4. 수정 성공했으면 받았던 페이지로 다시 보내기 */
	//ListByDate에서 받을 때 월에 +1을 했음. 그러니 다시 ListByDate로 넘겨줄때는 자바 api쪽에 맞춰야되기 때문에 -1해서 줘야 됨.
	String y = scheduleDate.substring(0,4); //0부터 4 앞까지 자르기. 0123-56-89 : 0123 + 4(-) + 56 + 7(-) + 8
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1;//5부터 7 전까지 자르고, 그 값에 1을 빼면 아까 ListByDate에서 보여진 월로 표시됨
	String d = scheduleDate.substring(8);
	//년/월/일 값이 잘 변경+전달되었는지 디버깅
	System.out.println("updateScheduleAction y: "+y);
	System.out.println("updateScheduleAction m: "+m);
	System.out.println("updateScheduleAction d: "+d);
	
/* 4. Redirect */
	if(row==0){//수정되지 않았다면
		msg="incorrect schedulePw";
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNumber="+scheduleNumber+"&msg="+msg);
	} else {//성공했다면
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	}

%>