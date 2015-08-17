<?php
    
    //This page inserts new photo information from the client into the database
    header("Content-Type: text/plain");
    
    //Step 1 - Connect and query the DB using the connection info stored in login.php
    require_once 'database_info.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    $query = "SELECT * FROM Feed"; //BUGBUG: easy to make this more selective using Latitude and Longitude as WHERE clause criteria
    $result = mysql_query($query);
    
    if (!$result) die("Database access failed: " . mysql_error());
    $rows = mysql_num_rows($result);
    
    
    //Step 2 - We'll need the distance function to calculate distance between the user and each entry
    
    function distance($lat1, $lon1, $lat2, $lon2, $unit) {
        $theta = $lon1 - $lon2;
        $dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) +  cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta));
        $dist = acos($dist);
        $dist = rad2deg($dist);
        $miles = $dist * 60 * 1.1515;
        $unit = strtoupper($unit);
        
        if ($unit == "K") {
            return ($miles * 1.609344);
        } else if ($unit == "N") {
            return ($miles * 0.8684);
        } else {
            return $miles;
        }
    }
    
    
    
    //Step 3 - write out the data & calculate distance from user
    
    //Set a default radius
    $Radius="3";
    
    //Check if Radius was set in the query string, if so, override the default with the query value
    if ($_GET['Radius']) $Radius=$_GET['Radius'];
    
    //BUGBUG: FOR loop can be done more efficiently, see PHP guide, example 10-6
    for ($j = 0; $j < $rows; ++$j)
    {
        
        $MilesAway = distance(mysql_result($result,$j,'Latitude'),
                              mysql_result($result,$j,'Longitude'),
                              $_GET['Latitude'],
                              $_GET['Longitude'], "M");
        if ($MilesAway < $Radius){
            //Each row of the database is read one at a time into innerarray
            $innerarray =
            array('MilesAway' => $MilesAway,
                  'UserID' => mysql_result($result,$j,'UserID') ,
                  'UserName' => mysql_result($result,$j,'UserName') ,
                  'Latitude' => mysql_result($result,$j,'Latitude'),
                  'Longitude' => mysql_result($result,$j,'Longitude'),
                  'PhotoURL' => mysql_result($result,$j,'PhotoURL'),
                  'ThumbnailURL' => mysql_result($result,$j,'ThumbnailURL'),
                  'TimeStamp' => mysql_result($result,$j,'TimeStamp'));
            
            //Add each row of the for loop to the outer array
            $outerarray[] = $innerarray;
            
        }
        
    }
    //Sort will apply to the 'MilesAway' value since that one is the first in each sub-array
    sort($outerarray);
    
    //Use stripslashes to avoid backslashes in URLs like 'http:\/\/foo.com\/'
    
    echo  stripslashes(json_encode($outerarray, JSON_PRETTY_PRINT));
    
    mysql_close($db_server);
    
    ?>