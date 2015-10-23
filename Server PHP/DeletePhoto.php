<?php
    
    //This page accepts a paramter 'photoID' and deletes it from the 'feed' database
    //header("Content-Type: text/plain");
    
    //Step 1 - Connect and query the DB using the connection info stored in login.php
    require_once 'database_info.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    $query = "SELECT * FROM Feed WHERE UserID='".$_GET['UserID']."'"; //Maybe hard to get the single quotes to stick in the string value, the PHP compiler may get confused and think that the single quotes are delimters of the string and not the string itself. If so, you can BING for "PHP string escape codes" or something to figure that out
    //echo "What is $query? ".$query;
    $result = mysql_query($query);


    mysql_close($db_server);
?>