<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Decision Support 3 (MV) Query</title>
</head>
<body>
	<b>Decision Support 3 (MV) Query Form</b>
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
				PreparedStatement aplus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'A+' AND coursecode = ? AND professor = ?");
				aplus.setString(1, request.getParameter("COURSECODE"));
				aplus.setString(2, request.getParameter("PROFESSOR"));

				ResultSet rsap = aplus.executeQuery();
				
				PreparedStatement a = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'A' AND coursecode = ? AND professor = ?");
				a.setString(1, request.getParameter("COURSECODE"));
				a.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rsa = a.executeQuery();
				
				PreparedStatement aminus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'A-' AND coursecode = ? AND professor = ?");
				aminus.setString(1, request.getParameter("COURSECODE"));
				aminus.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rsam = aminus.executeQuery();
				
				PreparedStatement bplus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'B+' AND coursecode = ? AND professor = ?");
				bplus.setString(1, request.getParameter("COURSECODE"));
				bplus.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rsbp = bplus.executeQuery();
				
				PreparedStatement b = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'B' AND coursecode = ? AND professor = ?");
				b.setString(1, request.getParameter("COURSECODE"));
				b.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rsb = b.executeQuery();
				
				PreparedStatement bminus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'B-' AND coursecode = ? AND professor = ?");
				bminus.setString(1, request.getParameter("COURSECODE"));
				bminus.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rsbm = bminus.executeQuery();
				
				PreparedStatement cplus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'C+' AND coursecode = ? AND professor = ?");
				cplus.setString(1, request.getParameter("COURSECODE"));
				cplus.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rscp = cplus.executeQuery();
				
				PreparedStatement c = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'C' AND coursecode = ? AND professor = ?");
				c.setString(1, request.getParameter("COURSECODE"));
				c.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rsc = c.executeQuery();
				
				PreparedStatement cminus = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'C-' AND coursecode = ? AND professor = ?");
				cminus.setString(1, request.getParameter("COURSECODE"));
				cminus.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rscm = cminus.executeQuery();
				
				PreparedStatement d = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'D' AND coursecode = ? AND professor = ?");
				d.setString(1, request.getParameter("COURSECODE"));
				d.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rsd = d.executeQuery();
				
				PreparedStatement f = conn.prepareStatement(
						"SELECT COUNT(grade) FROM cpg WHERE grade = 'F' AND coursecode = ? AND professor = ?");
				f.setString(1, request.getParameter("COURSECODE"));
				f.setString(2, request.getParameter("PROFESSOR"));
				ResultSet rsf = f.executeQuery();
				
				%>
				<table>
					<tr>
						<th>Course Code</th>
						<th>Professor</th>
					</tr>
					<tr>
						<form action="cpgMV.jsp" method="get">
							<input type="hidden" value="check grades" name="action">
							<th><input value="" name="COURSECODE" size="50"></th>
							<th><input value="" name="PROFESSOR" size="50"></th>
							<th><input type="submit" value="Check grades"></th>
						</form>
					</tr>
				</table>
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
							<form action="cpgMV.jsp" method="get">
					        	<input type="hidden" value="update" name="action">
					        		<td><input value="<%= rsap.getInt(1) %>" name="APLUS"></td>
				    		</form>
				    		<%
				    			while(rsa.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsa.getInt(1) %>" name="A"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsam.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsam.getInt(1) %>" name="AMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsbp.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsbp.getInt(1) %>" name="BPLUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsb.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsb.getInt(1) %>" name="B"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rsbm.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsbm.getInt(1) %>" name="BMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rscp.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rscp.getInt(1) %>" name="CPLUS"></td>
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rsc.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsc.getInt(1) %>" name="C"></td>
				    			</form>
				    		<%		
				    			}
				    		%>
				    		<%
				    			while(rscm.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rscm.getInt(1) %>" name="CMINUS"></td>
				    			</form>
				    		<%		
				    			}
				    		
				    		%>	
				    		<%
				    			while(rsd.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
					        		<input type="hidden" value="update" name="action">
					        			<td><input value="<%= rsd.getInt(1) %>" name="D"></td>
				    			</form>
				    		<%		
				    			}
				    		%>	
				    		<%
				    			while(rsf.next()){
				    		%>
				    			<form action="cpgMV.jsp" method="get">
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