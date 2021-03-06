<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Class Schedule Query</title>
</head>
<body>
	<b>Class Schedule Query Form</b>
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
				<form name="getstudent" method="post" action="schedule.jsp">
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
								"SELECT * FROM public.enroll WHERE ssn = ? AND quarter = ?");
						ps2.setInt(1, Integer.parseInt(str));
						ps2.setString(2, "sp18");
						
						ResultSet enroll = ps2.executeQuery();
						ArrayList<String> classes = new ArrayList<String>();
						
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
				    	<form action="schedule.jsp" method="get">
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
					<%
					while(enroll.next()){
					%>
					
					<tr>
						<form action="schedule.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					    	<%-- Get the COURSECODE --%>
					    	<td><input value="<%= enroll.getString("COURSECODE") %>" name="COURSECODE"></td>
					    	<%
					    		coursecode = enroll.getString("COURSECODE");
					    		classes.add(coursecode);
					    	%>
				    	</form>
				    </tr> 
				</table>
					<%
						for (int i = 0; i < classes.size(); i++){	
							PreparedStatement enrolled = conn.prepareStatement(
									"SELECT * FROM public.classes WHERE coursecode = ? AND quarter = ? AND coursecode != ?");
							enrolled.setString(1, coursecode);
							enrolled.setString(2, "sp18");
							ResultSet rsenroll = enrolled.executeQuery();
							
//							while(rsenroll)
						}
					%>
					
						<table>
							<th>Course Code (Not Enrolled)</th>
							<th>Lecture Time(Not Enrolled)</th>
							<% while(rs3.next()) { %>
							<tr>
								<form action="schedule.jsp" method="get">
							        <input type="hidden" value="update" name="action">
							    	<%-- Get the COURSECODE --%>
							    	<td><input value="<%= rs3.getString("COURSECODE") %>" name="COURSECODE"></td>
							    	
							    	<td><input value="<%= rs3.getString("LECTURETIME") %>" name="LECTURETIME"></td>

						    	</form>
						    </tr> 
							
						</table>
					<% 

						}
					%>
				


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