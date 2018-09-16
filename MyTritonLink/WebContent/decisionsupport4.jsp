<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Decision Support 4 Query</title>
</head>
<body>
	<b>Decision Support 4 Query Form</b>
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
				
				%>
				<%-- PRESENTATION CODE --%>
				<form name="getstudent" method="post" action="decisionsupport4.jsp">
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
					<input type="Submit" value="Submit"></input>
				</form>
				<%
					String course = request.getParameter("course");
					String prof = request.getParameter("prof");
					String coursecode = "";
					if(course != null && prof != null){
						System.out.println("Searching for statistics for course " + course + " with professor " + prof);
						Statement s = conn.createStatement();
						

					PreparedStatement aplus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'A+' AND coursecode = ? AND professor = ?");
					aplus.setString(1, course);
					aplus.setString(2, prof);
					ResultSet rsap = aplus.executeQuery();
					
					PreparedStatement apgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'A+'");
					ResultSet rsapgp = apgp.executeQuery();
					
					PreparedStatement a = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'A' AND coursecode = ? AND professor = ?");
					a.setString(1, course);
					a.setString(2, prof);
					ResultSet rsa = a.executeQuery();
					
					PreparedStatement agp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'A'");
					ResultSet rsagp = agp.executeQuery();
					
					PreparedStatement aminus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'A-' AND coursecode = ? AND professor = ?");
					aminus.setString(1, course);
					aminus.setString(2, prof);
					ResultSet rsam = aminus.executeQuery();
					
					PreparedStatement amgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'A-'");
					ResultSet rsamgp = amgp.executeQuery();
					
					PreparedStatement bplus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'B+' AND coursecode = ? AND professor = ?");
					bplus.setString(1, course);
					bplus.setString(2, prof);
					ResultSet rsbp = bplus.executeQuery();
					
					PreparedStatement bpgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'B+'");
					ResultSet rsbpgp = bpgp.executeQuery();
					
					PreparedStatement b = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'B' AND coursecode = ? AND professor = ?");
					b.setString(1, course);
					b.setString(2, prof);
					ResultSet rsb = b.executeQuery();
					
					PreparedStatement bgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'B'");
					ResultSet rsbgp = bgp.executeQuery();
					
					PreparedStatement bminus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'B-' AND coursecode = ? AND professor = ?");
					bminus.setString(1, course);
					bminus.setString(2, prof);
					ResultSet rsbm = bminus.executeQuery();
					
					PreparedStatement bmgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'B-'");
					ResultSet rsbmgp = bmgp.executeQuery();
					
					PreparedStatement cplus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'C+' AND coursecode = ? AND professor = ?");
					cplus.setString(1, course);
					cplus.setString(2, prof);
					ResultSet rscp = cplus.executeQuery();
					
					PreparedStatement cpgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'C+'");
					ResultSet rscpgp = cpgp.executeQuery();
					
					PreparedStatement c = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'C' AND coursecode = ? AND professor = ?");
					c.setString(1, course);
					c.setString(2, prof);
					ResultSet rsc = c.executeQuery();
					
					PreparedStatement cgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'C'");
					ResultSet rscgp = cgp.executeQuery();
					
					PreparedStatement cminus = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'C-' AND coursecode = ? AND professor = ?");
					cminus.setString(1, course);
					cminus.setString(2, prof);
					ResultSet rscm = cminus.executeQuery();
					
					PreparedStatement cmgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'C-'");
					ResultSet rscmgp = cmgp.executeQuery();
					
					PreparedStatement d = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'D' AND coursecode = ? AND professor = ?");
					d.setString(1, course);
					d.setString(2, prof);
					ResultSet rsd = d.executeQuery();
					
					PreparedStatement dgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'D'");
					ResultSet rsdgp = dgp.executeQuery();
					
					PreparedStatement f = conn.prepareStatement(
							"SELECT COUNT(grade) FROM public.enroll WHERE grade = 'F' AND coursecode = ? AND professor = ?");
					f.setString(1, course);
					f.setString(2, prof);
					ResultSet rsf = f.executeQuery();
					
					PreparedStatement fgp = conn.prepareStatement(
							"SELECT gradevalue FROM public.grade_conversion WHERE lettergrade = 'F'");
					ResultSet rsfgp = fgp.executeQuery();					

					int count = 0;
					double gpa = 0;
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
					<th>GPA</th>
					<%
						while(rsap.next()){
					%>
						<tr>
							<form action="decisionsupport4.jsp" method="get">
					        	<input type="hidden" value="update" name="action">
					        		<td><input value="<%= rsap.getInt(1) %>" name="APLUS"></td>
					        		<%
					        			count += rsap.getInt(1);
					        		%>
					        		<%
					        			while(rsapgp.next()){
											gpa += rsap.getInt(1)*rsapgp.getDouble("gradevalue");
					        			}
					        		%>
				    		</form>
				    		<%
				    			while(rsa.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsa.getInt(1) %>" name="A"></td>
					        		<%
					        			count += rsa.getInt(1);
					        		%>
					        		<%
					        			while(rsagp.next()){
											gpa += rsa.getInt(1)*rsagp.getDouble("gradevalue");

					        			}
					        		%>					        		
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsam.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsam.getInt(1) %>" name="AMINUS"></td>
					        		<%
					        			count += rsam.getInt(1);
					        		%>
					        		<%
					        			while(rsamgp.next()){
											gpa += rsam.getInt(1)*rsamgp.getDouble("gradevalue");

					        			}
					        		%>							        							        			
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsbp.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsbp.getInt(1) %>" name="BPLUS"></td>
					        		<%
					        			count += rsbp.getInt(1);
					        		%>		
					        		<%
					        			while(rsbpgp.next()){
											gpa += rsbp.getInt(1)*rsbpgp.getDouble("gradevalue");

					        			}
					        		%>							        					        			
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsb.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsb.getInt(1) %>" name="B"></td>
					        		<%
					        			count += rsb.getInt(1);
					        		%>	
					        		<%
					        			while(rsbgp.next()){
											gpa += rsb.getInt(1)*rsbgp.getDouble("gradevalue");

					        			}
					        		%>						        						        			
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsbm.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsbm.getInt(1) %>" name="BMINUS"></td>
					        		<%
					        			count += rsbm.getInt(1);
					        		%>	
					        		<%
					        			while(rsbmgp.next()){
											gpa += rsbm.getInt(1)*rsbmgp.getDouble("gradevalue");

					        			}
					        		%>						        						        			
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rscp.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rscp.getInt(1) %>" name="CPLUS"></td>
					        		<%
					        			count += rscp.getInt(1);
					        		%>	
					        		<%
					        			while(rscpgp.next()){
											gpa += rscp.getInt(1)*rscpgp.getDouble("gradevalue");

					        			}
					        		%>						        						        			
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rsc.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsc.getInt(1) %>" name="C"></td>
					        		<%
					        			count += rsc.getInt(1);
					        		%>		
					        		<%
					        			while(rscgp.next()){
											gpa += rsc.getInt(1)*rscgp.getDouble("gradevalue");

					        			}
					        		%>						        					        			
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rscm.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rscm.getInt(1) %>" name="CMINUS"></td>
					        		<%
					        			count += rscm.getInt(1);
					        		%>		
					        		<%
					        			while(rscmgp.next()){
											gpa += rscm.getInt(1)*rscmgp.getDouble("gradevalue");

					        			}
					        		%>						        					        			
				    			</form>
				    		<%		
				    			}
				    		
				    		%>	
				    		<%
				    			while(rsd.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsd.getInt(1) %>" name="D"></td>
					        		<%
					        			count += rsd.getInt(1);
					        		%>			
					        		<%
					        			while(rsdgp.next()){
											gpa += rsd.getInt(1)*rsdgp.getDouble("gradevalue");

					        			}
					        		%>						        				        			
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rsf.next()){
				    		%>
				    			<form action="decisionsupport4.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsf.getInt(1) %>" name="F"></td>
					        		<%
					        			count += rsf.getInt(1);
					        		%>			
					        		<%
					        			while(rsfgp.next()){
											gpa += rsf.getInt(1)*rsfgp.getDouble("gradevalue");

					        			}
					        		%>						        				        			
				    			</form>
				    		<%		
				    			}
				    		%>					    		
				    		<form action="decisionsupport4.jsp" method="get">
				    			<input type="hidden" value="update" name="action">
				    				<td><input value="<%= (gpa/count) %>" name="GPA"></td>
				    		</form>			    					    						    					    					    		
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