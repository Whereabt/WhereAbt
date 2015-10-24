<?php
    //This page checks a photo's flag count and then deletes it from the database if the count reaches 3
    
    //The page accepts query string parameter PhotoID
    
    //Step1 - Connect to the DB using the connection info stored in login.php
    
    require_once 'database_info.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    // sql to delete a record
    $photoID = mysql_real_escape_string($_GET['PhotoID']); 

    $sql = "SELECT FROM Feed WHERE ThumbnailURL='%s'", $photoID;
    $sql
    
    if ($conn->query($sql) === TRUE) {
        echo "Record deleted successfully";
    } else {
        echo "Error deleting record: " . $conn->error;
    }
    
    mysql_close($db_server);
    
?>