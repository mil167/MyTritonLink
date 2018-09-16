<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Faculty Data Entry Form</title>
</head>
<body>
	<b>Faculty Data Entry Menu</b>
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
				
				// Create the prepared statement and use it to 
				// INSERT the faculty attributes INTO the Faculty table
				PreparedStatement pstmt = conn.prepareStatement(
						("INSERT INTO public.faculty VALUES(?,?,?)"));
				
				pstmt.setString(1, request.getParameter("FACULTYNAME"));
				pstmt.setString(2, request.getParameter("TITLE"));
				pstmt.setString(3, request.getParameter("DEPARTMENT"));
				pstmt.executeUpdate();
				
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
					// UPDATE the faculty attributes in the Faculty table.
					PreparedStatement pstatement = conn.prepareStatement(
							"UPDATE public.faculty SET title = ?, department = ? WHERE facultyname = ?");
					
					pstatement.setString(1,request.getParameter("TITLE"));
					pstatement.setString(2, request.getParameter("DEPARTMENT"));
					pstatement.setString(3,request.getParameter("FACULTYNAME"));
					pstatement.executeUpdate();
					conn.setAutoCommit(false);
					conn.setAutoCommit(true);
				}
				%>
				
				<%-- DELETE CODE --%>
				<%
				// Check if a delete is requested
				if(action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to
					// DELETE the faculty in the Faculty table
					PreparedStatement ps = conn.prepareStatement(
							"DELETE FROM public.faculty WHERE facultyname = ?");
					ps.setString(1, request.getParameter("FACULTYNAME"));
					ps.executeUpdate();
					conn.setAutoCommit(false);
					conn.setAutoCommit(true);
				}
				%>
				<%-- STATEMENT CODE --%>
				<%
				// Create the statement 
				Statement statement = conn.createStatement();
				
				// Use the statement to SELECT the faculty attributes FROM the Faculty table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.faculty");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>Faculty Name</th>
						<th>Title</th>
						<th>Department</th>
					</tr>
					<tr>
						<form action="faculty.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="FACULTYNAME" size="50"></th>
							<th><input value="" name="TITLE" size="50"></th>
							<th><input value="" name="DEPARTMENT" size="50"></th>

							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="faculty.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					        <%-- Get the FACULTYNAME --%>
					        <td><input value="<%= rs.getString("FACULTYNAME") %>" name="FACULTYNAME"></td>
					    	<%-- Get the TITLE --%>
					    	<td><input value="<%= rs.getString("TITLE") %>" name="TITLE"></td>
					    	<%-- Get the DEPARTMENT --%>
					    	<td><input value="<%= rs.getString("DEPARTMENT") %>" name="DEPARTMENT"></td>
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	<form action="faculty.jsp" method="get">
				    		<input type="hidden" value="delete" name="action">
				    		<input type="hidden" value="<%= rs.getString("FACULTYNAME") %>" name="FACULTYNAME">
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