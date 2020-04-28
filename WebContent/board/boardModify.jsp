<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 래퍼런스 변수를 null로 초기화, 연결된 데이터베이스에 대한 정보 저장.
	Connection conn = null;
	//Statement : CRUD SQL 연결
	// sql문을 DBMS로 전송하고 실행하기 위한 객체
	Statement stmt = null;
	// viewResult : 데이터 담을 객체
	ResultSet viewResult = null;
	try {
		
		String no = request.getParameter("no");
		no = no == null ? "" : no;
		System.out.println("PARAMETER NO : " + no);

		// Connection 객체를 생성
		conn = DriverManager.getConnection(
			// DB 연결
			"jdbc:oracle:thin:@localhost:1521:orcl",  // 연결문자열
			"scott",   // 데이터베이스 ID
			"1234"   // 데이터베이스 pw
		);
		// SQL 쿼리를 생성/실행하며, 반환된 결과를 가져오게 할 작업 영역을 제공
		// Statement 객체는 Connection 객체의 createStatement() 메소드를 사용하여 생성됨.
		stmt = conn.createStatement();
		
		// SQL 쿼리 작성
		String viewSql = "SELECT * FROM BOARD WHERE  NO = " + no;
		// SQL 문장을 실행하고 결과를 리턴
		stmt.executeUpdate(viewSql);
		System.out.println("VIEW SQL : " + viewSql);
		viewResult = stmt.getResultSet();
		
		viewResult.next();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>게시판 수정폼</title>
	<style type="text/css">
		* {font-size: 9pt; font-family: 굴림;}
		tr, td, th {border: solid 1px;}
	</style>
	<!-- 자바 스크립트 영역 -->
	<script type="text/javascript">
	
	 function BoardModifyCheck(){

		 var form = document.modifyForm;
		 
		 // subject의 값이 없을때 alert 경고창 띄움
	 if(subject.value == ""){
		   alert("제목을 입력하세요!");
		   // subject에 있는 위치로 이동
		   subject.focus();
		   return false;
		  }
		  if(contents.value == ""){
		   alert("내용을 입력하세요!");
		   contents.focus();
		   return false;
		  }
		  
	</script>
</head>
<body>
<!-- POST방식으로 데이터 보냄  ( POST방식 : URL에 데이터를 붙여서 보내지 않고 body에서 데이터를 넣어서 보냄 )  -->
<!-- submit 버튼 누르면 onsubmit이 실행되어 특정함수가 실행되고 특정함수의 return값이 true일 경우에만 폼을 전송-->
<form name="BoardModifyForm" method="post" action="boardModify_ok.jsp" onsubmit="return BoardModifyCheck()">
<input type="hidden" name="mode" value="M" />
<input type="hidden" name="no" value="<%=viewResult.getString("NO")%>" />
<h1>게시글 수정하기</h1>
<table style="border: solid 1px;">
<tr>
	<td align="center">제목</td>
	<td width="200"><input type="text" id="subject" name="subject"  value="<%=viewResult.getString("SUBJECT") %>"/></td>
</tr>
<tr>
	<td align="center">작성자</td>
	<td><input type="text" name="writer" size="10" value="<%=viewResult.getString("NAME")%>" /></td>
</tr>
<tr>
	<td align="center">내용</td>
	<td>
		<textarea name="contents" cols="28" rows="10"><%=viewResult.getString("CONTENTS")%></textarea>
	</td>
</tr>
<tr>
	<td colspan="2" align="right">
		<!-- 목록 클릭시  boardList.jsp로 이동 -->
		<input type="button" value="목록" onclick="location.href='boardList.jsp';" />
		<!-- 수정 클릭시 수정 처리 -->
		<input type="submit"  style="color: blue"  value="수정"  onclick="BoardModifyCheck"/>
		<!-- 취소버튼 -->
		<input type="button" value="취소" onclick="history.back(-1)">
	</td>
</tr>
</table>
</form>
</body>
</html>
<%
	} catch (SQLException e) {
		out.println(e.getMessage());
	} finally {
		// 쿼리 수행후 DB연결 해제 
		// 닫을때는 Open한 반대의 순서로 닫아주어야 함
		// Statement가 PreparedStatement보다 상위클래스이기 때문에 닫는 메서드를 만들때 
		// Statement로 받을어도 PreparedStatement을 정상적으로 받을 수 있다.
		// 닫을때는 null이 아닌지를 확인한뒤에 받도록 만들면 생각지 못한 오류를 막을 수 있다.
		if (viewResult != null) viewResult.close();
		if (stmt != null) stmt.close();
		if (conn != null) conn.close();
	}
%>