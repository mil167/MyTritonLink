<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Student Data Entry Form</title>
</head>
<body>
	<b>Students Data Entry Menu</b>
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
				String advisor = "";
				if(action != null && action.equals("insert")){
					conn.setAutoCommit(false);
				int gradflag = 0;
				int phdflag = 0;
				
				// Create the prepared statement and use it to 
				// INSERT the student attributes INTO the Student table
				PreparedStatement pstmt = conn.prepareStatement(
						("INSERT INTO public.students VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"));
				
				pstmt.setInt(1,Integer.parseInt(request.getParameter("SSN")));
				pstmt.setString(2, request.getParameter("ID"));
				pstmt.setString(3, request.getParameter("LASTNAME"));
				pstmt.setString(4, request.getParameter("FIRSTNAME"));
				pstmt.setString(5, request.getParameter("COLLEGE"));
				pstmt.setString(6, request.getParameter("MIDDLENAME"));
				pstmt.setString(7, request.getParameter("STARTDATE"));
				pstmt.setString(8, request.getParameter("ENDDATE"));
				pstmt.setString(9, request.getParameter("MAJOR"));
				pstmt.setString(10, request.getParameter("MINOR"));
				pstmt.setString(11, request.getParameter("DEPARTMENT"));
				pstmt.setString(12, request.getParameter("RESIDENT"));
				pstmt.setString(13, request.getParameter("GRADCLASS"));
				pstmt.setString(14, request.getParameter("PHDCLASS"));
				pstmt.setString(15, request.getParameter("ADVISOR"));
				pstmt.setDouble(16, Double.parseDouble(request.getParameter("GPA")));
				pstmt.executeUpdate();
				
				// If all of the following fields are null: COLLEGE, MAJOR, MINOR, then this is a graduate student
				if(request.getParameter("COLLEGE") == "" && request.getParameter("MAJOR") == "" && request.getParameter("MINOR") == "") {
					PreparedStatement pstmt2 = conn.prepareStatement(
							"INSERT INTO public.graduate VALUES(?,?,?,?,?,?,?,?)");
					pstmt2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					pstmt2.setString(2, request.getParameter("ID"));
					pstmt2.setString(3, request.getParameter("LASTNAME"));
					pstmt2.setString(4, request.getParameter("FIRSTNAME"));
					pstmt2.setString(5, request.getParameter("MIDDLENAME"));
					pstmt2.setString(6, request.getParameter("DEPARTMENT"));
					pstmt2.setString(7, request.getParameter("GRADCLASS"));
					pstmt2.setString(8, request.getParameter("PHDCLASS"));
					if(!request.getParameter("GRADCLASS").equals("MS") && !request.getParameter("GRADCLASS").equals("PhD") && !request.getParameter("GRADCLASS").equals("5Year")) {
						System.out.println("Graduate students can only be classified as MS, PhD, or 5Year students!");
						gradflag = 1;
					}
					if(gradflag != 1){
						pstmt2.executeUpdate();
					}
					
				}
				
				advisor = request.getParameter("ADVISOR");
				// If all of the following fields are null: DEPARTMENT, GRADCLASS, PHDCLASS, then this is an undergraduate 
				if(request.getParameter("DEPARTMENT") == "" && request.getParameter("GRADCLASS") == "" && request.getParameter("PHDCLASS") == "") {
					
					PreparedStatement pstmt3 = conn.prepareStatement(
							"INSERT INTO public.undergraduate VALUES(?,?,?,?,?,?,?,?)");
					pstmt3.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					pstmt3.setString(2, request.getParameter("ID"));
					pstmt3.setString(3, request.getParameter("LASTNAME"));
					pstmt3.setString(4, request.getParameter("FIRSTNAME"));
					pstmt3.setString(5, request.getParameter("MIDDLENAME"));
					pstmt3.setString(6, request.getParameter("MAJOR"));
					pstmt3.setString(7, request.getParameter("MINOR"));
					pstmt3.setString(8, request.getParameter("COLLEGE"));
					
					if(!advisor.equals("")) {
						System.out.println("Only PhD students can have advisors!");
					}
					else {
						pstmt3.executeUpdate();
					}				
				}
				phdflag = 0;
				// If the student is a PhD student populate the PhD table
				if(request.getParameter("PHDCLASS") != "") {
					PreparedStatement pstmt4 = conn.prepareStatement(
							"INSERT INTO public.phd VALUES(?,?,?,?,?,?,?)");
					pstmt4.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					pstmt4.setString(2, request.getParameter("ID"));
					pstmt4.setString(3, request.getParameter("LASTNAME"));
					pstmt4.setString(4, request.getParameter("FIRSTNAME"));
					pstmt4.setString(5, request.getParameter("MIDDLENAME"));
					pstmt4.setString(6, request.getParameter("PHDCLASS"));
					pstmt4.setString(7, request.getParameter("ADVISOR"));
					advisor = request.getParameter("ADVISOR");
					String query = "SELECT COUNT(1) FROM public.faculty WHERE facultyname = " + "'" + advisor + "'";
					ResultSet rs2 = null;
					PreparedStatement advisorcheck = conn.prepareStatement(query);
					rs2 = advisorcheck.executeQuery();
					int flag = 0;
					while(rs2.next()) {
						flag = rs2.getInt(1);
					}
					
					if(flag == 0) {
						System.out.println("Faculty member not found!");
					}

					if(!request.getParameter("PHDCLASS").equals("PhD candidate") && !request.getParameter("PHDCLASS").equals("Pre-candidacy")){
						System.out.println("PhD students can only be classified as PhD candidates or Pre-candidacy!");
						phdflag = 1;
					}
					if(phdflag != 1 && flag != 0){
						pstmt4.executeUpdate();
					}
				}
				
				conn.commit();
				conn.setAutoCommit(true);
				}
				%>
				
				<%-- UPDATE CODE --%>
				<%
				// Check if an update is requested
				if(action != null && action.equals("update")) {	
					conn.setAutoCommit(false);
					int gradflag = 0;
					int phdflag = 0;
					// Create the prepared statement and use it to 
					// UPDATE the student attributes in the Student table.
					PreparedStatement pstatement = conn.prepareStatement(
							"UPDATE public.students SET id = ?, lastname = ?, firstname = ?, " +
							"college = ?, middlename = ?, startdate = ?, enddate = ?, major = ?," +
							"minor = ?, department = ?, resident = ?, gradclass = ?, phdclass = ?, " +
							"advisor = ?, gpa = ? WHERE ssn = ?");
					
					pstatement.setString(1, request.getParameter("ID"));
					pstatement.setString(2, request.getParameter("LASTNAME"));
					pstatement.setString(3, request.getParameter("FIRSTNAME"));
					pstatement.setString(4, request.getParameter("COLLEGE"));
					pstatement.setString(5, request.getParameter("MIDDLENAME"));
					pstatement.setString(6, request.getParameter("STARTDATE"));
					pstatement.setString(7, request.getParameter("ENDDATE"));
					pstatement.setString(8, request.getParameter("MAJOR"));
					pstatement.setString(9, request.getParameter("MINOR"));
					pstatement.setString(10, request.getParameter("DEPARTMENT"));
					pstatement.setString(11, request.getParameter("RESIDENT"));
					pstatement.setString(12, request.getParameter("GRADCLASS"));
					pstatement.setString(13, request.getParameter("PHDCLASS"));
					pstatement.setString(14, request.getParameter("ADVISOR"));
					pstatement.setDouble(15, Double.parseDouble(request.getParameter("GPA")));
					pstatement.setInt(16, Integer.parseInt(request.getParameter("SSN")));
					pstatement.executeUpdate();
					
					// If all of the following fields are null: COLLEGE, MAJOR, MINOR, then this is a graduate student
					if(request.getParameter("COLLEGE") == "" && request.getParameter("MAJOR") == "" && request.getParameter("MINOR") == "") {
						PreparedStatement pstmt2 = conn.prepareStatement(
								"UPDATE public.graduate SET id = ?, lastname = ?, firstname = ?, " +
								"middlename = ?, department = ?, gradclass = ?, phdclass = ? WHERE ssn = ?");
						pstmt2.setString(1, request.getParameter("ID"));
						pstmt2.setString(2, request.getParameter("LASTNAME"));
						pstmt2.setString(3, request.getParameter("FIRSTNAME"));
						pstmt2.setString(4, request.getParameter("MIDDLENAME"));
						pstmt2.setString(5, request.getParameter("DEPARTMENT"));
						pstmt2.setString(6, request.getParameter("GRADCLASS"));
						pstmt2.setString(7, request.getParameter("PHDCLASS"));
						pstmt2.setInt(8, Integer.parseInt(request.getParameter("SSN")));
						pstmt2.executeUpdate();
						
						if(!request.getParameter("GRADCLASS").equals("MS") && !request.getParameter("GRADCLASS").equals("PhD") && !request.getParameter("GRADCLASS").equals("5Year")) {
							System.out.println("Graduate students can only be classified as MS, PhD, or 5Year students!");
							gradflag = 1;
						}
						if(!request.getParameter("PHDCLASS").equals("PhD candidate") && !request.getParameter("PHDCLASS").equals("Pre-candidacy")){
							System.out.println("PhD students can only be classified as PhD candidates or Pre-candidacy!");
							phdflag = 1;
						}
						if(gradflag != 1 || phdflag != 1){
							pstmt2.executeUpdate();
						}
					}
					phdflag = 0;
					advisor = request.getParameter("ADVISOR");
					// If all of the following fields are null: DEPARTMENT, GRADCLASS, PHDCLASS, then this is an undergraduate 
					if(request.getParameter("DEPARTMENT") == "" && request.getParameter("GRADCLASS") == "" && request.getParameter("PHDCLASS") == "") {
						
						PreparedStatement pstmt3 = conn.prepareStatement(
								"UPDATE public.undergraduate SET id = ?, lastname = ?, firstname = ?, " +
										"middlename = ?, major = ?, minor = ?, college = ? WHERE ssn = ?");
						pstmt3.setString(1, request.getParameter("ID"));
						pstmt3.setString(2, request.getParameter("LASTNAME"));
						pstmt3.setString(3, request.getParameter("FIRSTNAME"));
						pstmt3.setString(4, request.getParameter("MIDDLENAME"));
						pstmt3.setString(5, request.getParameter("MAJOR"));
						pstmt3.setString(6, request.getParameter("MINOR"));
						pstmt3.setString(7, request.getParameter("COLLEGE"));
						pstmt3.setInt(8, Integer.parseInt(request.getParameter("SSN")));
						
						if(!advisor.equals("")) {
							System.out.println("Only PhD students can have advisors!");
						}
						else {
							pstmt3.executeUpdate();
						}				
					}
					
					// If the student is a PhD student update the PhD table
					if(request.getParameter("PHDCLASS") != "") {
						PreparedStatement pstmt4 = conn.prepareStatement(
								"UPDATE public.phd SET id = ?, lastname = ?, firstname = ?, " +
										"middlename = ?, phdclass = ?, advisor = ? WHERE ssn = ?");
						pstmt4.setString(1, request.getParameter("ID"));
						pstmt4.setString(2, request.getParameter("LASTNAME"));
						pstmt4.setString(3, request.getParameter("FIRSTNAME"));
						pstmt4.setString(4, request.getParameter("MIDDLENAME"));
						pstmt4.setString(5, request.getParameter("PHDCLASS"));
						pstmt4.setString(6, request.getParameter("ADVISOR"));
						pstmt4.setInt(7, Integer.parseInt(request.getParameter("SSN")));
						advisor = request.getParameter("ADVISOR");
						String query = "SELECT COUNT(1) FROM public.faculty WHERE facultyname = " + "'" + advisor + "'";
						ResultSet rs2 = null;
						PreparedStatement advisorcheck = conn.prepareStatement(query);
						rs2 = advisorcheck.executeQuery();
						int flag = 0;
						while(rs2.next()) {
							flag = rs2.getInt(1);
						}
						
						if(flag == 0) {
							System.out.println("Faculty member not found!");
						}
						if(!request.getParameter("PHDCLASS").equals("PhD candidate") && !request.getParameter("PHDCLASS").equals("Pre-candidacy")){
							System.out.println("PhD students can only be classified as PhD candidates or Pre-candidacy!");
							phdflag = 1;
						}
						if(phdflag != 1 && flag != 0){
							pstmt4.executeUpdate();
						}
					}
					
					//pstatement.executeUpdate();
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
					// DELETE the student in the Student table
					PreparedStatement ps = conn.prepareStatement(
							"DELETE FROM public.students WHERE ssn = ?");
					ps.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					//ps.executeUpdate();
					String query = "SELECT COUNT(1) FROM public.undergraduate WHERE ssn = " + "'" + Integer.parseInt(request.getParameter("SSN")) + "'";
					ResultSet rs2 = null;
					PreparedStatement studentcheck = conn.prepareStatement(query);
					rs2 = studentcheck.executeQuery();
					int flag = 0;
					while(rs2.next()) {
						flag = rs2.getInt(1);
					}
					if(flag == 0) {
						System.out.println("");
					}
					else {
						PreparedStatement ps1 = conn.prepareStatement(
								"DELETE FROM public.undergraduate WHERE ssn = ?");
						ps1.setInt(1, Integer.parseInt(request.getParameter("SSN")));
						ps1.executeUpdate();
						
					}
					String query2 = "SELECT COUNT(1) FROM public.graduate WHERE ssn = " + "'" + Integer.parseInt(request.getParameter("SSN")) + "'";
					ResultSet rs3 = null;
					PreparedStatement gradcheck = conn.prepareStatement(query2);
					rs3 = gradcheck.executeQuery();
					flag = 0;
					while(rs3.next()) {
						flag = rs3.getInt(1);
					}
					if(flag == 0) {
						System.out.println("");
					}
					else {
						PreparedStatement ps2 = conn.prepareStatement(
								"DELETE FROM public.graduate WHERE ssn = ?");
						ps2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
						ps2.executeUpdate();
					}
					String query3 = "SELECT COUNT(1) FROM public.phd WHERE ssn = " + "'" + Integer.parseInt(request.getParameter("SSN")) + "'";
					ResultSet rs4 = null;
					PreparedStatement phdcheck = conn.prepareStatement(query3);
					rs4 = phdcheck.executeQuery();
					flag = 0;
					while(rs4.next()) {
						flag = rs4.getInt(1);
					}
					if(flag == 0) {
						System.out.println("");
					}
					else {
						PreparedStatement ps3 = conn.prepareStatement(
								"DELETE FROM public.phd WHERE ssn = ?");
						ps3.setInt(1, Integer.parseInt(request.getParameter("SSN")));
						ps3.executeUpdate();
					}
					ps.executeUpdate();
					conn.setAutoCommit(false);
					conn.setAutoCommit(true);
				}
				%>
				
				<%-- STATEMENT CODE --%>
				<%
				// Create the statement 
				Statement statement = conn.createStatement();
				
				// Use the statement to SELECT the student attributes FROM the Student table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.students");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>SSN</th>
						<th>ID</th>
						<th>Last</th>
						<th>First</th>
						<th>Middle</th>
						<th>College</th>
						<th>Start Date</th>
						<th>End Date</th>
						<th>Major</th>
						<th>Minor</th>
						<th>Department</th>
						<th>Resident</th>
						<th>Graduate Classification</th>
						<th>PhD Classification</th>
						<th>PhD Advisor</th>
						<th>GPA</th>
					</tr>
					<tr>
						<form action="students.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SSN" size="50"></th>
							<th><input value="" name="ID" size="50"></th>
							<th><input value="" name="LASTNAME" size="50"></th>
							<th><input value="" name="FIRSTNAME" size="50"></th>
							<th><input value="" name="MIDDLENAME" size="50"></th>
							<th><input value="" name="COLLEGE" size="50"></th>
							<th><input value="" name="STARTDATE" size="50"></th>
							<th><input value="" name="ENDDATE" size="50"></th>
							<th><input value="" name="MAJOR" size="50"></th>
							<th><input value="" name="MINOR" size="50"></th>
							<th><input value="" name="DEPARTMENT" size="50"></th>
							<th><input value="" name="RESIDENT" size="50"></th>
							<th><input value="" name="GRADCLASS" size="50"></th>
							<th><input value="" name="PHDCLASS" size="50"></th>
							<th><input value="" name="ADVISOR" size="50"></th>
							<th><input value="" name="GPA" size="50"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="students.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					    	<%-- Get the SSN, which is a number --%>
					        <td><input value="<%= rs.getInt("SSN") %>" name="SSN"></td>
					    	
					    	<%-- Get the ID --%>
					    	<td><input value="<%= rs.getString("ID") %>" name="ID"></td>
					    	
					    	<%-- Get the LASTNAME --%>
					    	<td><input value="<%= rs.getString("LASTNAME") %>" name="LASTNAME"></td>
					    	
					    	<%-- Get the FIRSTNAME --%>
					    	<td><input value="<%= rs.getString("FIRSTNAME") %>" name="FIRSTNAME"></td>
					    	
					    	<%-- Get the MIDDLENAME --%>
					    	<td><input value="<%= rs.getString("MIDDLENAME") %>" name="MIDDLENAME"></td>
					    	
					    	<%-- Get the COLLEGE --%>
					    	<td><input value="<%= rs.getString("COLLEGE") %>" name="COLLEGE"></td>
					    	
					    	<%-- Get the STARTDATE --%>
					    	<td><input value="<%= rs.getString("STARTDATE") %>" name="STARTDATE"></td>
					    	
					    	<%-- Get the ENDDATE --%>
					    	<td><input value="<%= rs.getString("ENDDATE") %>" name="ENDDATE"></td>
					    	
					    	<%-- Get the MAJOR --%>
					    	<td><input value="<%= rs.getString("MAJOR") %>" name="MAJOR"></td>
					    	
					    	<%-- Get the MINOR --%>
					    	<td><input value="<%= rs.getString("MINOR") %>" name="MINOR"></td>
					    	
					    	<%-- Get the DEPARTMENT --%>
					    	<td><input value="<%= rs.getString("DEPARTMENT") %>" name="DEPARTMENT"></td>
					    	
					    	<%-- Get the RESIDENT --%>
					    	<td><input value="<%= rs.getString("RESIDENT") %>" name="RESIDENT"></td>
					    	
					    	<%-- Get the GRADCLASS --%>
					    	<td><input value="<%= rs.getString("GRADCLASS") %>" name="GRADCLASS"></td>
					    	
					    	<%-- Get the PHDCLASS --%>
					    	<td><input value="<%= rs.getString("PHDCLASS") %>" name="PHDCLASS"></td>
					    	
					    	<%-- Get the ADVISOR --%>
					    	<td><input value="<%= rs.getString("ADVISOR") %>" name="ADVISOR"></td>
					    	
					    	<%-- Get the GPA --%>
					    	<td><input value="<%= rs.getDouble("GPA") %>" name="GPA"></td>
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	
				    	<form action="students.jsp" method="get">
				    		<input type="hidden" value="delete" name="action">
				    		<input type="hidden" value="<%= rs.getInt("SSN") %>" name="SSN">
				    		<td><input type="submit" value="Delete"></td>
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
				System.out.println(" ");
			}
				%>
			</td>
		</tr>		
	</table>
</body>
</html>