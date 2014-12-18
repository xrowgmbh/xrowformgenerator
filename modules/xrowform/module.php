<?php

$Module = array( 'name' => 'xrow Form',
                 'variable_params' => true );

$ViewList = array();

$ViewList['action'] = array('script' => 'action.php',
                            'functions' => array('read'),
                            'params' => array() );
$ViewList['collectinformation'] = array('script' => 'collectinformation.php',
                                        'functions' => array('read'),
                                        'default_navigation_part' => 'ezcontentnavigationpart',
                                        'single_post_actions' => array('ActionCollectInformation' => 'CollectInformation'),
                                        'post_action_parameters' => array('CollectInformation' => array('ContentObjectID' => 'ContentObjectID',
                                                                                                        'ContentNodeID' => 'ContentNodeID',
                                                                                                        'ViewMode' => 'ViewMode')),
                                        'params' => array());
$ViewList['view'] = array('script' => 'view.php',
                          'functions' => array('read'),
                          'default_navigation_part' => 'ezcontentnavigationpart',
                          'params' => array('ViewMode', 'NodeID'),
                          'unordered_params' => array('language' => 'Language',
                                                      'offset' => 'Offset',
                                                      'year' => 'Year',
                                                      'month' => 'Month',
                                                      'day' => 'Day'));
$ViewList['export'] = array('script' => 'export.php',
                            'functions' => array('export'),
                            'params' => array('NodeID', 'Offset', 'Limit'));

$ClassID = array(
        'name'=> 'Class',
        'values'=> array(),
        'class' => 'eZContentClass',
        'function' => 'fetchList',
        'parameter' => array( 0, false, false, array('name' => 'asc')));
$SectionID = array(
        'name'=> 'Section',
        'values'=> array(),
        'class' => 'eZSection',
        'function' => 'fetchList',
        'parameter' => array(false));
$Assigned = array(
        'name'=> 'Owner',
        'values'=> array(
                array('Name' => 'Self',
                      'value' => '1')));
$AssignedGroup = array(
        'name'=> 'Group',
        'single_select' => true,
        'values'=> array(array('Name' => 'Self',
                               'value' => '1')));
$Node = array(
        'name'=> 'Node',
        'values'=> array());
$Subtree = array(
        'name'=> 'Subtree',
        'values'=> array());

$stateLimitations = eZContentObjectStateGroup::limitations();

$FunctionList = array();
$FunctionList['export'] = array();
$FunctionList['read'] = array( 'Class' => $ClassID,
                               'Section' => $SectionID,
                               'Owner' => $Assigned,
                               'Group' => $AssignedGroup,
                               'Node' => $Node,
                               'Subtree' => $Subtree);
$FunctionList['read'] = array_merge( $FunctionList['read'], $stateLimitations );