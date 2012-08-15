<?php

$Module = array( 'name' => 'xrow Form',
                 'variable_params' => true );

$ViewList = array();
$ViewList['export'] = array( 'script' => 'export.php',
                           'functions' => array( 'export' ),
                           'params' => array( 'NodeID', 'Offset', 'Limit' ) );

$FunctionList = array();
$FunctionList['export'] = array();

?>