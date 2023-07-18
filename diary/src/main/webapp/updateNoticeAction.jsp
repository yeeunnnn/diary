<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
/*updateNoticeForm에서 넘어온 값들을 DB에서 수정하고, List로 다시 보여준다.*/

/* 1. request 인코딩 설정 */
	request.setCharacterEncoding("utf-8");
/* 2. 4개의 값을 확인 (디버깅) */	
	System.out.println(request.getParameter("noticeNo")+"<--updateNoticeAction param noticeNo");
	System.out.println(request.getParameter("noticeTitle")+"<--updateNoticeAction param noticeTitle");
	System.out.println(request.getParameter("noticeContent")+"<--updateNoticeAction param noticeContent");
	System.out.println(request.getParameter("noticePw")+"<--updateNoticeAction param noticePw");

/* 3. 값이 넘어왔는지 2번 유효성 검정 + 뭐가 잘못넘어왔는지 확인하는 메세지 심기 */

/* 0. 유효성 검정 추가
   //3번 유효성 검정에서, noticeNo가 null이면 noticeForm으로 가는데, 어차피 noticeForm에서도 null은 List로 보내짐.*/
		if(request.getParameter("noticeNo")==null){
			response.sendRedirect("./noticeList.jsp");
			return;
		}

		//원래는 null이나 공백이면 List로 그냥 넘기기만 했는데, 뭐가 잘못됐는지 "알려주는 것".
		String msg = null; //에러 알려주는 변수 msg를 정의.
		if(request.getParameter("noticeNo")==null
		   || request.getParameter("noticeNo").equals(""))
		{//noticeNo는 사실상 null이나 공백일리가 없어서 이걸 지정할 필요는 없다.
		   msg = "noticeTitle is required";
		} else if (request.getParameter("noticePw")==null
		  || request.getParameter("noticePw").equals(""))
		{
		  msg = "noticePw is required";	  
		} else if (request.getParameter("noticeTitle")==null
		  || request.getParameter("noticeTitle").equals("")){
			msg = "noticeTitle is required";
		} else if ( request.getParameter("noticeContent")==null
		  || request.getParameter("noticeContent").equals("")){
			msg = "noticeContent is required";	
		}
		// 에러 메세지인 msg가 하나라도 null이 아니면, 즉 하나라도 해당이 되면 updateNoticeForm으로 다시 돌려보내고
		// 어디에 에러가 있는지 친절한 에러 메세지도 출력해줌.
		if(msg != null) { //updateNoticeForm으로 다시 가려면, No가 null값이면 안되니까 따로 noticeNo값을 보내줘야함.
			              //근데 아직 noticeNo 값을 변수에 받아오지를 않아서 request 메소드를 이용해서 먼저 받아와야함.
			response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+request.getParameter("noticeNo")+"&msg="+msg);
				return; //돌려보낸다.
		    }

/* 4. 값을 받았으면 모든 값을 변수로 정의해준다. (안하면 아래에서 sql에서 받아온 값을 -> 내가 입력한 변수값으로 수정하려고 할 때 에러남) */
		int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
		String noticePw = request.getParameter("noticePw");
		String noticeTitle = request.getParameter("noticeTitle");
		String noticeContent = request.getParameter("noticeContent");
			/* 굳이 불러올 필요가 없는 값들.
			String noticeWriter = request.getParameter("notice_writer");
			String createdate = request.getParameter("createdate");
			String updatedate = request.getParameter("updatedate");
			*/
		//확인. 무슨 값을 받아왔는지.
		System.out.println("deleteNoticeAction의 Param noticeNo: "+noticeNo);
		System.out.println("deleteNoticeAction의 Param noticePw: " + noticePw);
		System.out.println("deleteNoticeAction의 Param noticeTitle: " + noticeTitle);
		System.out.println("deleteNoticeAction의 Param noticeContent: " + noticeContent);
			/*애초에 받아오지도 못함
			System.out.println("deleteNoticeAction의 Param notice_writer: " + noticeWriter);
			System.out.println("deleteNoticeAction의 Param createdate: " + createdate);
			System.out.println("deleteNoticeAction의 Param updatedate: " + updatedate);
			*/
		

/* 5. 받은 값을 이용해서 DB를 수정시켜라 */
		//1. DB 실행하기
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("updateNoticeAction DB 드라이버 실행 성공");
		//2. conn으로 접속 연결 유지(Connection, DriverManager import)
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		System.out.println("DB 접속 값: " + conn);
		//3. 쿼리 만들기 (PreparedStatement import)
		//너무 길어서 sql 변수에 sql문 저장
		String sql = "update notice set notice_title=?, notice_content=?, updatedate=NOW() where notice_no=? and notice_pw=?";
		PreparedStatement stmt = conn.prepareStatement(sql); //sql 쿼리대로 conn에게 보낼 준비를 해라
		//DDL 수정문 관련: "update + 테이블 명 + set + 수정해야할 컬럼=?";
		//set 문장: 수정하고 싶은 값들
		stmt.setString(1, noticeTitle); 
		stmt.setString(2, noticeContent);
		//where 문장: 불러서 일치하는지 확인할 값. no는 수정 안되게 해놨고, pw는 받아도 set절에 안적어놨기 때문에 DB에 있는 값대로만 입력가능(일치). where절에서는 and를 써야함.
		stmt.setInt(3, noticeNo);
		stmt.setString(4, noticePw);
		System.out.println("수정 완료: " + stmt);
	
/* 6.제대로 수정이 되어서 출력되면, List로 보여주도록. */
		int row = stmt.executeUpdate();
		System.out.println("수정 성공한 행 수: " + row);

		//보여지는 페이지를 나눈다(분기한다 View)
		if(row==0){ //수정한 행이 없다면? 변화가 없으니 그 자리에 
			msg="incorrect noticePw";
			response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+noticeNo+"&msg="+msg);
		} else if(row==1) {// 수정한 행이 1이다 = 수정에 성공했다면 수정한 값을 One에 보여줘라.
			response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
		} /*else {
			System.out.println("error row값 : " +row);
		}*/

%>
