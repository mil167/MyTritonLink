<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Degree Data Entry Form</title>
</head>
<body>
	<b>Degree Data Entry Menu</b>
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
				String conc = "";
				if(action != null && action.equals("insert")){
					conn.setAutoCommit(false);
				
				// Create the prepared statement and use it to 
				// INSERT the faculty attributes INTO the Faculty table
				PreparedStatement pstmt = conn.prepareStatement(
						("INSERT INTO public.degree VALUES(?,?,?,?,?,?,?,?)"));
				
				pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN")));
				pstmt.setInt(2, Integer.parseInt(request.getParameter("TOTALUNITS")));
				pstmt.setDouble(3, Double.parseDouble(request.getParameter("MINGPA")));
				pstmt.setInt(4, Integer.parseInt(request.getParameter("MINLOWERDIV")));
				pstmt.setInt(5, Integer.parseInt(request.getParameter("MINUPPERDIV")));
				pstmt.setString(6, request.getParameter("CONCENTRATION"));
				pstmt.setString(7, request.getParameter("NAME"));
				pstmt.setString(8, request.getParameter("TYPE"));
				conc = request.getParameter("CONCENTRATION");
				PreparedStatement check2 = conn.prepareStatement(
						("SELECT COUNT(1) FROM public.students WHERE ssn = ?"));
				
				check2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
				int ssn_copy = Integer.parseInt(request.getParameter("SSN"));
				ResultSet check2_rs = null;
				check2_rs = check2.executeQuery();
				int flag = 0;
				int studentok = 0;
				if(check2_rs.next()) {
					flag = check2_rs.getInt(1);
				}
				// If the flag is still 0, that means the ssn wasn't found in the table

				String query = "SELECT department FROM public.students WHERE ssn = " + "'" + ssn_copy + "'";
				String dept_string = "";
				PreparedStatement check3 = conn.prepareStatement(query);
				ResultSet rs3 = null;
				rs3 = check3.executeQuery();
				while(rs3.next()) {
					dept_string = rs3.getString("department");
				}
				if(flag == 0) {
					System.out.println("SSN does not exist in Students table!");
				}
				// Department is empty and concentration field is not empty
				else if(dept_string.equals(("")) && !conc.equals("")){
					System.out.println("Only MS students can have a concentration!");	
				}
				// The ssn was found in the table
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
					System.out.println("update was pressed");
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to 
					// UPDATE the faculty attributes in the Faculty table.
					PreparedStatement pstatement = conn.prepareStatement(
							("UPDATE public.degree SET totalunits = ?, mingpa = ?, " +
							"minlowerdiv = ?, minupperdiv = ?, concentration = ?, name = ?, type = ? WHERE ssn = ?"));
					

					pstatement.setInt(1, Integer.parseInt(request.getParameter("TOTALUNITS")));
					pstatement.setDouble(2, Double.parseDouble(request.getParameter("MINGPA")));
					pstatement.setInt(3, Integer.parseInt(request.getParameter("MINLOWERDIV")));
					pstatement.setInt(4, Integer.parseInt(request.getParameter("MINUPPERDIV")));
					pstatement.setString(5, request.getParameter("CONCENTRATION"));
					conc = request.getParameter("CONCENTRATION");
					pstatement.setString(6, request.getParameter("NAME"));
					pstatement.setString(7, request.getParameter("TYPE"));
					pstatement.setInt(8, Integer.parseInt(request.getParameter("SSN")));
					int ssn_copy = Integer.parseInt(request.getParameter("SSN"));
					
					String query2 = "SELECT department FROM public.students WHERE ssn = " + "'" + ssn_copy + "'";
					PreparedStatement check_update = conn.prepareStatement(query2);
					String dept_string = "";
					ResultSet rs3 = null;
					rs3 = check_update.executeQuery();
					while(rs3.next()) {
						dept_string = rs3.getString("department");
					}
					// Department is empty and concentration field is not empty
					if(dept_string.equals(("")) && !conc.equals("")){
						System.out.println("Only MS students can have a concentration!");	
					}
					
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
							"DELETE FROM public.degree WHERE ssn = ?");
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
				
				// Use the statement to SELECT the faculty attributes FROM the Faculty table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.degree");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>SSN</th>
						<th>Total Units</th>
						<th>Min. GPA</th>
						<th>Min. Lower Div Units</th>
						<th>Min. Upper Div Units</th>
						<th>Concentration (MS Students only)</th>
						<th>Name</th>
						<th>Type</th>
					</tr>
					<tr>
						<form action="degree.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SSN" size="50"></th>
							<th><input value="" name="TOTALUNITS" size="50"></th>
							<th><input value="" name="MINGPA" size="50"></th>
							<th><input value="" name="MINLOWERDIV" size="50"></th>
							<th><input value="" name="MINUPPERDIV" size="50"></th>
							<th><input value="" name="CONCENTRATION" size="50"></th>
							<th><input value="" name="NAME" size="50"></th>
							<th><input value="" name="TYPE" size="50"></th>

							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="degree.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					        <%-- Get the SSN --%>
					        <td><input value="<%= rs.getInt("SSN") %>" name="SSN"></td>
					    	<%-- Get the TOTALUNITS --%>
					    	<td><input value="<%= rs.getInt("TOTALUNITS") %>" name="TOTALUNITS"></td>
					    	<%-- Get the MINGPA --%>
					    	<td><input value="<%= rs.getDouble("MINGPA") %>" name="MINGPA"></td>
					    	<%-- Get the MINLOWERDIV --%>
					    	<td><input value="<%= rs.getInt("MINLOWERDIV") %>" name="MINLOWERDIV"></td>
					    	<%-- Get the MINUPPERDIV --%>
					    	<td><input value="<%= rs.getInt("MINUPPERDIV") %>" name="MINUPPERDIV"></td>
					    	<%-- Get the CONCENTRATION --%>
					    	<td><input value="<%= rs.getString("CONCENTRATION") %>" name="CONCENTRATION"></td>
							<td><input value="<%= rs.getString("NAME") %>" name="NAME"></td>
							<td><input value="<%= rs.getString("TYPE") %>" name="TYPE"></td>					    	
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	<form action="degree.jsp" method="get">
				    		<input type="hidden" value="delete" name="action">
				    		<input type="hidden" value="<%= rs.getInt("SSN") %>" name="SSN">
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
				System.out.println("Connection closing.");
			}
				%>
			</td>
		</tr>		
	</table>
</body>
</html>