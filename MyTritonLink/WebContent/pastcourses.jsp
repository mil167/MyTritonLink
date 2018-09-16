<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Past Courses Data Entry Form</title>
</head>
<body>
	<b>Past Courses Data Entry Menu</b>
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
				// INSERT the past courses attributes INTO the Past Courses table
				PreparedStatement pstmt = conn.prepareStatement(
						("INSERT INTO public.pastcourses VALUES(?,?,?,?,?,?,?,?,?)"));
				
				pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("SSN")));
				pstmt.setString(3, request.getParameter("FIRSTNAME"));
				pstmt.setString(4, request.getParameter("COURSECODE"));
				pstmt.setString(5, request.getParameter("GRADE"));
				pstmt.setString(6, request.getParameter("QUARTER"));
				pstmt.setInt(7, Integer.parseInt(request.getParameter("YEAR")));
				pstmt.setInt(8, Integer.parseInt(request.getParameter("UNITS")));
				pstmt.setString(9, request.getParameter("PROFESSOR"));
				
				PreparedStatement check = conn.prepareStatement(
						("SELECT COUNT(1) FROM public.courses WHERE coursecode = ?"));
				check.setString(1, request.getParameter("COURSECODE"));
				ResultSet check_rs = null;
				check_rs = check.executeQuery();
				int flag = 0;
				int courseok = 0;
				if(check_rs.next()) {
					flag = check_rs.getInt(1);
				}
				// If the flag is still 0, that means the course code wasn't found in the table
				if(flag == 0) {
					System.out.println("Course code does not exist in Courses table!");
				}
				// The course code was found in the table
				else {
					courseok = 1;
				}
				PreparedStatement check2 = conn.prepareStatement(
						("SELECT COUNT(1) FROM public.students WHERE ssn = ?"));
				
				check2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
				ResultSet check2_rs = null;
				check2_rs = check2.executeQuery();
				flag = 0;
				int studentok = 0;
				if(check2_rs.next()) {
					flag = check2_rs.getInt(1);
				}
				// If the flag is still 0, that means the ssn wasn't found in the table
				if(flag == 0) {
					System.out.println("SSN does not exist in Students table!");
				}
				// The ssn was found in the table
				else {
					studentok = 1;
				}
				if(courseok == 1 && studentok == 1) {
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
					// UPDATE the past course attributes in the Past Courses table.
					PreparedStatement pstatement = conn.prepareStatement(
							"UPDATE public.pastcourses SET ssn = ?, firstname = ?, " +
							"coursecode = ?, grade = ?, quarter = ?, year = ?, units = ?, professor = ? WHERE id = ?");
					pstatement.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					pstatement.setString(2, request.getParameter("FIRSTNAME"));
					pstatement.setString(3, request.getParameter("COURSECODE"));
					pstatement.setString(4, request.getParameter("GRADE"));
					pstatement.setString(5, request.getParameter("QUARTER"));
					pstatement.setInt(6, Integer.parseInt(request.getParameter("YEAR")));
					pstatement.setInt(7, Integer.parseInt(request.getParameter("UNITS")));
					pstatement.setString(8, request.getParameter("PROFESSOR"));
					pstatement.setInt(9, Integer.parseInt(request.getParameter("ID")));
					PreparedStatement check = conn.prepareStatement(
							("SELECT COUNT(1) FROM public.courses WHERE coursecode = ?"));
					check.setString(1, request.getParameter("COURSECODE"));
					ResultSet check_rs = null;
					check_rs = check.executeQuery();
					int flag = 0;
					int courseok = 0;
					if(check_rs.next()) {
						flag = check_rs.getInt(1);
					}
					// If the flag is still 0, that means the course code wasn't found in the table
					if(flag == 0) {
						System.out.println("Course code does not exist in Courses table!");
					}
					// The course code was found in the table
					else {
						courseok = 1;
					}
					PreparedStatement check2 = conn.prepareStatement(
							("SELECT COUNT(1) FROM public.students WHERE ssn = ?"));
					
					check2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					ResultSet check2_rs = null;
					check2_rs = check2.executeQuery();
					flag = 0;
					int studentok = 0;
					if(check2_rs.next()) {
						flag = check2_rs.getInt(1);
					}
					// If the flag is still 0, that means the ssn wasn't found in the table
					if(flag == 0) {
						System.out.println("SSN does not exist in Students table!");
					}
					// The ssn was found in the table
					else {
						studentok = 1;
					}
					if(courseok == 1 && studentok == 1) {
						pstatement.executeUpdate();
					}
						conn.commit();
						conn.setAutoCommit(true);
					}
					
				//	pstatement.executeUpdate();
				//	conn.setAutoCommit(false);
				//	conn.setAutoCommit(true);
				//}
				%>
				
				<%-- DELETE CODE --%>
				<%
				// Check if a delete is requested
				if(action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to
					// DELETE the past course in the Past Courses table
					PreparedStatement ps = conn.prepareStatement(
							"DELETE FROM public.pastcourses WHERE id = ?");
					ps.setInt(1, Integer.parseInt(request.getParameter("ID")));
					ps.executeUpdate();
					conn.setAutoCommit(false);
					conn.setAutoCommit(true);
				}
				%>
				<%-- STATEMENT CODE --%>
				<%
				// Create the statement 
				Statement statement = conn.createStatement();
				
				// Use the statement to SELECT the past course attributes FROM the Past Courses table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.pastcourses ORDER BY id ASC");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>ID</th>
						<th>SSN</th>
						<th>First Name</th>
						<th>Course Code</th>
						<th>Grade</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Units</th>
						<th>Professor</th>
					</tr>
					<tr>
						<form action="pastcourses.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="ID" size="50"></th>
							<th><input value="" name="SSN" size="50"></th>
							<th><input value="" name="FIRSTNAME" size="50"></th>
							<th><input value="" name="COURSECODE" size="50"></th>
							<th><input value="" name="GRADE" size="50"></th>
							<th><input value="" name="QUARTER" size="50"></th>
							<th><input value="" name="YEAR" size="50"></th>
							<th><input value="" name="UNITS" size="50"></th>
							<th><input value="" name="PROFESSOR" size="50"></th>

							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="pastcourses.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					        <td><input value="<%= rs.getInt("ID") %>" name="ID"></td>
					    	<td><input value="<%= rs.getInt("SSN") %>" name="SSN"></td>
					    	<td><input value="<%= rs.getString("FIRSTNAME") %>" name="FIRSTNAME"></td>
					    	<td><input value="<%= rs.getString("COURSECODE") %>" name="COURSECODE"></td>
					    	<td><input value="<%= rs.getString("GRADE") %>" name="GRADE"></td>
					    	<td><input value="<%= rs.getString("QUARTER") %>" name="QUARTER"></td>
					    	<td><input value="<%= rs.getInt("YEAR") %>" name="YEAR"></td>
					    	<td><input value="<%= rs.getInt("UNITS") %>" name="UNITS"></td>
					    	<td><input value="<%= rs.getString("PROFESSOR") %>" name="PROFESSOR"></td>
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	<form action="pastcourses.jsp" method="get">
				    		<input type="hidden" value="delete" name="action">
				    		<input type="hidden" value="<%= rs.getInt("ID") %>" name="ID">
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