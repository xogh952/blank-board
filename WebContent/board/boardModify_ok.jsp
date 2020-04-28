<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 처리하기</title>
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");

String mode = request.getParameter("mode");
String NO = request.getParameter("no");
String subject = request.getParameter("subject");
String writer = request.getParameter("writer");
String contents = request.getParameter("contents");
String registIp = request.getRemoteHost();

// 데이터 베이스와 연결을 위한 객체
// JDBC의 정보를 가지는 인터페이스0
Connection conn = null;
// SQL문을 데이터베이스에 보내기위한 객체
// SQL을 미리 준비시키고 실행시에 매개변수를 받아 사용하는 방식
// 쿼리 실행 후 해당 쿼리의 결과물을 받아올 수 있다
Statement stmt = null;
// statement의 쿼리 실행 결과를 받아서
// 컬럼 정보 및 로우 정보를 Cursor를 이용해 관리.
ResultSet updResult = null;
String sql = "";

try {
	// Connection 객체를 생성
	conn = DriverManager.getConnection(
		// DB 연결
		"jdbc:oracle:thin:@localhost:1521:orcl",  // 연결문자열
		"scott",   // 데이터베이스 ID
		"1234"   // 데이터베이스 pw
	);
	stmt = conn.createStatement();
	
	int result = 0;
	
	if ("W".equals(mode)) {
		// 조회 쿼리  / 데이터가 없으면 0 데이터가 있으면 최대값 +1
		stmt.executeQuery("SELECT NVL(MAX(NO), 0)+1 FROM BOARD");
		updResult = stmt.getResultSet();
		updResult.next();
		sql = "INSERT INTO BOARD (" + 
				"NO, SUBJECT, NAME, READ_CNT," + 
				"CONTENTS, REGIST_DT, REGIST_IP" + 
			") VALUES (" +
				 + updResult.getInt(1) + 
				",'" + subject + "'" +
				",'" + writer + "'" +
				",0" +
				",'" + contents + "'" +
				",SYSDATE" +
				",'" + registIp + "'" +
			")"; 
		result = stmt.executeUpdate(sql);
		
	} else if ("M".equals(mode)) {
		// UPDATE 쿼리 작성
		sql = "UPDATE BOARD SET " + 
				"SUBJECT = '" + subject + "'," +
				"NAME = '" + writer + "'," +
				"CONTENTS = '" + contents + "'," +
				"CHANGE_DT = SYSDATE," +
				"CHANGE_IP = '" + registIp + "' " +
			"WHERE NO = " + NO;
		result = stmt.executeUpdate(sql);
	} else if ("D".equals(mode)) {
		sql = "DELETE FROM BOARD WHERE NO = " + NO;
		result = stmt.executeUpdate(sql);
	}
	System.out.println(sql);

	if (result > 0) {
		if ("M".equals(mode)) {
			out.println("<script>alert('성공'); location.href='boardView.jsp?no=" + NO +"';</script>");
		} else {
			out.println("<script>alert('성공'); location.href='boardList.jsp';</script>");
		}
	} else {
		out.println("<script>alert('실패'); location.href='boardList.jsp';</script>");
	}


} catch (SQLException e) {
	// 쿼리 수행후 DB연결 해제 
	out.println(e.getMessage());
} finally {
	// 닫을때는 Open한 반대의 순서로 닫아주어야 함
	// Statement가 PreparedStatement보다 상위클래스이기 때문에 닫는 메서드를 만들때 
	// Statement로 받을어도 PreparedStatement을 정상적으로 받을 수 있다.
	// 닫을때는 null이 아닌지를 확인한뒤에 받도록 만들면 생각지 못한 오류를 막을 수 있다.
	if (updResult != null) updResult.close();
	if (stmt != null) stmt.close();
	if (conn != null) conn.close();
}

%>
</body>
</html>