
<?php
$dbhost = 'localhost'; 
$dbuser = 'christiansmac'; #Setting up connection variables
$dbpass = 'PASSWORD';
$conn = new mysqli($dbhost, $dbuser, $dbpass); #Create connection 

$gettables = "SHOW tables FROM ".htmlspecialchars($_POST['name']).";"; #Creating the get tables query
$alltables = $conn->query($gettables); #Running query

while($table = $alltables->fetch_array()) { // go through each row that was returned in $result
    echo($table[0] . "<br>");    // print the table that was returned on that row.
}
$conn->close(); #Close connection
?>