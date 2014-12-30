
<?php
    
    //This page inserts new photo information from the client into the database
    echo "This page accepts query string parameters Latitude, Longitude for user's current location<br /><br />";
    
    
    //Step 1 - Connect and query the DB using the connection info stored in login.php
    require_once 'login.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    $query = "SELECT * FROM Feed"; //BUGBUG: easy to make this more selective using Latitude and Longitude as WHERE clause criteria
    $result = mysql_query($query);
    
    if (!$result) die("Database access failed: " . mysql_error());

    $rows = mysql_num_rows($result);
    
    
    //Step 2 - For debugging, we'll show the latitude and longitude
    
    echo 'Latitude in URL= ' . $_GET['Latitude'] . '<br />';
    echo 'Longitude in URL= ' .$_GET['Longitude'] . '<br /><br />';
    
    
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
        
        /* these are examples of how to use the distance function
         
        echo distance(32.9697, -96.80322, 29.46786, -98.53506, "M") . " Miles<br>";
        echo distance(32.9697, -96.80322, 29.46786, -98.53506, "K") . " Kilometers<br>";
        echo distance(32.9697, -96.80322, 29.46786, -98.53506, "N") . " Nautical Miles<br><br><br>";
         
        */
    
    
    //Step 3 - write out the data & calculate distance from user
    
    echo 'Feed data ========= <br /><br />';
    
    //BUGBUG: This can be done more efficiently, see PHP guide, example 10-6
    for ($j = 0; $j < $rows; ++$j)
    {
        echo 'Feed entry# ' . $j . '<br />';
        echo 'UserID: ' . mysql_result($result,$j,'UserID') . '<br />';
        echo 'Latitude: ' . mysql_result($result,$j,'Latitude') . '<br />';
        echo 'Longitude: ' . mysql_result($result,$j,'Longitude') . '<br />';
        echo 'PhotoURL: ' . mysql_result($result,$j,'PhotoURL') . '<br />';
        echo 'Miles away: ' . distance(mysql_result($result,$j,'Latitude'), mysql_result($result,$j,'Longitude'), $_GET['Latitude'], $_GET['Longitude'], "M"). '<br />'. '<br />';

    }
    
    mysql_close($db_server);
?>
