
<?php
    //This page inserts new photo information from the client into the database
    
    //The page accepts query string parameters UserID, Longitude, Latitude, PhotoURL
    
    //Step1 - Connect to the DB using the connection info stored in login.php
    
    require_once 'database_info.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    //Step2 - In this section, we'll set temp variables for the URL query string parameters
    
    //If we don't set temp variables, we run into problems with the mysql_query function
    
    $tempUserID = $_GET['UserID'];
    $tempUserName = $_GET['UserName'];
    $tempLatitude = $_GET['Latitude'];
    $tempLongitude = $_GET['Longitude'];
    $tempPhotoURL = $_GET['PhotoURL'];
    $tempThumbnailURL = $_GET['ThumbnailURL'];
    
    //Step 3 - Build the query string in a temp variable then actually insert the URL query string into
    
    $result = mysql_query("INSERT INTO Feed VALUES('$tempUserID','$tempUserName','$tempLatitude','$tempLongitude','$tempPhotoURL','$tempThumbnailURL')");
    
    if (!$result) die("Database INSERT failed: " . mysql_error());
    mysql_close($db_server);

?>
