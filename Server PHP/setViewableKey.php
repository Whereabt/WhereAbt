<?php
    //this page accepts a view key parameter, and photo ID parameter
    
    require_once 'database_info.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    $sql = sprintf("UPDATE Feed SET Viewable='%s' WHERE PhotoID='%s'", $_GET['Viewable'], $_GET['PhotoID']);
    $result = mysql_query($sql);
    
    if (!$result) die("Database INSERT failed: " . mysql_error());
    
    mysql_close($db_server);

?>