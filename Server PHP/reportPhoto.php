<?php
    //this page accepts photo ID, UserID, and reason parameters
    
    require_once 'database_info.php';
    
    $db_server = mysql_connect($hostname, $username, $password);
    
    if (!$db_server) die("Unable to connect to MySQL: " . mysql_error());
    
    mysql_select_db($dbname) or die("Unable to select database: " . mysql_error());
    
    $sql = str_replace("x", $_GET['PhotoID'],"SELECT PhotoURL FROM Feed WHERE PhotoID='x'");
    
    $result = mysql_query($sql);
    
    if (!$result) die("Database INSERT failed: " . mysql_error());
    
    mysql_close($db_server);
    
    $imageUrl = mysql_result($result,0);
    
    if ($_GET['Reason'] == "A") {
        $reason = "User did not like the image";
    }
    
    elseif ($_GET['Reason'] == "B") {
        $reason = "User believed that image was scam or spam";
    }
    
    elseif ($_GET['Reason'] == "C") {
        $reason = "User believed image put people at risk";
    }
    
    else {
        $reason = "User believes image does not belong on Whereabout";
    }
    
    
    
    $to = '17nisa@mvcds.org';
    //$to = 'rob.franco@gmail.com, 17nisa@mvcds.org';
    $subject = 'Whereabout Photo Report';
    
    //message
    $imageLinkMessage = str_replace("x", $url,"Link to view photo: x");
    $userInfoMessage = $reason . "---User ID:" . $_GET['UserID'];
    //$finalMessage = $userInfoMessage . "---" . $imageLinkMessage;
    
    $viewKeyLink = sprintf("https://n46.org/whereabt/setViewableKey.php?PhotoID=%s&Viewable=FALSE",$_GET['PhotoID']);
    
    $finalMessage = sprintf("%s \r\n Link to view photo: %s \r\n User ID:%s \r\n Link to change view key (ONLY CLICK IF PHOTO IS INAPPROPRIATE): %s", $reason, $imageUrl, $_GET['UserID'], $viewKeyLink);
    
    $headers = 'From: whereaboutfeedback@outlook.com' . "\r\n" .
    'Reply-To: whereaboutfeedback@outlook.com' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();
    
    mail($to, $subject, $finalMessage, $headers);
    
?>