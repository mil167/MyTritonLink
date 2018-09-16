<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Thesis Committee Entry Form</title>
</head>
<body>
	<b>Thesis Committee Data Entry Menu</b>
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
				if(action != null && action.equals("insert")){
					conn.setAutoCommit(false);
				
				// Create the prepared statement and use it to 
				// INSERT the thesis committeee attributes INTO the Thesis Committee table
				PreparedStatement pstmt = conn.prepareStatement(
						("INSERT INTO public.thesiscommittee VALUES(?,?,?)"));
				
				pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN")));
				pstmt.setString(2, request.getParameter("PROFESSORS"));
				pstmt.setString(3, request.getParameter("OTHERPROF"));
				
				
				PreparedStatement check = conn.prepareStatement(
						"SELECT COUNT(1) FROM public.students WHERE ssn = ?");
				check.setInt(1,Integer.parseInt(request.getParameter("SSN")));
				int ssn_copy = Integer.parseInt(request.getParameter("SSN"));
				ResultSet check_rs = null;
				check_rs = check.executeQuery();
				int flag = 0;
				if(check_rs.next()) {
					flag = check_rs.getInt(1);
				}
				// Student doesn't exist in the Student table
				if(flag == 0) {
					System.out.println("Student does not exist in Student table!");
				}
				else {
					String stud_dept = "";
					String prof_department = "";
					PreparedStatement check2 = conn.prepareStatement(
							"SELECT phdclass FROM public.students where ssn = ?");
					check2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					ResultSet check2_rs = null;
					check2_rs = check2.executeQuery();
					String phdclass = "";
					if(check2_rs.next()){
						phdclass = check2_rs.getString(1);
					}
					// Parse the list of professors
					String [] professors;
					professors = request.getParameter("PROFESSORS").split(",");
					int notenough = 0;
					flag = 0;
					if(professors.length < 3) {
						notenough = 1;
					}
					// Check the PROFESSORS field to see if all of them belong to the same department
					for(int i = 0; i < professors.length; i++) {
						String query = "SELECT department FROM public.faculty WHERE facultyname = " + "'" + professors[i] + "'";
						//PreparedStatement check3 = conn.prepareStatement(
						//		"SELECT * FROM public.faculty WHERE facultyname = ?");
						PreparedStatement check3 = conn.prepareStatement(query);
						//check3.setString(1, request.getParameter("FACULTYNAME"));
						ResultSet check3_rs = null;
						check3_rs = check3.executeQuery();
						while(check3_rs.next()) {
							prof_department = check3_rs.getString("department");
						}
						String studentquery = "SELECT department FROM public.students WHERE ssn = " + "'" + ssn_copy + "'";
						//PreparedStatement check4 = conn.prepareStatement(
						//		"SELECT department FROM public.students where ssn = ?");
						PreparedStatement check4 = conn.prepareStatement(studentquery);
						//check4.setInt(1, Integer.parseInt(request.getParameter("SSN")));
						ResultSet check4_rs = null;
						check4_rs = check4.executeQuery();
						if(check4_rs.next()){
							stud_dept = check4_rs.getString(1);
						}
						if(!stud_dept.equals(prof_department)) {
							flag = 1;
						}
					}
					String [] other_professors;
					other_professors = request.getParameter("OTHERPROF").split(",");
					String checkphd = "SELECT phdclass FROM public.students WHERE ssn = "+ "'" + ssn_copy + "'";
					PreparedStatement check5 = conn.prepareStatement(checkphd);
					ResultSet check5_rs = null;
					int otherprof_flag = 0;
					int other_notenough = 0;
					if(phdclass.equals("PhD candidate")) {
						if(other_professors.length < 1) {
							other_notenough = 1;
						}
						for(int j = 0; j < other_professors.length; j++) {
							String query = "SELECT department FROM public.faculty WHERE facultyname = " + "'" + other_professors[j] + "'";
							//PreparedStatement check3 = conn.prepareStatement(
							//		"SELECT * FROM public.faculty WHERE facultyname = ?");
							PreparedStatement check3 = conn.prepareStatement(query);
							//check3.setString(1, request.getParameter("FACULTYNAME"));
							ResultSet check3_rs = null;
							check3_rs = check3.executeQuery();
							while(check3_rs.next()) {
								prof_department = check3_rs.getString("department");
							}
							String studentquery = "SELECT department FROM public.students WHERE ssn = " + "'" + ssn_copy + "'";
							//PreparedStatement check4 = conn.prepareStatement(
							//		"SELECT department FROM public.students where ssn = ?");
							PreparedStatement check4 = conn.prepareStatement(studentquery);
							//check4.setInt(1, Integer.parseInt(request.getParameter("SSN")));
							ResultSet check4_rs = null;
							check4_rs = check4.executeQuery();
							if(check4_rs.next()){
								stud_dept = check4_rs.getString(1);
							}
							if(stud_dept.equals(prof_department)) {
								otherprof_flag = 1;
							}
						}
					}
					
					if(!phdclass.equals("PhD candidate")){
						System.out.println("Only PhD candidates can create a thesis committee");
					}
					if(notenough == 1 || flag == 1) {
						System.out.println("At least 3 professors must be in the same department!");
					}
					else if(other_notenough == 1 || otherprof_flag == 1) {
						System.out.println("PhD candidates must include a professor from another department!");
					}
					else {
						pstmt.executeUpdate();
					}
					conn.commit();
					conn.setAutoCommit(true);
				}
				}
				%>
				
				<%-- UPDATE CODE --%>
				<%
				// Check if an update is requested
				if(action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to 
					// UPDATE the thesis committee attributes in the Thesis Committee table.
					PreparedStatement pstatement = conn.prepareStatement(
							"UPDATE public.thesiscommittee SET professors = ?, otherprof = ? WHERE ssn = ?");
					
					pstatement.setString(1,request.getParameter("PROFESSORS"));
					pstatement.setString(2, request.getParameter("OTHERPROF"));
					pstatement.setInt(3,Integer.parseInt(request.getParameter("SSN")));
					
					PreparedStatement check = conn.prepareStatement(
							"SELECT COUNT(1) FROM public.students WHERE ssn = ?");
					check.setInt(1,Integer.parseInt(request.getParameter("SSN")));
					int ssn_copy = Integer.parseInt(request.getParameter("SSN"));
					ResultSet check_rs = null;
					check_rs = check.executeQuery();
					int flag = 0;
					if(check_rs.next()) {
						flag = check_rs.getInt(1);
					}
					// Student doesn't exist in the Student table
					if(flag == 0) {
						System.out.println("Student does not exist in Student table!");
					}
					else {
						String stud_dept = "";
						String prof_department = "";
						PreparedStatement check2 = conn.prepareStatement(
								"SELECT phdclass FROM public.students where ssn = ?");
						check2.setInt(1, Integer.parseInt(request.getParameter("SSN")));
						ResultSet check2_rs = null;
						check2_rs = check2.executeQuery();
						String phdclass = "";
						if(check2_rs.next()){
							phdclass = check2_rs.getString(1);
						}
						System.out.println("hello" + phdclass);
						// Parse the list of professors
						String [] professors;
						professors = request.getParameter("PROFESSORS").split(",");
						int notenough = 0;
						flag = 0;
						if(professors.length < 3) {
							notenough = 1;
						}
						// Check the PROFESSORS field to see if all of them belong to the same department
						for(int i = 0; i < professors.length; i++) {
							String query = "SELECT department FROM public.faculty WHERE facultyname = " + "'" + professors[i] + "'";
							//PreparedStatement check3 = conn.prepareStatement(
							//		"SELECT * FROM public.faculty WHERE facultyname = ?");
							PreparedStatement check3 = conn.prepareStatement(query);
							//check3.setString(1, request.getParameter("FACULTYNAME"));
							ResultSet check3_rs = null;
							check3_rs = check3.executeQuery();
							while(check3_rs.next()) {
								prof_department = check3_rs.getString("department");
							}
							String studentquery = "SELECT department FROM public.students WHERE ssn = " + "'" + ssn_copy + "'";
							//PreparedStatement check4 = conn.prepareStatement(
							//		"SELECT department FROM public.students where ssn = ?");
							PreparedStatement check4 = conn.prepareStatement(studentquery);
							//check4.setInt(1, Integer.parseInt(request.getParameter("SSN")));
							ResultSet check4_rs = null;
							check4_rs = check4.executeQuery();
							if(check4_rs.next()){
								stud_dept = check4_rs.getString(1);
							}
							if(!stud_dept.equals(prof_department)) {
								flag = 1;
							}
						}
						String [] other_professors;
						other_professors = request.getParameter("OTHERPROF").split(",");
						String checkphd = "SELECT phdclass FROM public.students WHERE ssn = "+ "'" + ssn_copy + "'";
						PreparedStatement check5 = conn.prepareStatement(checkphd);
						ResultSet check5_rs = null;
						int otherprof_flag = 0;
						int other_notenough = 0;
						if(phdclass.equals("PhD candidate")) {
							if(other_professors.length < 1) {
								other_notenough = 1;
							}
							for(int j = 0; j < other_professors.length; j++) {
								String query = "SELECT department FROM public.faculty WHERE facultyname = " + "'" + other_professors[j] + "'";
								//PreparedStatement check3 = conn.prepareStatement(
								//		"SELECT * FROM public.faculty WHERE facultyname = ?");
								PreparedStatement check3 = conn.prepareStatement(query);
								//check3.setString(1, request.getParameter("FACULTYNAME"));
								ResultSet check3_rs = null;
								check3_rs = check3.executeQuery();
								while(check3_rs.next()) {
									prof_department = check3_rs.getString("department");
								}
								String studentquery = "SELECT department FROM public.students WHERE ssn = " + "'" + ssn_copy + "'";
								//PreparedStatement check4 = conn.prepareStatement(
								//		"SELECT department FROM public.students where ssn = ?");
								PreparedStatement check4 = conn.prepareStatement(studentquery);
								//check4.setInt(1, Integer.parseInt(request.getParameter("SSN")));
								ResultSet check4_rs = null;
								check4_rs = check4.executeQuery();
								if(check4_rs.next()){
									stud_dept = check4_rs.getString(1);
								}
								if(stud_dept.equals(prof_department)) {
									otherprof_flag = 1;
								}
							}
						}
						if(!phdclass.equals("PhD candidate")){
							System.out.println("Only PhD candidates can create a thesis committee");
						}
						if(notenough == 1 || flag == 1) {
							System.out.println("At least 3 professors must be in the same department!");
						}
						else if(other_notenough == 1 || otherprof_flag == 1) {
							System.out.println("PhD candidates must include a professor from another department!");
						}
						else {
							pstatement.executeUpdate();
						}
						conn.commit();
						conn.setAutoCommit(true);
					}
					
					//pstatement.executeUpdate();
					//conn.setAutoCommit(false);
					//conn.setAutoCommit(true);
				}
				%>
				
				<%-- DELETE CODE --%>
				<%
				// Check if a delete is requested
				if(action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					
					// Create the prepared statement and use it to
					// DELETE the thesis committee in the Thesis Committee table
					PreparedStatement ps = conn.prepareStatement(
							"DELETE FROM public.thesiscommittee WHERE ssn = ?");
					ps.setInt(1, Integer.parseInt(request.getParameter("SSN")));
					ps.executeUpdate();
					conn.setAutoCommit(false);
					conn.setAutoCommit(true);
				}
				%>
				<%-- STATEMENT CODE --%>
				<%
				// Create the statement 
				Statement statement = conn.createStatement();
				
				// Use the statement to SELECT the thesis committee attributes FROM the Thesis Committee table
				ResultSet rs = statement.executeQuery("SELECT * FROM public.thesiscommittee");
				%>
				<%-- PRESENTATION CODE --%>
				<table>
					<tr>
						<th>SSN</th>
						<th>Department Professors</th>
						<th>Professor From Another Department(PhD candidates only)</th>
					</tr>
					<tr>
						<form action="thesiscommittee.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SSN" size="50"></th>
							<th><input value="" name="PROFESSORS" size="50"></th>
							<th><input value="" name="OTHERPROF" size="50"></th>

							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%-- ITERATION CODE --%>
					
					<%
					// Iterate over the ResultSet
					while(rs.next()) {
				    %>
				    
				    <tr>
				    	<form action="thesiscommittee.jsp" method="get">
					        <input type="hidden" value="update" name="action">
					        <%-- Get the SSN --%>
					        <td><input value="<%= rs.getInt("SSN") %>" name="SSN"></td>
					    	<%-- Get the PROFESSORS --%>
					    	<td><input value="<%= rs.getString("PROFESSORS") %>" name="PROFESSORS"></td>
					    	<%-- Get the OTHERPROF --%>
					    	<td><input value="<%= rs.getString("OTHERPROF") %>" name="OTHERPROF"></td>
					    	<td><input type="submit" value="Update"></td>
				    	</form>
				    	<form action="thesiscommittee.jsp" method="get">
				    		<input type="hidden" value="delete" name="action">
				    		<input type="hidden" value="<%= rs.getInt("SSN") %>" name="SSN">
				    		<td><input type="submit" value="Delete"></td>
				    	</form>
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