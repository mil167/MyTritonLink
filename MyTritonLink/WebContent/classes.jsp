<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Classes Data Entry Form</title>
</head>
<body>
	<b>Classes Data Entry Menu</b>
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
				// INSERT the class attributes INTO the Classes table
				PreparedStatement pstmt = conn.prepareStatement(
						("INSERT INTO public.classes VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"));
				
				pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
				pstmt.setString(2, request.getParameter("COURSECODE"));
				pstmt.setString(3, request.getParameter("QUARTER"));
				pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				pstmt.setString(5, request.getParameter("LECDAY1"));
				pstmt.setInt(6, Integer.parseInt(request.getParameter("LECSTIME")));
				pstmt.setInt(7, Integer.parseInt(request.getParameter("LECETIME")));
				pstmt.setString(8, request.getParameter("DISCDAY1"));
				pstmt.setInt(9, Integer.parseInt(request.getParameter("DISCSTIME")));
				pstmt.setInt(10, Integer.parseInt(request.getParameter("DISCETIME")));
				pstmt.setString(11, request.getParameter("LABDAY1"));
				pstmt.setInt(12, Integer.parseInt(request.getParameter("LABSTIME")));
				pstmt.setInt(13, Integer.parseInt(request.getParameter("LABETIME")));
				pstmt.setString(14, request.getParameter("REVIEWMONTH"));
				pstmt.setInt(15, Integer.parseInt(request.getParameter("REVIEWDAY")));
				pstmt.setInt(16, Integer.parseInt(request.getParameter("REVIEWSTIME")));
				pstmt.setInt(17, Integer.parseInt(request.getParameter("REVIEWETIME")));
				pstmt.setString(18, request.getParameter("FINALMONTH"));
				pstmt.setInt(19, Integer.parseInt(request.getParameter("FINALDAY")));
				pstmt.setInt(20, Integer.parseInt(request.getParameter("FINALSTIME")));
				pstmt.setInt(21, Integer.parseInt(request.getParameter("FINALETIME")));
				pstmt.setInt(22, Integer.parseInt(request.getParameter("ENROLLLIMIT")));
				pstmt.setString(23, request.getParameter("PROFESSOR"));
				pstmt.setString(24, request.getParameter("LECDAY2"));
				pstmt.setString(25, request.getParameter("LECDAY3"));
				pstmt.setString(26, request.getParameter("DISCDAY2"));
				pstmt.setString(27, request.getParameter("LABDAY2"));
				
				
				
				// Check to see if the course code entered in the field matches any of the
				// previously entered course codes in the Courses table
				PreparedStatement check = conn.prepareStatement(
						("SELECT COUNT(1) FROM public.courses WHERE coursecode = ?"));
				check.setString(1, request.getParameter("COURSECODE"));
				ResultSet check_rs = null;
				check_rs = check.executeQuery();
				int flag = 0;
				if(check_rs.next()) {
					flag = check_rs.getInt(1);
				}
				// If the flag is still 0, that means the course code wasn't found in the table
				if(flag == 0) {
					System.out.println("Course code does not exist in Courses table!");
				}
				// The course code was found in the table, proceed to add the class
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
					// UPDATE the class attributes in the Classes table.
					PreparedStatement pstatement = conn.prepareStatement(
							"UPDATE public.classes SET coursecode = ?, quarter = ?, year = ?, " +
							"lecday1 = ?, lecstime = ?, lecetime = ?, discday1 = ?, " +
							"discstime = ?, discetime = ?, labday1 = ?, labstime = ?, labetime = ?, " +
							"reviewmonth = ?, reviewday = ?, reviewstime = ?, reviewetime = ?, " +
							"finalmonth = ?, finalday = ?, finalstime = ?, finaletime = ?, enrolllimit = ?, " + 
							"professor = ?, lecday2 = ?, lecday3 = ?, discday2 = ?, labday2 = ? WHERE sectionid = ?");
					
					pstatement.setString(1, request.getParameter("COURSECODE"));
					pstatement.setString(2, request.getParameter("QUARTER"));
					pstatement.setInt(3, Integer.parseInt(request.getParameter("YEAR")));
					pstatement.setString(4, request.getParameter("LECDAY1"));
					pstatement.setInt(5, Integer.parseInt(request.getParameter("LECSTIME")));
					pstatement.setInt(6, Integer.parseInt(request.getParameter("LECETIME")));
					pstatement.setString(7, request.getParameter("DISCDAY1"));
					pstatement.setInt(8, Integer.parseInt(request.getParameter("DISCSTIME")));
					pstatement.setInt(9, Integer.parseInt(request.getParameter("DISCETIME")));
					pstatement.setString(10, request.getParameter("LABDAY1"));
					pstatement.setInt(11, Integer.parseInt(request.getParameter("LABSTIME")));
					pstatement.setInt(12, Integer.parseInt(request.getParameter("LABETIME")));
					pstatement.setString(13, request.getParameter("REVIEWMONTH"));
					pstatement.setInt(14, Integer.parseInt(request.getParameter("REVIEWDAY")));
					pstatement.setInt(15, Integer.parseInt(request.getParameter("REVIEWSTIME")));
					pstatement.setInt(16, Integer.parseInt(request.getParameter("REVIEWETIME")));
					pstatement.setString(17, request.getParameter("FINALMONTH"));
					pstatement.setInt(18, Integer.parseInt(request.getParameter("FINALDAY")));
					pstatement.setInt(19, Integer.parseInt(request.getParameter("FINALSTIME")));
					pstatement.setInt(20, Integer.parseInt(request.getParameter("FINALETIME")));
					pstatement.setInt(21, Integer.parseInt(request.getParameter("ENROLLLIMIT")));
					pstatement.setString(22, request.getParameter("PROFESSOR"));
					pstatement.setString(23, request.getParameter("LECDAY2"));
					pstatement.setString(24, request.getParameter("LECDAY3"));
					pstatement.setString(25, request.getParameter("DISCDAY2"));
					pstatement.setString(26, request.getParameter("LABDAY2"));	
					pstatement.setInt(27, Integer.parseInt(request.getParameter("SECTIONID")));
					
					
					PreparedStatement check = conn.prepareStatement(
							("SELECT COUNT(1) FROM public.courses WHERE coursecode = ?"));
					check.setString(1, request.getParameter("COURSECODE"));
					ResultSet check_rs = null;
					check_rs = check.executeQuery();
					int flag = 0;
					if(check_rs.next()) {
						flag = check_rs.getInt(1);
					}
					// If the flag is still 0, that means the course code wasn't found in the table
					if(flag == 0) {
						System.out.println("Course code does not exist in Courses table!");
					}
					// The course code was found in the table, proceed to add the class
					else {
						pstatement.executeUpdate();
					}
						conn.commit();
						conn.setAutoCommit(true);
					}

				%>
				
				<%-- DELETE CODE --%>
				<%
				// Check if a delete is requested
				if(action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to
					// DELETE the class in the Classes table
					PreparedStatement ps = conn.prepareStatement(
							"DELETE FROM public.classes WHERE sectionid = ?");
					ps.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
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
				ResultSet rs = statement.executeQuery("SELECT * FROM public.classes ORDER BY sectionid ASC");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>Section ID</th>
						<th>Course Code</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Lecture Day 1</th>
						<th>Lecture Start Time</th>
						<th>Lecture End Time</th>
						<th>Discussion Day 1</th>
						<th>Discussion Start Time</th>
						<th>Discussion End Time</th>
						<th>Lab Day 1</th>
						<th>Lab Start Time</th>
						<th>Lab End Time</th>
						<th>Review Session Month</th>
						<th>Review Session Day</th>
						<th>Review Session Start Time</th>
						<th>Review Session End Time</th>
						<th>Final Month</th>
						<th>Final Day</th>
						<th>Final Start Time</th>
						<th>Final End Time</th>
						<th>Enrollment Limit</th>
						<th>Professor</th>
						<th>Lecture Day 2</th>
						<th>Lecture Day 3</th>
						<th>Discussion Day 2</th>
						<th>Lab Day 2</th>
					</tr>
					<tr>
						<form action="classes.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SECTIONID" size="50"></th>
							<th><input value="" name="COURSECODE" size="50"></th>
							<th><input value="" name="QUARTER" size="50"></th>
							<th><input value="" name="YEAR" size="50"></th>
							<th><input value="" name="LECDAY1" size="50"></th>
							<th><input value="" name="LECSTIME" size="50"></th>
							<th><input value="" name="LECETIME" size="50"></th>
							<th><input value="" name="DISCDAY1" size="50"></th>
							<th><input value="" name="DISCSTIME" size="50"></th>
							<th><input value="" name="DISCETIME" size="50"></th>
							<th><input value="" name="LABDAY1" size="50"></th>
							<th><input value="" name="LABSTIME" size="50"></th>
							<th><input value="" name="LABETIME" size="50"></th>	
							<th><input value=""	name="REVIEWMONTH" size="50"></th>
							<th><input value="" name="REVIEWDAY" size="50"></th>
							<th><input value="" name="REVIEWSTIME" size="50"></th>
							<th><input value="" name="REVIEWETIME" size="50"></th>
							<th><input value="" name="FINALMONTH" size="50"></th>
							<th><input value="" name="FINALDAY" size="50"></th>
							<th><input value="" name="FINALSTIME" size="50"></th>
							<th><input value="" name="FINALETIME" size="50"></th>
							<th><input value="" name="ENROLLLIMIT" size="50"></th>
							<th><input value="" name="PROFESSOR" size="50"></th>	
							<th><input value="" name="LECDAY2" size="50"></th>
							<th><input value="" name="LECDAY3" size="50"></th>	
							<th><input value="" name="DISCDAY2" size="50"></th>
							<th><input value="" name="LABDAY2" size="50"></th>			

							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="classes.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					        <td><input value="<%= rs.getInt("SECTIONID") %>" name="SECTIONID"></td>
					        <td><input value="<%= rs.getString("COURSECODE") %>" name="COURSECODE"></td>
					    	<td><input value="<%= rs.getString("QUARTER") %>" name="QUARTER"></td>
					    	<td><input value="<%= rs.getInt("YEAR") %>" name="YEAR"></td>
					    	<td><input value="<%= rs.getString("LECDAY1") %>" name="LECDAY1"></td>
					    	<td><input value="<%= rs.getInt("LECSTIME") %>" name="LECSTIME"></td>
					    	<td><input value="<%= rs.getInt("LECETIME") %>" name="LECETIME"></td>
					    	<td><input value="<%= rs.getString("DISCDAY1") %>" name="DISCDAY1"></td>
					    	<td><input value="<%= rs.getInt("DISCSTIME") %>" name="DISCSTIME"></td>
					    	<td><input value="<%= rs.getInt("DISCETIME") %>" name="DISCETIME"></td>
					    	<td><input value="<%= rs.getString("LABDAY1") %>" name="LABDAY1"></td>
					    	<td><input value="<%= rs.getInt("LABSTIME") %>" name="LABSTIME"></td>
					    	<td><input value="<%= rs.getInt("LABETIME") %>" name="LABETIME"></td>	
					    	<td><input value="<%= rs.getString("REVIEWMONTH") %>" name="REVIEWMONTH"></td>	
					    	<td><input value="<%= rs.getInt("REVIEWDAY") %>" name="REVIEWDAY"></td>
					    	<td><input value="<%= rs.getInt("REVIEWSTIME") %>" name="REVIEWSTIME"></td>
					    	<td><input value="<%= rs.getInt("REVIEWETIME") %>" name="REVIEWETIME"></td>						    				    	
							<td><input value="<%= rs.getString("FINALMONTH") %>" name="FINALMONTH"></td>	
					    	<td><input value="<%= rs.getInt("FINALDAY") %>" name="FINALDAY"></td>
					    	<td><input value="<%= rs.getInt("FINALSTIME") %>" name="FINALSTIME"></td>
					    	<td><input value="<%= rs.getInt("FINALETIME") %>" name="FINALETIME"></td>	
					    	<td><input value="<%= rs.getInt("ENROLLLIMIT") %>" name="ENROLLLIMIT"></td>
					    	<td><input value="<%= rs.getString("PROFESSOR") %>" name="PROFESSOR"></td>
					    	<td><input value="<%= rs.getString("LECDAY2") %>" name="LECDAY2"></td>
					    	<td><input value="<%= rs.getString("LECDAY3") %>" name="LECDAY3"></td>
					    	<td><input value="<%= rs.getString("DISCDAY2") %>" name="DISCDAY2"></td>
					    	<td><input value="<%= rs.getString("LABDAY2") %>" name="LABDAY2"></td>
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	<form action="classes.jsp" method="get">
				    		<input type="hidden" value="delete" name="action">
				    		<input type="hidden" value="<%= rs.getInt("SECTIONID") %>" name="SECTIONID">
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