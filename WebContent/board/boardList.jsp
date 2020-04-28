<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//  Connection : DB 연결권한
	// 래퍼런스 변수를 null로 초기화, 연결된 데이터베이스에 대한 정보 저장
	Connection conn = null;
	// Statement : CRUD SQL 연결
	// sql문을 DBMS로 전송하고 실행하기 위한 객체
	Statement stmt = null;
	// ResultSet : 데이터 담을 객체
	ResultSet totalResult = null;
	ResultSet listResult = null;
	
	try {
		
		// searchField 값을 스트링 searchField에 대입
		String searchField = request.getParameter("searchField");
		// searchText 값을 스트링 searchText 대입
		String searchText = request.getParameter("searchText");
		
		/* searchField 값이 null이면 " " 선언하고 아니면 searchField 선언   */
		searchField = searchField == null ? "" : searchField;
		/* searchText 값이 null이면 " " 선언하고 아니면 searchText 선언   */
		searchText = searchText == null ? "" : searchText;		
		
		/* Console 검색 출력*/
		System.out.println("PARAMETER SEARCHFIELD : " + searchField);
		System.out.println("PARAMETER SEARCHTEXT : " + searchText);
		
		
		// Connection 객체 생성
		conn = DriverManager.getConnection(
			// DB 연결
			"jdbc:oracle:thin:@localhost:1521:orcl", 
			"scott", 
			"1234"
			
		);
		
		
		String whereSql = "";
		// 검색조건 if문 
		if (!"".equals(searchField)) {
			whereSql += " WHERE " + searchField + " LIKE '%" + searchText + "%'";
		} else if ("".equals(searchField) && !"".equals(searchText)) {
			whereSql += " WHERE SUBJECT LIKE '%" + searchText + "%' OR CONTENTS LIKE '%" + searchText + "%'";
		}
		String totalSql = "SELECT COUNT(*) AS TOTAL FROM BOARD" + whereSql;
		
		// 쿼리를 실행시킬 객체 생성
		stmt = conn.createStatement();
		// 쿼리 실행
		totalResult = stmt.executeQuery(totalSql);
		System.out.println("COUNT SQL : " + totalSql);
		
		totalResult = stmt.getResultSet();
		totalResult.next();	
		// 실행문장. totalResult의 TOTAL을 가져와서 int total에 넣음
		int total = totalResult.getInt("TOTAL");


		String listSql = "SELECT * FROM BOARD" + whereSql;
		listSql += " ORDER BY REGIST_DT DESC";
		listResult = stmt.executeQuery(listSql);
		System.out.println("LIST SQL : " + listSql);
		listResult = stmt.getResultSet();

		
		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>게시판 목록 조회</title>
	<style type="text/css">
		* {font-size: 9pt; font-family: 굴림;}
		tr, td, th {border: solid 1px;}
	</style>
</head>
<body>
<h1>게시판 목록</h1>
<form action="boardList.jsp" method="get" name="searchForm">
<table style="border: solid 1px; width: 500px; margin-bottom: 10px;">
<tr>
	<td>
		<select  style="width: 98%" name ="searchField">
			<!-- 목록 검색 ( 전체, 제목, 내용 비교 후 출력)   -->
			<option value="" <%if ("".equals(searchField)) { out.print("selected=\"selected\"");} %>>전체 목록</option>
			<option value="SUBJECT" <%if ("SUBJECT".equals(searchField)) { out.print("selected=\"selected\"");} %>>제목</option>
			<option value="CONTENTS" <%if ("CONTENTS".equals(searchField)) { out.print("selected=\"selected\"");} %>>내용</option>
		</select>
	</td>
	<td>
		<input type="text" style="width: 99%" name="searchText"  value="<%=searchText %>"/>
	</td>
	<td>
		<input name="Search" style="color: blue" type="submit" value="검색"  placeholder="검색어 입력"/>
		<input style="color: blue" type="button" value="등록" onclick="location.href='boardWrite.jsp';"/>
	</td>
</tr>
</table>
</form>
<table style="border: solid 1px;  width: 500px;">
<tr>
	<th width="50">No.</th>
	<th width="200">제목</th>
	<th width="80">작성자</th>
	<th width="50">조회수</th>
	<th width="100">등록일자</th>
</tr>
<%
	if(total == 0){
%>
<tr>
	<!--  total 값이 0이면 아래 문구 출력  -->
	<td colspan="5" align="center">조회된 결과가 없습니다.</td>
</tr>
<%
	/* listResult에 저장된 데이터 얻기 */
	}else{
	int lineNum = 0;
	while(listResult.next()) {
		lineNum++;
%>
   <!--  목록  -->
<tr>
	<td align="center"><%=lineNum%></td>
	<td><a href="boardView.jsp?no=<%=listResult.getString("NO")%>"><%=listResult.getString("SUBJECT")%></a></td>
	<td align="center"><%=listResult.getString("NAME")%></td>
	<td align="center"><%=listResult.getString("READ_CNT")%></td>
	<td align="center"><%=listResult.getString("REGIST_DT")%></td>
</tr>
<% } } %>
</table>
</body>
</html>
<%
	} catch (SQLException e) {
		out.println(e.getMessage());
	} finally {
		// Connection 사용 후 Close / JDBC 연결 해제
		if (totalResult != null) totalResult.close();
		if (listResult != null) listResult.close();
		if (stmt != null) stmt.close();
		if (conn != null) conn.close();
	}
%>