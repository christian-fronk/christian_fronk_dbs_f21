<?php
ini_set('display_errors', 1); 
ini_set('display_startup_errors', 1); #Set to display all warnings from php
error_reporting(E_ALL);
$dbhost = 'localhost'; 
$dbuser = 'christiansmac'; #Connection variables 
$dbpass = 'PASSWORD';
$conn = new mysqli($dbhost, $dbuser, $dbpass); #Create connection 

if ($conn->connect_errno) {
    echo "Error: Failed to make a MySQL connection,
    here is why: ". "<br>";
    echo "Errno: " . $conn->connect_errno . "\n";
    echo "Error: " . $conn->connect_error . "\n";
    exit; // Quit this PHP script if the connection fails.
    } else {
    echo "Connected Successfully!" . "<br>"; echo "YAY!" . "<br>";
    }
    $dblist = "SHOW databases;"; #Create and send show databases query
    $result = $conn->query($dblist);
    while ($dbname = $result->fetch_array()) { echo $dbname['Database'] . "<br>";
    }
    $conn->close(); #Close connection after printing each database displayed on each row of array
?>
<h2>Check back soon!</h2>

<form action = "details.php" method="post">
 <p>Database name: <input type="text" name="name" /></p> 
 <p><input type="submit" /></p>
</form>