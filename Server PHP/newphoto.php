
<?php

    //This page inserts new photo information from the client into the database

    echo "This page accepts query string parameters UserID, Longitude, Latitude and PhotoURL<br /><br />";
    
    //Step1 - Connect to the DB using the connection info stored in login.php
    
    require_once 'database_info.php';
   
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());

    //Step2 - In this section, we'll set temp variables for the URL query string parameters
    //We need to set temp variables because the
    $tempUserID = $_GET['UserID'];
    $tempLatitude = $_GET['Latitude'];
    $tempLongitude = $_GET['Longitude'];
    $tempPhotoURL = $_GET['PhotoURL'];

    //Step3 - **Echo the output to the page, debugging only, users won't see this**
    echo "Here are the values you submitted<br />";
    echo $tempUserID . '<br />';
    echo $tempLatitude . '<br />';
    echo $tempLongitude . '<br />';
    echo $tempPhotoURL . '<br /><br />';

    //Step 4 - Build the query string in a temp variable then actually insert the URL query string into
    //$tempQuery = "INSERT INTO Feed VALUES('$tempUserID','$tempLatitude','$tempLongitude','$tempPhotoURL')";
    //$result = mysql_query($tempQuery);
    $result = mysql_query("INSERT INTO Feed VALUES('$tempUserID','$tempLatitude','$tempLongitude','$tempPhotoURL')");
    
    if (!$result) die("Database INSERT failed: " . mysql_error());

    echo "Did it work??<br />";
    echo $result;
    
    mysql_close($db_server);
    
?>
