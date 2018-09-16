<!DOCTYPE html>
<html>
<head>
<style>
table {
    width: 100%;
    border-collapse: collapse;
}

table, td, th {
    border: 1px solid black;
    padding: 5px;
}

th {text-align: left;}
</style>
</head>
<body>

<?php

$q = intval($_GET['q']);

$con = pg_connect("host=localhost port=5432 dbname=MyTritonLinkDB user=postgres password=cse132b");
if (!$con) {
    print "Not connected";
}
else {
	print "Connected";
}

$sql="SELECT firstname FROM public.students WHERE ssn = '".$q."'";
$result = pg_query($con,$sql);

echo "<table>
<tr>
<th>SSN</th>
<th>First name</th>

</tr>";
while($row = pg_fetch_array($result)) {
    echo "<tr>";

    echo "<td>" . $row['firstname'] . "</td>";

    echo "</tr>";
}
echo "</table>";
pg_close($con);
?>

</body>
</html> 