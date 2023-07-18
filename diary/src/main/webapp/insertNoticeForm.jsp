<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm</title>
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
              <li class="nav-item"><a class="nav-link" href="./noticeList.jsp">공지 리스트</a></li>
              <li class="nav-item"><a class="nav-link" href="./scheduleList.jsp">캘린더</a></li>
          </ul>
      </div>

	<form action="./insertNoticeAction.jsp" method="post">
	<div class="container" class="center">	
	<table class="table table-bordered">
		<tr class="center">
			<td colspan="2" class="table-danger"><h3>&#9997;공지 입력</h3></td>
		</tr>
		<tr>
			<td class="center">notice_title</td>
			<td class="center">
				<input type="text" name="noticeTitle">
			</td>
		</tr>
		<tr>
			<td class="center">notice_content</td>
			<td class="center">
				<textarea class="form-control" rows="5" id="comment" name="noticeContent"></textarea>
			</td>
		</tr>
		<tr>
			<td class="center">nontice_writer</td>
			<td class="center">
				<input type="text" name="noticeWriter" class="center">
			</td>
		</tr>
		<tr>
			<td class="center">notice_pw</td>
			<td class="center">
				<input type="password" name="noticePw" class="center">
			</td>
		</tr>
		<tr class="center">
			<td colspan="2">
			<button type="submit" class="btn btn-outline-secondary">입력</button>
			</td>
		</tr>
	</table>
	</div>
</form>
</body>
</html>