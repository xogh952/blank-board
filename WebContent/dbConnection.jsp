<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>test</title>
</head>
<body>
<%
	// DB Ŀ�ؼ��� ���� �⺻���� Ŭ����
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	try {
		conn = DriverManager.getConnection(
			"jdbc:oracle:thin:@localhost:1521:orcl", 
			"scott", 
			"1234"
		);
		stmt = conn.createStatement();
		stmt.executeQuery("SELECT 'DB��ȸ����' FROM DUAL");
		rs = stmt.getResultSet();
		while(rs.next()) {
			out.println(rs.getString(1));
		}
	} catch (SQLException e) {
		out.println(e.getMessage());
	} finally {
		if (rs != null) rs.close();
		if (stmt != null) stmt.close();
		if (conn != null) conn.close();
	}
%>
</body>
</html>