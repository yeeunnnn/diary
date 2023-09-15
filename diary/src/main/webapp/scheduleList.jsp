<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import= "vo.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	
/* 1. 초기 화면. 연/월을 오늘 날짜의 연/월로*/
	if(request.getParameter("targetYear")==null
		|| (request.getParameter("targetMonth")==null)){
		Calendar c = Calendar.getInstance();//얘네는 아래에서 출력하고, 어쩌고 하는 거랑 상관 없음.
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);//화면상에 보이려면 1을 더해야 되지만 여기서는 값을 받기만 함.
	} else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));//얘네가 상관 있는 애들
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	System.out.println("targetYear: "+targetYear);
	System.out.println("targetMonth: "+targetMonth);
	
/* 2. 바뀌는 값들 */
	//오늘 날짜 (안해도 되지만 구함) 주황색 표시!!!!
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	//내가 받아온 값에 대해 기본값을 설정. 요일에 맞는 1일을 알고 싶다. (오늘 하고 상관 없을 수 있음. 내가 누르면 옮겨질 값)
	Calendar firstDay = Calendar.getInstance(); //Calendar 클래스의 객체를 만들어야 메소드를 사용할 수 있음.
	firstDay.set(Calendar.YEAR, targetYear);  //(Calendar.YEAR) 현재 년을 (targetYeart) 사용자가 클릭한 년도로 (수정 메소드: 객체변수.set )수정
	firstDay.set(Calendar.MONTH, targetMonth); //2023 4월이 됨 23년 (12가 들어가면 23년 11일 들어감.->자기가 알아서 1로 바꿔버림.)
	firstDay.set(Calendar.DATE, 1); //2023년 4월 1일이 됨.
	
		//23, 12 가 적히면 24, 1 로 바뀌고, 23, 0 이 적히면 22, 12로 변함.
		//23년 12월 입력되면 Calendar API가 24년 1월로 변경함.
		//23년 -1입력하면 CalendarAPI가 22년 12월로 변경
		targetYear = firstDay.get(Calendar.YEAR);
		targetMonth = firstDay.get(Calendar.MONTH);
	
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); //사실은 안 구해도 됨. 2023년 4월 1일이 몇번째 요일인지. 일요일일때 1, 토요일이면 7
	
	//앞 공백칸의 수.
	int startBlank = firstYoil - 1; //(7-1. 6개의 공백이어야 한다.)
	System.out.println("startBlank"+startBlank);
	
		//앞 공백에 전월달 날짜를 회색 글씨로 표현하기 위해.
		Calendar preDate = Calendar.getInstance();
		preDate.set(Calendar.YEAR, targetYear);
		preDate.set(Calendar.MONTH, targetMonth - 1);
			int preMonDate = preDate.getActualMaximum(Calendar.DATE);
		
	//현재달의 마지막 일 (나중에 7로 나누어 떨어져야함.)
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);//현재 firstday의 마지막 날. "실제로 할당 가능한데,(?) 현재 1일인 달이 가지고 있는 최대날.."
	System.out.println("lastDate"+lastDate);
	//target Month의 마지막일 마지막 날짜 + endblank 는 무조건 7로 나누면 0으로 덜어져야함.
	// 전체 TD의 7로 나눈 나머지 값은 0
	//(lastDate + ?) % 7 == 0
	int endBlank = 0;
	if((startBlank + lastDate + endBlank)%7!=0){ //7로 나누어 0이 아닐 때는 남은 Day들.
		endBlank = 7-(startBlank+lastDate)%7;  //  0   7 |  6    1  |  5    2
	}
	//전체 TD의 개수
	int totalTD = startBlank+lastDate+endBlank;
	System.out.println("totalTD"+totalTD);
/* 3. 달력이 넘어가고, 안넘어가고 */	
	//(1) 1월->12월로 갈 때
	if(targetMonth == -1){
		targetMonth = 11;//실제 보여지는 값: 1월
		targetYear = targetYear -1;//년도도 함께 감소시켜라.
	} else if(targetMonth == 12){
		targetMonth = 0;
		targetYear = targetYear + 1;
	}

	//db data를 가져오는 알고리즘
	//targetMonth가 있어야 db를 가져오니까. 이 알고리즘이 아래에 있어야함.
	/* 2. DB */
	//(1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("scheduleList DB 드라이버 실행 성공");
	//(2) conn으로 접속 연결 유지
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("DB 접속 값: " + conn);
	//(3) 쿼리 생성
	PreparedStatement stmt = conn.prepareStatement(
	"select schedule_number scheduleNumber, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc;");
	stmt.setInt(1, targetYear);//stmt의 첫번째 물음표 값을 targetYear로 바꾼다.
	stmt.setInt(2, targetMonth+1);//출력할 땐 0부터 시작하는 Month에 +1
	System.out.println("schduleList stmt: " + stmt);
	
	ResultSet rs = stmt.executeQuery();
	//ResultSet -> ArrayList<String> 아니고 ArrayList<Schedule>로 만듦
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();//rs의 숫자만큼 반복이 된다.
		s.scheduleNumber = rs.getInt("scheduleNumber");
		s.scheduleDate = rs.getString("scheduleDate");//위에서 전체날짜가 아닌 일(day)만 보이도록 함.
		s.scheduleMemo = rs.getString("scheduleMemo");//위에서 전체메모가 아닌 5글자만 잘라둠.
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);//반복하고 밖에 있는 List에 저장시킴. 안에있는건 생명주기 때문에 없어지는 메모리
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>scheduleList</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	 	table, td {table-layout: fixed}
		td {
			padding: 3px;
			width: 120px;
			height: 120px;
		}
		th{
			background-color: #dddddd;
			font-weight: bold;
			height : 30px;
		}
	 	.center {text-align:center}
	 	.grey {color:#BDBDBD;}
	 	.red {color:#FF0000; text-decoration: none;}
	 	.blue {color:#0054FF; text-decoration-line: none;}
	 	.black {color:#000000; text-decoration: none;}
	 	.none {text-decoration: none;}
	</style>
</head>
<body>
	  <div>
		  <ul class="nav nav-tabs">	
              <li class="nav-item"><a class="nav-link" href="./home.jsp">홈으로</a></li>
              <li class="nav-item"><a class="nav-link" href="./noticeList.jsp">노트 리스트</a></li>
              <li class="nav-item"><a class="nav-link" href="./scheduleList.jsp">캘린더</a></li>
          </ul>
      </div>      
	<div class="container mt-3">
	<h1 class="center">&#128198;<%=targetYear%>년 <%=targetMonth+1%>월</h1><!-- 출력할 때만 +1을 해야됨. 아니면 알고리즘이 다 깨짐. 1월이면 12가 넘어감.-->
	<div class="center">
		<a class="black" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">&#8592;이전달</a>
		&nbsp;
		<a class="black" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달&#8594;</a>
	</div>
	<table class="table table-bordered table-sm">
		<tr class="table-danger">
			<th class="center">일</th>
			<th class="center">월</th>
			<th class="center">화</th>
			<th class="center">수</th>
			<th class="center">목</th>
			<th class="center">금</th>
			<th class="center">토</th>
		</tr>
		<tr>
			<%
				for(int i=0; i<totalTD; i+=1){ //i는 0부터 시작하는 애.
					if(i != 0 && i % 7 == 0){ //1부터 시작했으면 분기 코드가 0,1,2,3,4,5,6 이 7개 
			%>
			
		</tr>
					
				<tr>	
			<%		
					}
					String tdStyle = "";
					int num = i - startBlank + 1;//-5부터 시작하는 애.
					if(num>0 && num<=lastDate){
						//targetYear와 targetMonth가 오늘 날짜이면 주황색으로 표시해라.
						if(today.get(Calendar.YEAR) == targetYear
							&& today.get(Calendar.MONTH)== targetMonth
							&& today.get(Calendar.DATE)==num){
							tdStyle = "background-color:#FFD8D8;";
						} //아니라면, if 조건문 안에 있는 tdStyle이 아닌, 밖에 선언된 tdStyle("")을 줘서 일반 배경을 나타내라.
						
					//배경 없이 표현된 것. ListByDate에서 선택된 년/월/일을 상세 예약 페이지로 그대로 넘겨라
					//각 분기문마다, memo에 대한 foreach문은 동일하게 들어가야함.(빨간색은 표시 됐는데 그 칸에 메모가 없으면 안되니.)

						if(i%7==0){ // 1. 일요일에는 빨간색을 표시
			%>	
						<td style="<%=tdStyle%>"><!-- 날짜 숫자에 대해 빨간색 num을 출력. -->
							<div class="red" onclick="location.href='./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>'"><%=num%></div>
							<div><!-- 일정 memo(5글자만)에 대해. -->
			<%
								for(Schedule s : scheduleList){ //66개 들어가 있음.
									if(num==Integer.parseInt(s.scheduleDate)){
			%>
										<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div> <!--  td마다 66개가 출력. -->
			<%
										}
									}	
			%>	
							</div>
						</td>			
			<%		
							} else if(i%7==6){ //2. 토요일에는 파란색을 표시
			%>	

								<td style="<%=tdStyle%>"><!-- 날짜 숫자 -->
									<div class="blue" onclick="location.href='./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>'">
								        <%=num%>
								    </div>
									<div><!-- 일정 memo(5글자만) -->
									<%
										for(Schedule s : scheduleList){ //66개 들어가 있음.
											if(num==Integer.parseInt(s.scheduleDate)){
									%>
												<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
									<%
												}
											}
									%>	
									</div>
								</td>		
			<%
							} else {
			%>					
								<td style="<%=tdStyle%>"><!-- 날짜 숫자 -->	
									<div class="black" onclick="location.href='./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>'"><%=num%></div>
									<div><!-- 일정 memo(5글자만) -->
									<%
										for(Schedule s : scheduleList){ //66개 들어가 있음.
											if(num==Integer.parseInt(s.scheduleDate)){
									%>
											<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div> <!--  td마다 66개가 출력. -->
									<%
											}
										}
									%>	
									</div>
								</td>				
			<%			
						}
					} else if(num<1) {
			%>
						<td class="grey"><%=preMonDate + num%></td><!--  (3월)31일+-5 = 첫 공백에 26일 -->
			<%		
					} else {
			%>
						<td class="grey"><%=num - lastDate%></td><!--  36(첫 후공백) - (4월)30 = 후 공백이 1~6까지. -->
			<%			
					}
				}
				// ResultSet n번 돌리고 싶으면 여기에 rs.beforeFirst()
				//rs를 vo타입으로 바꿔야하는 이유: rs가 '남자인 사람', '30살이 사람'만 찾고 싶으면 그때마다 또 커서를 위로 올려서 다시 찾아야 함, rs는 mariadb 외부 라이브러리에만 있어 번거로움.
			%>
			</tr>
	</table>
	<div class="mt-5 p-4 text-white text-center"> </div>
</div>
</body>
</html>