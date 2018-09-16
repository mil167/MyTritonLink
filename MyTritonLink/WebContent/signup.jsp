<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Course Enrollment Data Entry Form</title>
</head>
<body>
	<b>Sign up for classes Data Entry Menu</b>
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
				<%
				// Create the statement
				Statement statement = conn.createStatement();
				
				// Use the statement to get a list of all students in the database
				ResultSet rs_students = statement.executeQuery("SELECT * FROM public.students ORDER BY ssn ASC");
				%>
				<form name="getstudents" method="post" action="signup.jsp">
					<select name="students" id="students">
						<option>Select a Student:</option>
						<%
							while(rs_students.next()){
						%>
								<option><%= rs_students.getInt("ssn") %></option>
						<% 
							}
						%>
					</select>
					<input type="Submit" value="Submit"></input>
				</form>
				<%
					String student = request.getParameter("students");
					if(student != null){
						PreparedStatement ps_students = conn.prepareStatement(
								"SELECT sectionid, coursecode FROM public.enroll WHERE ssn = ?");
						ps_students.setInt(1, Integer.parseInt(student));
						rs_students = ps_students.executeQuery();
						int sectionid;
						ArrayList<Integer> enrolled = new ArrayList<Integer>();
				
				%>
				<%-- This table displays the classes the student is currently enrolled in --%>
				<table>
					<th>Section ID</th>
					<th>Course Code</th>
					<th>Lecture Day</th>
					<th>Lecture Time</th>
					<th>Discussion Day</th>
					<th>Discussion Time</th>
					<th>Lab Day</th>
					<th>Lab Time</th>
					
					<%
					while(rs_students.next()){
					%>
						<tr>
							<form action="signup.jsp" method="get">
								<td><input value="<%= rs_students.getInt("sectionid") %>" name="SECTIONID"></td>
								<%
								sectionid = rs_students.getInt("sectionid");
								enrolled.add(sectionid);
								PreparedStatement ps_sid = conn.prepareStatement(
										"SELECT lecday,lectime,discday,disctime,labday,labtime FROM public.classes WHERE sectionid = ?");
								ps_sid.setInt(1,sectionid);
								ResultSet rs_sid = ps_sid.executeQuery();
								%>
								<td><input value="<%= rs_students.getString("coursecode") %>" name="COURSECODE"></td>
								<%
								while(rs_sid.next()) {
								%>
									<td><input value="<%= rs_sid.getString("lecday") %>" name="LECDAY"></td>
									<td><input value="<%= rs_sid.getString("lectime") %>" name="LECTIME"></td>
									<td><input value="<%= rs_sid.getString("discday") %>" name="DISCDAY"></td>
									<td><input value="<%= rs_sid.getString("disctime") %>" name="DISCTIME"></td>
									<td><input value="<%= rs_sid.getString("labday") %>" name="LABDAY"></td>
									<td><input value="<%= rs_sid.getString("labtime") %>" name="LABTIME"></td>									
								<% 
								}
								%>
							</form>
						</tr>
					<% 
					}
					%>
				</table>
				<%
					ResultSet rstest = null;
					String test = "";
					System.out.println(enrolled.size());
					if(enrolled.size() > 0) {
						if(enrolled.size() == 1) {
							test = "SELECT * FROM public.classes WHERE sectionid != " + enrolled.get(0).toString();
						}
						else {
							test = "SELECT * FROM public.classes WHERE sectionid != " + enrolled.get(0).toString() + " INTERSECT ";
						
							if(enrolled.size() > 1){
								for(int i = 1; i < enrolled.size(); i++) {
									String test2 = "SELECT * FROM public.classes WHERE sectionid != " + enrolled.get(i).toString();
									test = test + test2;
								}
							}
						}
						
						test = test + " ORDER BY sectionid ASC";
						PreparedStatement pstest = conn.prepareStatement(test);
						rstest = pstest.executeQuery();
						
					%>
						<%-- THIS TABLE SHOWS THE CLASSES THE STUDENT IS NOT ENROLLED IN --%>
						<table>
							<th>Section ID</th>
							<th>Course Code</th>
							<th>Lecture Day</th>
							<th>Lecture Time</th>
							<th>Discussion Day</th>
							<th>Discussion Time</th>
							<th>Lab Day</th>
							<th>Lab Time</th>
							<%
							while(rstest.next()) {
							%>
								<tr>
									<form action="signup.jsp" method="get">
										<td><input value="<%= rstest.getString("sectionid") %>" name="SECTIONIDNE"></td>
										<td><input value="<%= rstest.getString("coursecode") %>" name="COURSECODENE"></td>
										<td><input value="<%= rstest.getString("lecday") %>" name="LECDAYNE"></td>
										<td><input value="<%= rstest.getString("lectime") %>" name="LECTIMENE"></td>
										<td><input value="<%= rstest.getString("discday") %>" name="DISCDAYNE"></td>
										<td><input value="<%= rstest.getString("disctime") %>" name="DISCTIMENE"></td>
										<td><input value="<%= rstest.getString("labday") %>" name="LABDAYNE"></td>
										<td><input value="<%= rstest.getString("labtime") %>" name="LABTIMENE"></td>
									</form>
								</tr>
						</table>
					<% 
					}
				%>
				<% } %>
				<%-- THIS RIGHT HERE ENDS THE IF STATEMENT TO CHECK IF THE STUDENT FIELD IS NULL DO NOT REMOVE --%>
				<% } %>
				<%-- CLOSE CONNECTION CODE --%>
				<%
				rs_students.close();
				statement.close();
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