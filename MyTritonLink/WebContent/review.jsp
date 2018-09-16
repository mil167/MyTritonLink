<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Review Session Data Entry Form</title>
</head>
<body>
	<b>Review Session Data Entry Menu</b>
	<ul>
		<li>
			<a href="courses.jsp">Courses</a>
		</li>
		<li>
			<a href="classes.jsp">Classes</a>
		</li>
		<li>
			<a href="students.jsp">Students</a>
		</li>
		<li>
			<a href="faculty.jsp">Faculty</a>
		</li>
		<li>
			<a href="aprobation.jsp">Academic Probation</a>
		</li>
		<li>
			<a href="review.jsp">Review Sessions</a>
		</li>
		<li>
			<a href="pastcourses.jsp">Past Courses</a>
		</li>
		<li>
			<a href="courseenrollment.jsp">Course Enrollment</a>
		</li>
		<li>
			<a href="degree.jsp">Degree Requirements</a>
		</li>
		<li>
			<a href="thesiscommittee.jsp">Thesis Committee</a>
		</li>
	</ul>
	<table>
		<tr>
			<td>
				<jsp:include page="menu.html"/>
			</td>
			<td>
				<%-- OPEN CONNECTION CODE --%>
				<%-- Set the scripting language to java and --%>
				<%-- import the java.sql package --%>
				<%@ page language="java" import="java.sql.*" %>
				
				<%
				try {
					Class.forName("org.postgresql.Driver");
					String dbURL = "jdbc:postgresql://localhost:5432/MyTritonLinkDB?user=postgres&password=cse132b";
					Connection conn = DriverManager.getConnection(dbURL);
					if(conn != null) {
						System.out.println("Connection successful");
					}
				%>
				<%-- INSERTION CODE --%>
				<%
				// Check if an insertion is requested
				String action = request.getParameter("action");
				if(action != null && action.equals("insert")){
					conn.setAutoCommit(false);
				
				// First check to see if the section id exists in the Classes table	
				
				// Create the prepared statement and use it to 
				// INSERT the review session attributes INTO the Review table
				PreparedStatement pstmt = conn.prepareStatement(
						("INSERT INTO public.review VALUES(?,?,?,?)"));
				
				pstmt.setString(1, request.getParameter("SECTIONID"));
				pstmt.setString(2, request.getParameter("DATE"));
				pstmt.setString(3, request.getParameter("TIME"));
				pstmt.setString(4, request.getParameter("LOCATION"));
				
				PreparedStatement check = conn.prepareStatement(
						("SELECT COUNT(1) FROM public.classes WHERE sectionid = ?"));
				check.setString(1, request.getParameter("SECTIONID"));
				ResultSet check_rs = null;
				check_rs = check.executeQuery();
				int flag = 0;
				if(check_rs.next()) {
					flag = check_rs.getInt(1);
				}
				// If the flag is still 0, that means the section ID wasn't found in the table
				if(flag == 0) {
					System.out.println("Section ID does not exist in Classes table!");
				}
				// The section ID was found in the table, proceed to add the review session
				else {
					pstmt.executeUpdate();
				}
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>
				
				<%-- UPDATE CODE --%>
				<%
				// Check if an update is requested
				if(action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to 
					// UPDATE the review session attributes in the Review table.
					PreparedStatement pstatement = conn.prepareStatement(
							"UPDATE public.review SET date = ?, time = ?, location = ? WHERE sectionid = ?");
					
					pstatement.setString(1,request.getParameter("DATE"));
					pstatement.setString(2,request.getParameter("TIME"));
					pstatement.setString(3, request.getParameter("LOCATION"));
					pstatement.setString(4, request.getParameter("SECTIONID"));
					PreparedStatement check = conn.prepareStatement(
							("SELECT COUNT(1) FROM public.classes WHERE sectionid = ?"));
					check.setString(1, request.getParameter("SECTIONID"));
					ResultSet check_rs = null;
					check_rs = check.executeQuery();
					int flag = 0;
					if(check_rs.next()) {
						flag = check_rs.getInt(1);
					}
					// If the flag is still 0, that means the section ID wasn't found in the table
					if(flag == 0) {
						System.out.println("Section ID does not exist in Classes table!");
					}
					// The section ID was found in the table, proceed to add the review session
					else {
						pstatement.executeUpdate();
					}
						conn.commit();
						conn.setAutoCommit(true);
					}
					//pstatement.executeUpdate();
					//conn.setAutoCommit(false);
					//conn.setAutoCommit(true);
				
				%>
				
				<%-- DELETE CODE --%>
				<%
				// Check if a delete is requested
				if(action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to
					// DELETE the review in the Review table
					PreparedStatement ps = conn.prepareStatement(
							"DELETE FROM public.review WHERE sectionid = ?");
					ps.setString(1, request.getParameter("SECTIONID"));
					ps.executeUpdate();
					conn.setAutoCommit(false);
					conn.setAutoCommit(true);
				}
				%>
				<%-- STATEMENT CODE --%>
				<%
				// Create the statement 
				Statement statement = conn.createStatement();
				
				// Use the statement to SELECT the review session attributes FROM the Review table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.review");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>Section ID</th>
						<th>Date</th>
						<th>Time</th>
						<th>Location</th>
					</tr>
					<tr>
						<form action="review.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SECTIONID" size="50"></th>
							<th><input value="" name="DATE" size="50"></th>
							<th><input value="" name="TIME" size="50"></th>
							<th><input value="" name="LOCATION" size="50"></th>

							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="review.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					        <%-- Get the SECTIONID --%>
					        <td><input value="<%= rs.getString("SECTIONID") %>" name="SECTIONID"></td>
					    	<%-- Get the DATE --%>
					    	<td><input value="<%= rs.getString("DATE") %>" name="DATE"></td>
					    	<%-- Get the TIME --%>
					    	<td><input value="<%= rs.getString("TIME") %>" name="TIME"></td>
					    	<%-- GET THE LOCATION --%>
					    	<td><input value="<%= rs.getString("LOCATION") %>" name="LOCATION"></td>
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	<form action="review.jsp" method="get">
				    		<input type="hidden" value="delete" name="action">
				    		<input type="hidden" value="<%= rs.getString("SECTIONID") %>" name="SECTIONID">
				    		<td><input type="submit" value="Delete"></td>
				    	</form>
				    </tr> 
				    <%
					}
					%>
					
				</table>
				
				<%-- CLOSE CONNECTION CODE --%>
				<%
				// Close the ResultSet
				rs.close();
				
				// Close the Statement
				statement.close();
				
				// Close the connection
				conn.close();
				}
				
			catch(SQLException e) {
				e.printStackTrace();
			}
			finally {
				System.out.println(" ");
			}
				%>
			</td>
		</tr>		
	</table>
</body>
</html>