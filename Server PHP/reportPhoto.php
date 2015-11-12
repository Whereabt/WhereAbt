<?php
    //this page accepts a photo ID parameter
    
    require_once 'database_info.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    $sql = str_replace("x", $_GET['PhotoID'],"SELECT PhotoURL FROM Feed WHERE PhotoID='x'");
    
    $result = mysql_query($sql);
    
    if (!$result) die("Database INSERT failed: " . mysql_error());
    
    mysql_close($db_server);
    
    $url = mysql_result($result,0);
    
    if ($_GET['Reason'] == "A") {
        
    }
    
    $reason = "Reason for reporting photo: " . $_GET['Reason'];
    
    $to = '17nisa@mvcds.org';
    //$to = 'rob.franco@gmail.com, 17nisa@mvcds.org';
    $subject = 'Whereabout Photo Report';
    
    //message
    $linkMessage = str_replace("x", $url,"Link to view photo: x");
    $userInfoMessage = $reason . "User ID:" . $_GET['UserID'];
    $finalMessage = $userInfoMessage . " " . $linkMessage;
    
    $headers = 'From: whereaboutfeedback@outlook.com' . "\r\n" .
    'Reply-To: whereaboutfeedback@outlook.com' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();
    
    mail($to, $subject, $finalMessage, $headers);
    
?>