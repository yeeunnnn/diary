<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%
/* 1. 인코딩. 한글 깨지지 않게. */
	request.setCharacterEncoding("utf-8");

/* 2. 유효성 검사 */
	if(request.getParameter("scheduleDate")==null   
	|| request.getParameter("scheduleTime")==null
	|| request.getParameter("scheduleColor")==null
	|| request.getParameter("scheduleMemo")==null
	|| request.getParameter("scheduleDate").equals("")
	|| request.getParameter("scheduleTime").equals("")
	|| request.getParameter("scheduleColor").equals("")
	|| request.getParameter("scheduleMemo").equals("")){
		response.sendRedirect("./scheduleListByDate.jsp");
		return;
	}
		/* 2.1 넘어온 값을 변수에 받아두기. */
		String scheduleDate = request.getParameter("scheduleDate");
		String scheduleTime = request.getParameter("scheduleTime");
		String scheduleColor = request.getParameter("scheduleColor");
		String scheduleMemo = request.getParameter("scheduleMemo");
		//값이 변수에 잘 받아졌는지 디버깅
		System.out.println(scheduleDate+"<-- insertScheduleAction parameter scheduleDate");
		System.out.println(scheduleColor+"<-- insertScheduleAction parameter scheduleColor: ");
		System.out.println(scheduleMemo+"<-- insertScheduleAction parameter scheduleMemo: ");
	
/* 3. DB */
	//(1) DB 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("insertScheduleAction db driver");
	//(2) DB 접속 (connection, driverManager import)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("insertScheduleAction db is connected: ");
	//(3) 쿼리 만들기
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_color, schedule_memo, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("insertScheduleAction Query: "+stmt);
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	System.out.println("정상 입력");
	//(4) 쿼리 변수값으로 수정. 수정은 executeUpdate 사용
	int row = stmt.executeUpdate();
	if(row==1){ //정상적으로 수정되었으면 행이 1.
		System.out.println("insertScheduleAction row: "+row);
	} else if(row==0){ //(5) 비정상적인 입력이면 0으로 알려주기.
		System.out.println("insertScheduleAction row error: "+row);
	}

	
/* 4. 수정 성공했으면 받았던 페이지로 다시 보내기 */
	//ListByDate에서 받을 때 월에 +1을 했음. 그러니 다시 ListByDate로 넘겨줄때는 자바 api쪽에 맞춰야되기 때문에 -1해서 줘야 됨.
	String y = scheduleDate.substring(0,4); //4 앞까지 잘라야함. 0123-56-89 : 0123 + 4(-) + 56 + 7(-) + 8
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1;//5부터 7 전까지 자르고, 그 값에 1을 빼면 아까 ListByDate에서 보여진 월로 표시됨
	String d = scheduleDate.substring(8);
	//년/월/일 값이 잘 변경+전달되었는지 디버깅
	System.out.println("insertScheduleAction y: "+y);
	System.out.println("insertScheduleAction m: "+m);
	System.out.println("insertScheduleAction d: "+d);
	//Redirect
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
%>
