<!DOCTYPE html>
<html>
<?php
// Starting session
session_start();
?>

<?php
if(isset($_POST["togglelight"])) {
   if(!isset($_COOKIE["mode"])){
        $cookie_name = "mode";
        $cookie_value = "0";
        setcookie($cookie_name, $cookie_value,"/");
   }
   else{
        if($_COOKIE["mode"]=="1"){
            $cookie_value = "0";
            $cookie_name = "mode";
            setcookie($cookie_name, $cookie_value,"/");
            //echo "<p>Set to Dark</p>";
        }
        elseif($_COOKIE["mode"] =="0"){
            $cookie_value = "1";
            $cookie_name = "mode";
            setcookie($cookie_name, $cookie_value,"/");
            //echo "<p>Set to Light</p>";
        }
        
   }
   header("Refresh:0");
   
}
?>

<?php
    if($_COOKIE["mode"] == "1"){
        $_SESSION["css"] = "basic.css";
        //echo "<p>Basic css selected</p>";
    }
    elseif($_COOKIE["mode"] == "0"){
        $_SESSION["css"] = "darkmode.css";
        //echo "<p>Dark css selected</p>";
    }
    else{
        //echo "<p>None selected</p>";
    }
?>


<head>
  <link rel="stylesheet" href=<?php echo $_SESSION["css"] ?>>
</head>
<body>
    <h1>Delete Instruments</h1>
    <p></p>
<?php
if(isset($_POST["logout"])) {
    session_destroy();
    header("Refresh:0");
}


if(isset($_POST["submituser"])) {
    $_SESSION["delete_counts"] = 0;  
    $_SESSION["user_name"] = htmlspecialchars($_POST['usernamebox']);
    header("Refresh:0");
} if((!empty($_SESSION['user_name']))){
    echo "<p> Welcome ".$_SESSION["user_name"]."</p>";
    echo "<form action='manageinstrumentsfinal.php' method=POST>
    <input type='submit' name='logout' value='Logout' method=POST/>
    </form>";
}
else{
    echo "<p>Remember my session:</p>";
    echo "<form action='manageinstrumentsfinal.php' method=POST>
    <input type='textbox' name='usernamebox' value='' method=POST>
    <input type='submit' name='submituser' value='Remember me' method=POST/>
    </form>";
}

//if(empty($_SESSION["user_name"])){
//    echo "<p>Remember my session:</p>";
//}
//else{
//    echo "<p></p>";
//}
    


?>
    
<?php 
    
    $host = "localhost";
    $user = "christiansmac";
    $pass = "dweedwee";
    $dbse = "instrument_rentals";

    if (!$conn = new mysqli($host, $user, $pass, $dbse)){
        echo "Error: Failed to make a MySQL connection: " . "<br>";
        echo "Errno: $conn->connect_errno; i.e. $conn->connect_error \n"; exit;
        }

    
    $getinstruments = "SELECT * FROM instruments;";
    $bigdelete = "DELETE FROM instruments;";
    $result = $conn->query($getinstruments);

// Prepare the delete statement
$stmt = $conn->prepare("DELETE FROM instruments WHERE instrument_id = ?;");
$stmt->bind_param('i', $id);
$stmt2 = $conn->prepare($bigdelete);



$all_results = $result->fetch_all();
$all_results_rows = $result->num_rows;

if(isset($_POST["resetdb"])) {
	$conn->query("INSERT INTO instruments (instrument_type)
                             VALUES ('Guitar'),
                                    ('Trumpet'),
                                    ('Flute'),
                                    ('Theramin'),
                                    ('Violin'),
                                    ('Tuba'),
                                    ('Melodica'),
                                    ('Trombone'),
                                    ('Keyboard')
                 ");
}

if(isset($_POST["deleteallcheck"])) {
    for($i = 0; $i < $all_results_rows; $i++) {
            ++$_SESSION["delete_counts"];  
    }
	$stmt2->execute();
}



for($i = 0; $i < $all_results_rows; $i++) {
	$id = $all_results[$i][0];
    if(isset($_POST["checkbox" . $id])) {
        if((!empty($_SESSION['user_name']))){
        ++$_SESSION["delete_counts"];
        }
    }
    if(isset($_POST["checkbox" . $id]) && !$stmt->execute()) {
        // Bind and execute the prepared statement
        echo $conn->error;
      
    }
}




$new_result = $conn->query($getinstruments);


result_to_table($new_result);

    $conn->close();
?>
<p>You have deleted <?php if(isset($_SESSION["delete_counts"])){echo $_SESSION["delete_counts"];}else{echo "no";} ?> records this session</p>
    <form action='manageinstrumentsfinal.php' method=POST>
    <input type='submit' name='togglelight' value='Toggle Light/Dark Mode' method=POST/>
    </form>
</body>
</html>
<?php

function result_to_table($res) {
    $nrows = $res->num_rows;
    $ncols = $res->field_count;
    $resar = $res->fetch_all();

    ?> 
    <p>
   This table has <?php echo $ncols; ?> columns, and <?php echo $nrows; ?> rows.
    </p>
<form action="manageinstrumentsfinal.php" method=POST>
        <table>
        <thead>
        <tr>
        <th>Delete?</th>
    <?php
    while ($fld = $res->fetch_field()) {
    ?>
        <th><?php echo $fld->name; ?></th>
    <?php
    }
    ?>
    </tr>
    </thead>
    <tbody>
    <?php
    for ($i=0;$i<$nrows; $i++) {
    ?>
    <tr>
    <td>
         <input type="checkbox"
       name="checkbox<?php echo $resar[$i][0]; ?>""
       value=<?php echo $resar[$i][0]; #I removed a slash here, reminder in case breaks?>></td>
    <?php
        for ( $j = 0; $j < $ncols; $j++ ) {
    ?>
            <td><?php echo $resar[$i][$j]; ?></td>
    <?php
        }
    ?>        
        </tr>
    <?php
    }
?>
    </tbody>
    </table>
    <input type="submit" value="Delete Selected Records" method=POST/>
</form>
<form action="manageinstrumentsfinal.php" method=POST>
<input type="submit" name="resetdb" value="Add more records" method=POST/>
</form>
<form action="manageinstrumentsfinal.php" method=POST>
<input type="checkbox" name="deleteallcheck" value="Delete all?" method=POST>
<input type="submit" name="deleteall" value="Delete all records" method=POST/>
</form>
<?php
}


?>




