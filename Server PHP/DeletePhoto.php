<?php
    
    //This page accepts a paramter 'PhotoID' and deletes it from the 'feed' database
    header("Content-Type: text/plain");
    
    //Step 1 - Connect and query the DB using the connection info stored in login.php
    require_once 'database_info.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    //create string for call on sql
    //$sql = "DELETE FROM Feed WHERE PhotoID='".$_GET['PhotoID']."'";
    $sql = str_replace("x", $_GET['PhotoID'], "DELETE FROM Feed WHERE PhotoID='x'");
    
    echo $sql;
    
    //make db query
    $result = mysql_query($sql);
    
    //error handle
    if (!$result) die("Database INSERT failed: " . mysql_error());
    
    mysql_close($db_server);
    
?>