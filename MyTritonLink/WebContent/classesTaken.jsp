<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Classes Taken Query</title>
</head>
<body>
	<b>Classes Taken Query Form</b>
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
			<a href="course	ment.jsp">Course Enrollment</a>
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

				<%-- STATEMENT CODE --%>
				<%
				// Create the statement 
				Statement statement = conn.createStatement();
				
				// Use the statement to SELECT the student ssn FROM the Students table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.students");
				%>
				<%-- PRESENTATION CODE --%>
				<form name="getstudent" method="post" action="classesTaken.jsp">
					<select name="students" id="students">
						<option>Select an SSN:</option>
						<%
							while(rs.next()){
						%>
								<option><%= rs.getString("ssn")%></option>
						<%
							}
						%>
					</select>
					<input type="Submit" value="Submit"></input>
				</form>
				<%
					String str = request.getParameter("students");
					String coursecode = "";
					if(str != null){
						Statement s = conn.createStatement();
						
						PreparedStatement ps = conn.prepareStatement(
								"SELECT ssn, firstname, middlename, lastname FROM public.students WHERE ssn = ?");
						ps.setInt(1, Integer.parseInt(request.getParameter("students")));
						
						// Use the statement to SELECT the student ssn FROM the Students table
						ResultSet r = ps.executeQuery();

						PreparedStatement ps2 = conn.prepareStatement(
								"SELECT * FROM public.enroll WHERE ssn = ? and quarter = ?");
						ps2.setInt(1, Integer.parseInt(request.getParameter("students")));
						ps2.setString(2, "sp18");
						
						ResultSet enroll = ps2.executeQuery();
						
				%>
				<table>
					<tr>
						<th>SSN</th>
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
					</tr>
					<%
					// Iterate over the ResultSet
					while(r.next()) {
				    %>
				    
				    <tr>
				    	<form action="classesTaken.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					    	<%-- Get the SSN--%>
					        <td><input value="<%= r.getInt("SSN") %>" name="SSN"></td>
									    	
					    	<%-- Get the FIRSTNAME --%>
					    	<td><input value="<%= r.getString("FIRSTNAME") %>" name="FIRSTNAME"></td>
					    	
					    	<%-- Get the MIDDLENAME --%>
				    		<td><input value="<%= r.getString("MIDDLENAME") %>" name="MIDDLENAME"></td>
				    		
				    		<%-- Get the LASTNAME --%>
				    		<td><input value="<%= r.getString("LASTNAME") %>" name="LASTNAME"></td>
				    	</form>
				    </tr> 
				</table>
				<%
					}
				%>
				<table>
					<th>Course Code</th>
					<th>Section ID</th>
					<%
					while(enroll.next()){
					%>
					
					<tr>
						<form action="classesTaken.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					    	<%-- Get the COURSECODE--%>
					        <td><input value="<%= enroll.getString("COURSECODE") %>" name="COURSECODE"></td>
							<%
								coursecode = enroll.getString("COURSECODE");
							%>
					    	<%-- Get the SECTIONID --%>
					    	<td><input value="<%= enroll.getString("SECTIONID") %>" name="SECTIONID"></td>
				    	</form>
				    </tr> 
				</table>
				
				<%
					PreparedStatement ps3 = conn.prepareStatement(
							"SELECT * FROM public.courses WHERE coursecode = ? and quarter = ?");
					ps3.setString(1, coursecode);
					ps3.setString(2, "sp18");
					ResultSet course = ps3.executeQuery();

				%>
				<table>
					<th>Pre-requisites</th>
					<th>Units</th>
					<th>Grade Type</th>
					<th>Lab</th>
					<th>Quarter</th>
					<%
					while(course.next()){
					%>
						<tr>
							<form action="classesTaken.jsp" method="get">
						        <input type="hidden" value="update" name="action">
						    	<%-- Get the PREREQUISITES--%>
						        <td><input value="<%= course.getString("PREREQUISITES") %>" name="PREREQUISITES"></td>
										    	
						    	<%-- Get the UNITS --%>
						    	<td><input value="<%= course.getInt("UNITS") %>" name="UNITS"></td>
						    	
						    	<%-- Get the GRADETYPE --%>
						    	<td><input value="<%= course.getString("GRADETYPE") %>" name="GRADETYPE"></td>
						    	
						    	<%-- Get the LAB --%>
						    	<td><input value="<%= course.getString("LAB") %>" name="LAB"></td>
						    	
						    	<%-- Get the QUARTER --%>
						    	<td><input value="<%= course.getString("QUARTER") %>" name="QUARTER"></td>						    	
				    		</form>
				    	</tr> 
				</table>
				<%} %>

					<% }%>
					<%} %>	

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