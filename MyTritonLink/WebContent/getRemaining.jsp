<%@ page import="java.lang.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Remaining Degree Requirements Query</title>
</head>
<body>
	<b>Remaining Degree Requirements Query Form</b>
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
				
				Statement statement2 = conn.createStatement();
				ResultSet rs2 = statement2.executeQuery("SELECT * FROM public.degrees");
				%>
				<%-- PRESENTATION CODE --%>
				<form name="getstudent" method="post" action="getRemaining.jsp">
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
					<select name="degrees" id="degrees">
						<option>Select a degree:</option>
						<%
							while(rs2.next()){
						%>
								<option><%= rs2.getString("type")%></option>
						<%
							}
						%>
					</select>
					<input type="Submit" value="Submit"></input>
				</form>
				<%
					String str = request.getParameter("students");
					String deg = request.getParameter("degrees");
					System.out.println(str);
					System.out.println("degrees = " + deg);
					String coursecode = "";
					int unitsTaken = 0;
					int underflag = 0;
					int totalunder = 0;
					int totalupper = 0;
					if(str != null){
						Statement s = conn.createStatement();
						
						PreparedStatement ps = conn.prepareStatement(
								"SELECT ssn, firstname, middlename, lastname FROM public.students WHERE ssn = ?");
						ps.setInt(1, Integer.parseInt(request.getParameter("students")));
						
						// Use the statement to SELECT the student ssn FROM the Students table
						ResultSet r = ps.executeQuery();

						PreparedStatement ps2 = conn.prepareStatement(
								"SELECT DISTINCT coursecode FROM public.enroll WHERE ssn = ?");
						ps2.setInt(1, Integer.parseInt(request.getParameter("students")));
						
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
				    	<form action="getRemaining.jsp" method="get">
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
						<form action="getRemaining.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					    	<%-- Get the COURSECODE--%>
					        <td><input value="<%= enroll.getString("COURSECODE") %>" name="COURSECODE"></td>
							<%
								coursecode = enroll.getString("COURSECODE");
								String [] cctokens;
								cctokens = coursecode.split("(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)");
								//cctokens[1] is the numeric part of course code
								System.out.println(cctokens[1]);
								if(Integer.parseInt(cctokens[1]) < 100) {
									underflag = 1;
									System.out.println("hello");
								}
								else {
									underflag = 0;
								}
								
							%>
				    	</form>
				    </tr> 
				</table>
				
				<%
					PreparedStatement ps3 = conn.prepareStatement(
							"SELECT units FROM public.courses WHERE coursecode = ?");
					ps3.setString(1, coursecode);
					ResultSet course = ps3.executeQuery();

				%>
				<table>
					<th>Units</th>
					<%
					while(course.next()){
					%>
						<tr>
							<form action="getRemaining.jsp" method="get">
						        <input type="hidden" value="update" name="action">
						    	<td><input value="<%= course.getInt("UNITS") %>" name="UNITS"></td>	
						    	<%
						    		unitsTaken += course.getInt("UNITS");
						    		if(underflag == 1) {
						    			System.out.println("hello");
						    			totalunder += course.getInt("UNITS");
						    		}
						    		else {
						    			totalupper += course.getInt("UNITS");
						    		}
						    	%>				    	
				    		</form>
				    	</tr> 
				</table>
				<%} %>

					<% }%>
					<%
						PreparedStatement ps4 = conn.prepareStatement(
								"SELECT minupper,minlower,totalunits FROM public.degrees WHERE type = ?");
						ps4.setString(1, deg);
						ResultSet degrees = ps4.executeQuery();
						int minlower = 0;
						int minupper = 0;
						int totalunits = 0;
						int i = 0;
					%>
				<table>
					<th>Minimum Lower Div Units</th>
					<th>Minimum Upper Div Units</th>
					<%
					while(i < 1){
						degrees.next();
					%>
						<tr>
							<form action="getRemaining.jsp" method="get">
						        <input type="hidden" value="update" name="action">
						    	<td><input value="<%= degrees.getInt("MINLOWER") %>" name="MINLOWER"></td>	
						    	<td><input value="<%= degrees.getInt("MINUPPER") %>" name="MINUPPER"></td>	
						    	<td><input value="<%= degrees.getInt("TOTALUNITS") %>" name="TOTALUNITS"></td>
						    	<%
						    		minlower = degrees.getInt("MINLOWER");
						    		minupper = degrees.getInt("MINUPPER");
									totalunits = degrees.getInt("TOTALUNITS");
						    		i = i + 1;
						    	%>				    	
				    		</form>
				    	</tr> 
				</table>
				<%} %>
				<table>
						<th>Total Units Taken</th>
						<th>Total Units Needed</th>
						<th>Total Units (UPPER DIV)</th>
						<th>Upper div units needed</th>
						<th>Total Units (LOWER DIV)</th>
						<th>Lower div units needed</th>
							<tr>
								<td><input value="<%= (unitsTaken) %>"></td>
								<td><input value="<%= (totalunits - unitsTaken) %>"></td>
								<td><input value="<%= (totalupper) %>"></td>
								<td><input value="<%= (Math.max(0, minupper - totalupper)) %>"></td>
								<td><input value="<%= (totalunder) %>"></td>
								<td><input value="<%= (Math.max(0, minlower - totalunder)) %>"></td>
							</tr>
					</table>
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