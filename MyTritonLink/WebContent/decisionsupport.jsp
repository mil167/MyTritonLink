<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Decision Support Query</title>
</head>
<body>
	<b>Decision Support Query Form</b>
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
				ResultSet rs = statement.executeQuery("SELECT * FROM public.courses");
				
				Statement statement2 = conn.createStatement();
				ResultSet rs2 = statement2.executeQuery("SELECT * FROM public.faculty");
				
				Statement statement3 = conn.createStatement();
				ResultSet rs3 = statement3.executeQuery("SELECT * FROM public.classes");
				%>
				<%-- PRESENTATION CODE --%>
				<form name="getstudent" method="post" action="decisionsupport.jsp">
					<select name="course" id="course">
						<option>Select a course:</option>
						<%
							while(rs.next()){
						%>
								<option><%= rs.getString("coursecode")%></option>
						<%
							}
						%>
					</select>
					<select name="prof" id="prof">
						<option>Select a professor:</option>
						<%
							while(rs2.next()){
						%>
								<option><%= rs2.getString("facultyname")%></option>
						<%
							}
						%>
					</select>
					<select name="quarter" id="quarter">
						<option>Select a quarter:</option>
						<%
							while(rs3.next()){
						%>
								<option><%= rs3.getString("quarter")%></option>
						<%
							}
						%>
					</select>
					<input type="Submit" value="Submit"></input>
				</form>
				<%
					String course = request.getParameter("course");
					String prof = request.getParameter("prof");
					String quarter = request.getParameter("quarter");
					String coursecode = "";
					if(course != null && prof != null && quarter != null){
						System.out.println("Searching for statistics for course " + course + " with professor " + prof + " in quarter " + quarter);
						Statement s = conn.createStatement();
						

					PreparedStatement aplus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'A+' AND coursecode = ? AND professor = ? AND quarter = ?");
					aplus.setString(1, course);
					aplus.setString(2, prof);
					aplus.setString(3, quarter);
					ResultSet rsap = aplus.executeQuery();
					
					PreparedStatement a = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'A' AND coursecode = ? AND professor = ? AND quarter = ?");
					a.setString(1, course);
					a.setString(2, prof);
					a.setString(3, quarter);
					ResultSet rsa = a.executeQuery();
					
					PreparedStatement aminus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'A-' AND coursecode = ? AND professor = ? AND quarter = ?");
					aminus.setString(1, course);
					aminus.setString(2, prof);
					aminus.setString(3, quarter);
					ResultSet rsam = aminus.executeQuery();
					
					PreparedStatement bplus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'B+' AND coursecode = ? AND professor = ? AND quarter = ?");
					bplus.setString(1, course);
					bplus.setString(2, prof);
					bplus.setString(3, quarter);
					ResultSet rsbp = bplus.executeQuery();
					
					PreparedStatement b = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'B' AND coursecode = ? AND professor = ? AND quarter = ?");
					b.setString(1, course);
					b.setString(2, prof);
					b.setString(3, quarter);
					ResultSet rsb = b.executeQuery();
					
					PreparedStatement bminus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'B-' AND coursecode = ? AND professor = ? AND quarter = ?");
					bminus.setString(1, course);
					bminus.setString(2, prof);
					bminus.setString(3, quarter);
					ResultSet rsbm = bminus.executeQuery();
					
					PreparedStatement cplus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'C+' AND coursecode = ? AND professor = ? AND quarter = ?");
					cplus.setString(1, course);
					cplus.setString(2, prof);
					cplus.setString(3, quarter);
					ResultSet rscp = cplus.executeQuery();
					
					PreparedStatement c = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'C' AND coursecode = ? AND professor = ? AND quarter = ?");
					c.setString(1, course);
					c.setString(2, prof);
					c.setString(3, quarter);
					ResultSet rsc = c.executeQuery();
					
					PreparedStatement cminus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'C-' AND coursecode = ? AND professor = ? AND quarter = ?");
					cminus.setString(1, course);
					cminus.setString(2, prof);
					cminus.setString(3, quarter);
					ResultSet rscm = cminus.executeQuery();
					
					PreparedStatement d = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'D' AND coursecode = ? AND professor = ? AND quarter = ?");
					d.setString(1, course);
					d.setString(2, prof);
					d.setString(3, quarter);
					ResultSet rsd = d.executeQuery();
					
					PreparedStatement f = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'F' AND coursecode = ? AND professor = ? AND quarter = ?");
					f.setString(1, course);
					f.setString(2, prof);
					f.setString(3, quarter);
					ResultSet rsf = f.executeQuery();
				%>
				<table>
					<th>A+</th>
					<th>A</th>
					<th>A-</th>
					<th>B+</th>
					<th>B</th>
					<th>B-</th>
					<th>C+</th>
					<th>C</th>
					<th>C-</th>
					<th>D</th>
					<th>F</th>
					<%
						while(rsap.next()){
					%>
						<tr>
							<form action="decisionsupport.jsp" method="get">
					        	<input type="hidden" value="update" name="action">
					        		<td><input value="<%= rsap.getInt(1) %>" name="APLUS"></td>
				    		</form>
				    		<%
				    			while(rsa.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsa.getInt(1) %>" name="A"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsam.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsam.getInt(1) %>" name="AMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsbp.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsbp.getInt(1) %>" name="BPLUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsb.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsb.getInt(1) %>" name="B"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsbm.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsbm.getInt(1) %>" name="BMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rscp.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rscp.getInt(1) %>" name="CPLUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rsc.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsc.getInt(1) %>" name="C"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rscm.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rscm.getInt(1) %>" name="CMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		
				    		%>	
				    		<%
				    			while(rsd.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsd.getInt(1) %>" name="D"></td>
				    			</form>
				    		<%		
				    			}
				    		%>		
				    		<%
				    			while(rsf.next()){
				    		%>
				    			<form action="decisionsupport.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsf.getInt(1) %>" name="F"></td>
				    			</form>
				    		<%		
				    			}
				    		%>					    				    					    						    					    					    		
						</tr>
					<%
						}
					%>
				</table>
				<%
					}
				%>


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