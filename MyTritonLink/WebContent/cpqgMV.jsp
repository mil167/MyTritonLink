<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Decision Support 2 (MV) Query</title>
</head>
<body>
	<b>Decision Support 2 (MV) Query Form</b>
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
				<table>
					<tr>
						<th>Course Code</th>
						<th>Professor</th>
						<th>Quarter</th>
						<th>Year</th>
					</tr>
					<tr>
						<form action="cpqgMV.jsp" method="get">
							<input type="hidden" value="check grades" name="action">
							<th><input value="" name="COURSECODE" size="50"></th>
							<th><input value="" name="PROFESSOR" size="50"></th>
							<th><input value="" name="QUARTER" size="50"></th>
							<th><input value="" name="YEAR" size="50"></th>
							<th><input type="submit" value="Check grades"></th>
						</form>
					</tr>
				</table>
				<%-- STATEMENT CODE --%>
				<%
				String action = request.getParameter("action");
				// Create the statement 
				if(action != null && action.equals("check grades")){
				Statement statement = conn.createStatement();
				PreparedStatement aplus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'A+' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				aplus.setString(1, request.getParameter("COURSECODE"));
				aplus.setString(2, request.getParameter("PROFESSOR"));
				aplus.setString(3, request.getParameter("QUARTER"));
				aplus.setInt(4, Integer.parseInt(request.getParameter("YEAR")));

				ResultSet rsap = aplus.executeQuery();
				
				PreparedStatement a = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'A' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				a.setString(1, request.getParameter("COURSECODE"));
				a.setString(2, request.getParameter("PROFESSOR"));
				a.setString(3, request.getParameter("QUARTER"));
				a.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rsa = a.executeQuery();
				
				PreparedStatement aminus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'A-' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				aminus.setString(1, request.getParameter("COURSECODE"));
				aminus.setString(2, request.getParameter("PROFESSOR"));
				aminus.setString(3, request.getParameter("QUARTER"));
				aminus.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rsam = aminus.executeQuery();
				
				PreparedStatement bplus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'B+' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				bplus.setString(1, request.getParameter("COURSECODE"));
				bplus.setString(2, request.getParameter("PROFESSOR"));
				bplus.setString(3, request.getParameter("QUARTER"));
				bplus.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rsbp = bplus.executeQuery();
				
				PreparedStatement b = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'B' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				b.setString(1, request.getParameter("COURSECODE"));
				b.setString(2, request.getParameter("PROFESSOR"));
				b.setString(3, request.getParameter("QUARTER"));
				b.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rsb = b.executeQuery();
				
				PreparedStatement bminus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'B-' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				bminus.setString(1, request.getParameter("COURSECODE"));
				bminus.setString(2, request.getParameter("PROFESSOR"));
				bminus.setString(3, request.getParameter("QUARTER"));
				bminus.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rsbm = bminus.executeQuery();
				
				PreparedStatement cplus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'C+' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				cplus.setString(1, request.getParameter("COURSECODE"));
				cplus.setString(2, request.getParameter("PROFESSOR"));
				cplus.setString(3, request.getParameter("QUARTER"));
				cplus.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rscp = cplus.executeQuery();
				
				PreparedStatement c = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'C' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				c.setString(1, request.getParameter("COURSECODE"));
				c.setString(2, request.getParameter("PROFESSOR"));
				c.setString(3, request.getParameter("QUARTER"));
				c.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rsc = c.executeQuery();
				
				PreparedStatement cminus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'C-' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				cminus.setString(1, request.getParameter("COURSECODE"));
				cminus.setString(2, request.getParameter("PROFESSOR"));
				cminus.setString(3, request.getParameter("QUARTER"));
				cminus.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rscm = cminus.executeQuery();
				
				PreparedStatement d = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'D' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				d.setString(1, request.getParameter("COURSECODE"));
				d.setString(2, request.getParameter("PROFESSOR"));
				d.setString(3, request.getParameter("QUARTER"));
				d.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
				ResultSet rsd = d.executeQuery();
				
				PreparedStatement f = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpqg WHERE grade = 'F' AND coursecode = ? AND professor = ? AND quarter = ? AND year = ?");
				f.setString(1, request.getParameter("COURSECODE"));
				f.setString(2, request.getParameter("PROFESSOR"));
				f.setString(3, request.getParameter("QUARTER"));
				f.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
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
							<form action="cpqgMV.jsp" method="get">
					        	<input type="hidden" value="update" name="action">
					        		<td><input value="<%= rsap.getInt(1) %>" name="APLUS"></td>
				    		</form>
				    		<%
				    			while(rsa.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsa.getInt(1) %>" name="A"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsam.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsam.getInt(1) %>" name="AMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsbp.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsbp.getInt(1) %>" name="BPLUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsb.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsb.getInt(1) %>" name="B"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsbm.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsbm.getInt(1) %>" name="BMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rscp.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rscp.getInt(1) %>" name="CPLUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rsc.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsc.getInt(1) %>" name="C"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rscm.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rscm.getInt(1) %>" name="CMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		
				    		%>	
				    		<%
				    			while(rsd.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsd.getInt(1) %>" name="D"></td>
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rsf.next()){
				    		%>
				    			<form action="cpqgMV.jsp" method="get">
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

				<%-- CLOSE CONNECTION CODE --%>
				<%
				// Close the ResultSet
				rsap.close();
				rsa.close();
				rsam.close();
				rsbp.close();
				rsb.close();
				rsbm.close();
				rscp.close();
				rsc.close();
				rscm.close();
				rsd.close();
				rsf.close();
				
				// Close the Statement
				statement.close();
				
				// Close the connection
				conn.close();
				}
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