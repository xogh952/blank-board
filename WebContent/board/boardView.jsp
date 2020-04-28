<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 래퍼런스 변수를 null로 초기화, 연결된 데이터베이스에 대한 정보 저장.
	Connection conn = null;
	//Statement : CRUD SQL 연결
	// sql문을 DBMS로 전송하고 실행하기 위한 객체
	Statement stmt = null;
	// ResultSet : 데이터 담을 객체
	ResultSet listResult = null;
	try {
		
		String no = request.getParameter("no");
		no = no == null ? "" : no;
		System.out.println("PARAMETER NO : " + no);

		conn = DriverManager.getConnection(
			// DB 연결
			"jdbc:oracle:thin:@localhost:1521:orcl", 
			"scott", 
			"1234"
		);
		
		stmt = conn.createStatement();
		// BOARD 테이블의 READ_CNT 컬럼을 UPDATE쿼리 생성
		String readCntSql = "UPDATE BOARD SET READ_CNT = READ_CNT + 1 WHERE NO = " + no;
		// readCntSql 쿼리 실행
		stmt.executeQuery(readCntSql);
		System.out.println("UPDATE SQL : " + readCntSql);
		
		String viewSql = "SELECT * FROM BOARD WHERE NO = " + no;
		stmt.executeQuery(viewSql);
		System.out.println("VIEW SQL : " + viewSql);
		listResult = stmt.getResultSet();
		// 다음행으로 실행위치를 이동. 이후 한 레코드(row)를 가리킴.
		// (다음행이 있으면 true, 없으면 false 리턴)
		listResult.next();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>게시판 상세조회</title>
	<style type="text/css">
		* {font-size: 9pt; font-family: 굴림;}
		tr, td, th {border: solid 1px;}
	</style>
	<script type="text/javascript">
		/* 삭제 버튼 클릭시 goDelete함수 실행 */
		function goDelete() {
			if (confirm("정말 삭제하시겠습니까?")) { 
				location.href = 'boardProcess.jsp?no=<%=listResult.getString("NO")%>&mode=D';
			}
		}
	</script>
</head>
<body>
<h1>게시판 보기</h1>
<table style="border: solid 1px;">
<tr>
	<td align="center">제목</td>
	<td width="200"><%=listResult.getString("SUBJECT") %></td>
</tr>
<tr>
	<td align="center">작성자</td>
	<td><%=listResult.getString("NAME") %></td>
</tr>
<tr>
	<td align="center">작성일자</td>
	<td><%=listResult.getString("REGIST_DT") %></td>
</tr>
<tr>
	<td align="center">작성자 IP</td>
	<td><%=listResult.getString("REGIST_IP") %></td>
</tr>
<tr>
	<td align="center">조회수</td>
	<td><%=listResult.getString("READ_CNT") %></td>
</tr>
<tr>
	<td align="center">내용</td>
	<td>
 		<%out.print(listResult.getString("CONTENTS").replace("\r\n","<br/>")); %>
	</td>
</tr>
<tr>
	<td align="center">수정일자</td>
	<td><%=listResult.getString("CHANGE_DT") %></td>
</tr>
<tr>
	<td align="center">수정자 IP</td>
	<td><%=listResult.getString("CHANGE_IP") %></td>
</tr>
<tr>
	<td colspan="2" align="right">
		<!-- 목록 클릭시  boardList.jsp로 이동 -->
		<input type="button" value="목록" onclick="location.href='boardList.jsp';" />
		<!-- 수정 클릭시 수정 처리 -->
		<input type="button"  style="color: blue"  value="수정" onclick="location.href='boardModify.jsp?no=<%=listResult.getString("NO") %>';" />
		<!-- 삭제 클릭시 goDelete함수 실행  -->
		<input type="button"  style="color: red" value="삭제" onclick="goDelete();" />
	</td>
</tr>
</table>
</body>
</html>
<%
	} catch (SQLException e) {
		out.println(e.getMessage());
	} finally {
		// 쿼리 수행후 DB연결 해제 
		if (listResult != null) listResult.close();
		if (stmt != null) stmt.close();
		if (conn != null) conn.close();
	}
%>