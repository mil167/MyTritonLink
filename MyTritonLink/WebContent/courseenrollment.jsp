<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Course Enrollment Data Entry Form</title>
</head>
<body>
	<b>Course Enrollment Data Entry Menu</b>
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
						("INSERT INTO public.enroll VALUES(?,?,?,?,?,?,?,?,?)"));
				pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
				pstmt.setString(2, request.getParameter("COURSECODE"));
				pstmt.setInt(3, Integer.parseInt(request.getParameter("SSN")));
				pstmt.setString(4, request.getParameter("GRADETYPE"));
				pstmt.setInt(5, Integer.parseInt(request.getParameter("UNITS")));
				pstmt.setInt(6, Integer.parseInt(request.getParameter("SECTIONID")));
				pstmt.setString(7, request.getParameter("GRADE"));
				pstmt.setString(8, "sp");
				pstmt.setInt(9, 2018);
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
				// The course code was found in the table, proceed to add the class
				else {
					courseok = 1;
				}
				
				PreparedStatement check2 = conn.prepareStatement(
						("SELECT COUNT(1) FROM public.classes WHERE sectionid = ?"));
				check2.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
				ResultSet check2_rs = null;
				check2_rs = check2.executeQuery();
				flag = 0;
				int sectionok = 0;
				if(check2_rs.next()) {
					flag = check2_rs.getInt(1);
				}
				// If the flag is still 0, that means the section ID wasn't found in the table
				if(flag == 0) {
					System.out.println("Section ID does not exist in Classes table!");
				}
				// The section ID was found in the table,
				else {
					sectionok = 1;
				}
				PreparedStatement check3 = conn.prepareStatement(
						("SELECT COUNT(1) FROM public.students WHERE ssn = ?"));
				check3.setInt(1, Integer.parseInt(request.getParameter("SSN")));
				ResultSet check3_rs = null;
				check3_rs = check3.executeQuery();
				flag = 0;
				int studentok = 0;
				if(check3_rs.next()) {
					flag = check3_rs.getInt(1);
				}
				// If the flag is still 0, that means the student wasn't found in the table
				if(flag == 0) {
					System.out.println("Student does not exist in Students table!");
				}
				// The ssn was found in the table
				else {
					studentok = 1;
				}
				if(courseok == 1 && sectionok == 1 && studentok == 1) {
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
					// UPDATE the course enrollment attributes in the Enroll table.
					PreparedStatement pstatement = conn.prepareStatement(
							"UPDATE public.enroll SET sectionid = ?, coursecode = ?, ssn = ?, gradetype = ?, units = ?, grade = ? WHERE id = ?");
					pstatement.setInt(1,Integer.parseInt(request.getParameter("SECTIONID")));
					pstatement.setString(2,request.getParameter("COURSECODE"));
					pstatement.setInt(3, Integer.parseInt(request.getParameter("SSN")));
					pstatement.setString(4, request.getParameter("GRADETYPE"));
					pstatement.setInt(5,Integer.parseInt(request.getParameter("UNITS")));
					pstatement.setString(6, request.getParameter("GRADE"));
					pstatement.setInt(7, Integer.parseInt(request.getParameter("ID")));
					
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
					// The course code was found in the table, proceed to add the class
					else {
						courseok = 1;
					}
					
					PreparedStatement check2 = conn.prepareStatement(
							("SELECT COUNT(1) FROM public.classes WHERE sectionid = ?"));
					check2.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
					ResultSet check2_rs = null;
					check2_rs = check2.executeQuery();
					flag = 0;
					int sectionok = 0;
					if(check2_rs.next()) {
						flag = check2_rs.getInt(1);
					}
					// If the flag is still 0, that means the section ID wasn't found in the table
					if(flag == 0) {
						System.out.println("Section ID does not exist in Classes table!");
					}
					// The section ID was found in the table,
					else {
						sectionok = 1;
					}
					PreparedStatement check3 = conn.prepareStatement(
							("SELECT COUNT(1) FROM public.students WHERE ssn = ?"));
					check3.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					ResultSet check3_rs = null;
					check3_rs = check3.executeQuery();
					flag = 0;
					int studentok = 0;
					if(check3_rs.next()) {
						flag = check3_rs.getInt(1);
					}
					// If the flag is still 0, that means the student wasn't found in the table
					if(flag == 0) {
						System.out.println("Student does not exist in Students table!");
					}
					// The ssn was found in the table
					else {
						studentok = 1;
					}
					if(courseok == 1 && sectionok == 1 && studentok == 1) {
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
					// DELETE the enrollment in the Enroll table
					PreparedStatement ps = conn.prepareStatement(
							"DELETE FROM public.enroll WHERE id = ?");
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
				
				// Use the statement to SELECT the ennrollment attributes FROM the Enroll table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.enroll ORDER BY id ASC");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>ID</th>
						<th>Section ID</th>
						<th>Course Code</th>
						<th>SSN</th>
						<th>Grade Type</th>
						<th>Units</th>
						<th>Grade</th>
					</tr>
					<tr>
						<form action="courseenrollment.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="ID" size="50"></th>
							<th><input value="" name="SECTIONID" size="50"></th>
							<th><input value="" name="COURSECODE" size="50"></th>
							<th><input value="" name="SSN" size="50"></th>
							<th><input value="" name="GRADETYPE" size="50"></th>
							<th><input value="" name="UNITS" size="50"></th>
							<th><input value="" name="GRADE" size="50"></th>

							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="courseenrollment.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					        <td><input value="<%= rs.getInt("ID") %>" name="ID"></td>
					        <td><input value="<%= rs.getInt("SECTIONID") %>" name="SECTIONID"></td>
					    	<td><input value="<%= rs.getString("COURSECODE") %>" name="COURSECODE"></td>
					    	<td><input value="<%= rs.getInt("SSN") %>" name="SSN"></td>
					    	<td><input value="<%= rs.getString("GRADETYPE") %>" name="GRADETYPE"></td>
					    	<td><input value="<%= rs.getInt("UNITS") %>" name="UNITS"></td>
					    	<td><input value="<%= rs.getString("GRADE") %>" name="GRADE"></td>
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	<form action="courseenrollment.jsp" method="get">
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