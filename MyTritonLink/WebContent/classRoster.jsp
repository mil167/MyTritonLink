<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Class Roster Query</title>
</head>
<body>
	<b>Class Roster Query Form</b>
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

				<%-- STATEMENT CODE --%>
				<%
				// Create the statement 
				Statement statement = conn.createStatement();
				
				// Use the statement to SELECT the student ssn FROM the Students table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.classes");
				%>
				<%-- PRESENTATION CODE --%>
				<form name="gettitle" method="post" action="classRoster.jsp">
					<select name="title" id="title">
						<option>Select a Class Title:</option>
						<%
							while(rs.next()){
						%>
								<option><%= rs.getString("title")%></option>
						<%
							}
						%>
					</select>
					<input type="Submit" value="Submit"></input>
				</form>
				<%
					String classtitle = request.getParameter("title");
					String coursecode = "";
					if(classtitle != null){
						Statement s = conn.createStatement();
						
						PreparedStatement ps = conn.prepareStatement(
								"SELECT coursecode, quarter FROM public.classes WHERE title =  ?");
						ps.setString(1, classtitle);
						
						// Use the statement to SELECT the student ssn FROM the Students table
						ResultSet r = ps.executeQuery();

						//PreparedStatement ps2 = conn.prepareStatement(
						//		"SELECT * FROM public.enroll WHERE ssn = ?");
						//ps2.setString(1, request.getParameter("students"));
						
						//ResultSet enroll = ps2.executeQuery();

				%>
				<table>
					<tr>
						<th>Course Code</th>
						<th>Quarter</th>
					</tr>
					<%
					// Iterate over the ResultSet
					while(r.next()) {
				    %>
				    
				    <tr>
				    	<form action="classRoster.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					    	<%-- Get the COURSECODE--%>
					        <td><input value="<%= r.getString("COURSECODE") %>" name="COURSECODE"></td>
							<%
								coursecode = r.getString("COURSECODE");
							%>
					    	<%-- Get the QUARTER --%>
					    	<td><input value="<%= r.getString("QUARTER") %>" name="QUARTER"></td>

				    	</form>
				    </tr> 
				</table>
				<%
					}
				%>
				
				<%
					PreparedStatement ps4 = conn.prepareStatement(
							"SELECT units, gradetype FROM public.courses WHERE coursecode = ?");
					ps4.setString(1, coursecode);
					ResultSet rs4 = ps4.executeQuery();
				%>
				<table>
					<tr>
						<th>Units</th>
						<th>Grade Type</th>
					</tr>
				<%
					while(rs4.next()){
				%>
					<tr>
				    	<form action="classRoster.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					    	<%-- Get the UNITS --%>
					    	<td><input value="<%= rs4.getInt("UNITS") %>" name="UNITS"></td>
					    	<%-- Get the GRADETYPE --%>
					    	<td><input value="<%= rs4.getString("GRADETYPE") %>" name="GRADETYPE"></td>	
				    	</form>
				    </tr> 
				</table>
				<%
					}
				%>
				<%
					PreparedStatement ps2 = conn.prepareStatement(
								"SELECT * FROM public.enroll WHERE coursecode = ? and quarter = ?");
					ps2.setString(1, coursecode);
					ps2.setString(2, "sp18");
					ResultSet rs2 = ps2.executeQuery();
					ArrayList<Integer> ssns = new ArrayList<Integer>();
					while(rs2.next()){
						ssns.add(rs2.getInt("SSN"));
					}
				%>
				<table>
					<th>SSN</th>
					<th>ID</th>
					<th>Last name</th>
					<th>First name</th>
					<th>College</th>
					<th>Middle name</th>
					<th>Start Date</th>
					<th>End Date</th>
					<th>Major</th>
					<th>Minor</th>
					<th>Department</th>
					<th>Resident</th>
					<th>Grad Class</th>
					<th>PhD Class</th>
					<th>Advisor</th>
					

				<%
					for(int i:ssns){
						System.out.println(i);
						PreparedStatement ps3 = conn.prepareStatement(
								"SELECT * FROM public.students WHERE ssn = ?");
						ps3.setInt(1, i);
						ResultSet rs3 = ps3.executeQuery();
						
				%>
				<% 
				while(rs3.next()){
				%>
					<tr>
						<form action="classRoster.jsp" method="get">
					    	<%-- Get the SSN, which is a number --%>
					        <td><input value="<%= rs3.getInt("SSN") %>" name="SSN"></td>
					    	
					    	<%-- Get the ID --%>
					    	<td><input value="<%= rs3.getString("ID") %>" name="ID"></td>
					    	
					    	<%-- Get the LASTNAME --%>
					    	<td><input value="<%= rs3.getString("LASTNAME") %>" name="LASTNAME"></td>
					    	
					    	<%-- Get the FIRSTNAME --%>
					    	<td><input value="<%= rs3.getString("FIRSTNAME") %>" name="FIRSTNAME"></td>
					    	
					    	<%-- Get the MIDDLENAME --%>
					    	<td><input value="<%= rs3.getString("MIDDLENAME") %>" name="MIDDLENAME"></td>
					    	
					    	<%-- Get the COLLEGE --%>
					    	<td><input value="<%= rs3.getString("COLLEGE") %>" name="COLLEGE"></td>
					    	
					    	<%-- Get the STARTDATE --%>
					    	<td><input value="<%= rs3.getString("STARTDATE") %>" name="STARTDATE"></td>
					    	
					    	<%-- Get the ENDDATE --%>
					    	<td><input value="<%= rs3.getString("ENDDATE") %>" name="ENDDATE"></td>
					    	
					    	<%-- Get the MAJOR --%>
					    	<td><input value="<%= rs3.getString("MAJOR") %>" name="MAJOR"></td>
					    	
					    	<%-- Get the MINOR --%>
					    	<td><input value="<%= rs3.getString("MINOR") %>" name="MINOR"></td>
					    	
					    	<%-- Get the DEPARTMENT --%>
					    	<td><input value="<%= rs3.getString("DEPARTMENT") %>" name="DEPARTMENT"></td>
					    	
					    	<%-- Get the RESIDENT --%>
					    	<td><input value="<%= rs3.getString("RESIDENT") %>" name="RESIDENT"></td>
					    	
					    	<%-- Get the GRADCLASS --%>
					    	<td><input value="<%= rs3.getString("GRADCLASS") %>" name="GRADCLASS"></td>
					    	
					    	<%-- Get the PHDCLASS --%>
					    	<td><input value="<%= rs3.getString("PHDCLASS") %>" name="PHDCLASS"></td>
					    	
					    	<%-- Get the ADVISOR --%>
					    	<td><input value="<%= rs3.getString("ADVISOR") %>" name="ADVISOR"></td>							
						</form>
						</tr>
				</table>
				<% } %>
				<%} %>
				<%-- HERE --%>
					<% }%>	

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