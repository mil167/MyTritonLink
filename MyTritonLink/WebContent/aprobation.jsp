<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Academic Probation Data Entry Form</title>
</head>
<body>
	<b>Academic Probation Data Entry Menu</b>
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
				// INSERT the academic probation attributes INTO the Aprobation table
				PreparedStatement pstmt = conn.prepareStatement(
						("INSERT INTO public.aprobation VALUES(?,?,?,?)"));
				
				pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN")));
				pstmt.setString(2, request.getParameter("STARTDATE"));
				pstmt.setString(3, request.getParameter("ENDDATE"));
				pstmt.setString(4, request.getParameter("REASON"));
				PreparedStatement check2 = conn.prepareStatement(
						("SELECT COUNT(1) FROM public.students WHERE ssn = ?"));
				
				check2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
				ResultSet check2_rs = null;
				check2_rs = check2.executeQuery();
				int flag = 0;
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
					pstmt.executeUpdate();
				}
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				//pstmt.executeUpdate();
				
				//conn.commit();
				//conn.setAutoCommit(true);
				//}
				%>
				
				<%-- UPDATE CODE --%>
				<%
				// Check if an update is requested
				if(action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to 
					// UPDATE the academic probation attributes in the Aprobation table.
					PreparedStatement pstatement = conn.prepareStatement(
							"UPDATE public.aprobation SET startdate = ?, enddate = ?," +
							"reason = ? WHERE ssn = ?");
					
					pstatement.setString(1,request.getParameter("STARTDATE"));
					pstatement.setString(2,request.getParameter("ENDDATE"));
					pstatement.setString(3,request.getParameter("REASON"));
					pstatement.setInt(4,Integer.parseInt(request.getParameter("SSN")));
					
					PreparedStatement check2 = conn.prepareStatement(
							("SELECT COUNT(1) FROM public.students WHERE ssn = ?"));
					
					check2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					ResultSet check2_rs = null;
					check2_rs = check2.executeQuery();
					int flag = 0;
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
					// DELETE the aprobation in the Aprobation table
					PreparedStatement ps = conn.prepareStatement(
							"DELETE FROM public.aprobation WHERE ssn = ?");
					ps.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					ps.executeUpdate();
					conn.setAutoCommit(false);
					conn.setAutoCommit(true);
				}
				%>
				<%-- STATEMENT CODE --%>
				<%
				// Create the statement 
				Statement statement = conn.createStatement();
				
				// Use the statement to SELECT the academic probation attributes FROM the Aprobation table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.aprobation");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>SSN</th>
						<th>Start Date</th>
						<th>End Date</th>
						<th>Reason</th>
					</tr>
					<tr>
						<form action="aprobation.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SSN" size="50"></th>
							<th><input value="" name="STARTDATE" size="50"></th>
							<th><input value="" name="ENDDATE" size="50"></th>
							<th><input value="" name="REASON" size="100"></th>

							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="aprobation.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					        <%-- Get the SSN --%>
					        <td><input value="<%= rs.getInt("SSN") %>" name="SSN"></td>
					    	<%-- Get the STARTDATE --%>
					    	<td><input value="<%= rs.getString("STARTDATE") %>" name="STARTDATE"></td>
					    	<%-- Get the ENDDATE --%>
					    	<td><input value="<%= rs.getString("ENDDATE") %>" name="ENDDATE"></td>
					    	<%-- Get the REASON --%>
					    	<td><input value="<%= rs.getString("REASON") %>" name="REASON"></td>
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	<form action="aprobation.jsp" method="get">
				    		<input type="hidden" value="delete" name="action">
				    		<input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
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