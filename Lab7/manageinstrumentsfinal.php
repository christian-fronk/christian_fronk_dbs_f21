<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="basic.css">
</head>
<body>
    <h1>Delete Instruments</h1>
    
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
	$stmt2->execute();
}

for($i = 0; $i < $all_results_rows; $i++) {
	$id = $all_results[$i][0];
    if(isset($_POST["checkbox" . $id]) && !$stmt->execute()) {
        // Bind and execute the prepared statement
        echo $conn->error;
    }
}



$new_result = $conn->query($getinstruments);


result_to_table($new_result);

    $conn->close();
?>
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




