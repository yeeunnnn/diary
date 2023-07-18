<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import= "java.util.*" %>
<%@ page import= "vo.*" %>

<%
	//요청 분석(currentPage, ...)
	//현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//페이지 당 출력할 행의 수
	int rowPerPage = 10;
	
	//시작 행 번호 구하기
	int startRow = (currentPage - 1) * rowPerPage;
	//int startRow = 0; //1page일때만 starRow가 0. 0부터 10개.
		/*
		 currentPage   startRow (rowPerPage 10일때)
		 1                 0  <-- (currentPage - 1)*rowPerPage
		 2                10
		 3                20
		 4                30
		*/
			
	//DB연결 설정
	
	//1) mariadb 프로그램을 사용가능하도록 장치드라이브를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	//2) mariadb에 로그인 후 접속정보 반환받기
	Connection conn = null;//maria db접속에 성공해서 필요한 정보를 가져올 수 있는 "접속 정보 타입". Conniction이 클래스. 그 안에 많은 메소드 있음.
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234"); //반환타입 conn. 대문자는 클래스이름. static메소드. "여기 안에" url
	System.out.println("conn 성공" + conn); //참조타입(String 등), 기본타입이 아니고, 이상한 숫자:메모리 숫자 나옴 //@뒤가 주소를 암호화시킨 값.

	//3)아래 '이전' '다음'에 관한 반복 쿼리. limit로 0부터 10개 가져옴
	PreparedStatement stmt = conn.prepareStatement("select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by notice_no desc limit ?, ?");
	System.out.println("stmt 성공" + stmt); //위 sql문 as 생략 가능하고 별명씀.
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	
	//DB연결 후 구한 데이터. 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();
	System.out.println("쿼리 실행 성공" + rs); 
	//자료구조(하나가 아닌 집합) ResultSet타입을 -> 일반적인 타입인 자바 배열 or 기본 API 안에있는 타입(List, Set(ex. hash set?. 순서가 없어서 for문을 쓸 수가 없는), Map)으로 변경.
	//가장 기본인 자바 배열은 만들기 전에 몇개 만들지 알아야 함.(정적배열)
	//ResultSet도 set. 기본 set도 결국 set이라서 반복 불가. 장점은 set은 절대 중복데이터가 안 들어옴.
	//ResultSet ->  ArrayList<Notice> | notice를 Array로 바꿔주겠다.
	ArrayList<Notice> noticeList = new ArrayList<Notice>();//처음 만들었으니까 사이즈가 0.
	//Result 1행이 하나의 Notice. 10행이니까 10번!
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");//이름 불일치하는 걸 보기 편하게 위에 sql문에서 as 별칭으로 바꿔주기.
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);//notice리스트에 계속 누적.
	}
	
	//총 데이터 갯수 rs2를 totalRow라는 int값으로 바꿈. ResultSet을 평이한 데이터타입(=vo)으로 바꿔준 것. 모델값.
	//select count(*) from notice
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");//현재 존재하는 갯수를 알려줘라. 500
	ResultSet rs2 = stmt2.executeQuery();
	
	int totalRow = 0; //select count(*) from notice;
	if(rs2.next()){
		totalRow = rs2.getInt("count(*)");
	}
	System.out.println(totalRow);
	//마지막 페이지 구하기
	int lastPage = totalRow/rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>noticeList</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	 	table, tr, td {table-layout: fixed}
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
	<table class="table table-bordered table-sm">
		<tr class="center">
			<td colspan="2" class="table-danger">
				<h3>&#128227;공지사항</h3>
			</td>
		</tr>
		<tr class="center">
			<td colspan="2">
				 <a href="./insertNoticeForm.jsp" class="btn btn-outline-secondary">공지입력</a>
			</td>
		</tr>
		<tr class="center">
				<th><h4>notice_title</h4></th>
				<th><h4>createdate</h4></th><!-- createdate는 datetime 형태로 db에 저장되어, 0000-00-00 00:00:00 이런 형태니까 1~10까지(날짜만 보이게) 잘라서 줘라. substirng쓰면 됨. -->
		</tr>
		
		<%		
				for(Notice n : noticeList) { //rs만큼 반복한 noticeList 사이즈만큼 반복.
		%>
				<tr class="center">
					<td>
						<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>" class="black"><%=n.noticeTitle%></a>
					</td>
					<td><%=n.createdate.substring(0,10)%></td> 
				</tr>
		<%
				}
		%>
	</table>
	<div class="center">
	<%
		if(currentPage > 1){
	%>
			<a href="./noticeList.jsp?currentPage=<%=currentPage-1%>" class="btn btn-outline-secondary">이전</a>
	<%		
		}
	%>
			<%=currentPage%>
	<%	
		if(currentPage < lastPage){
	%>
			<a href="./noticeList.jsp?currentPage=<%=currentPage+1%>" class="btn btn-outline-secondary">다음</a>
	<%
		}
	%>
	</div>
</div>
</body>
</html>