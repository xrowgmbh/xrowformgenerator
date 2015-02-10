<?php
require 'autoload.php';
$cli = eZCLI::instance();
$db = eZDB::instance();
$today = time();
#60 seconds * 60 minutes * 24hours * 3days = 259200
$max_createtime = $today - 259200;

$script = eZScript::instance( array( 'description' => ( "Delete InfomationcollectionObject that have not clicked activation linkt"),
                                     'use-session' => true,
                                     'use-modules' => true,
                                     'use-extensions' => true,
                                     'debug-output' => false,
                                     'debug-message' =>false) );

$script->startup();
$script->initialize();

$db->begin();
$sql="SELECT ei.id
      FROM ezinfocollection ei,
           ezinfocollection_attribute ea
      WHERE ea.data_int='1'
           AND ei.id = ea.informationcollection_id
           AND ei.created <= '$max_createtime'";

$clean_ids=$db->arrayQuery($sql);
$cli->output( '===========================' );
$cli->output( "Sum: " . count( $clean_ids ) );
$cli->output( '===========================' );
if( count( $clean_ids ) > 0 )
{
    foreach($clean_ids as $clean_id)
    {
        $id_cur=$clean_id['id'];
        $sql2="SELECT data_text FROM ezinfocollection_attribute WHERE informationcollection_id='$id_cur'";
        $data_text_item=$db->arrayQuery($sql2);
        $data_text_deco=unserialize(xrowFormGeneratorType::decryptData($data_text_item[0]["data_text"]));
        foreach ( $data_text_deco['form_elements'] as $item )
        {
            if ( $item['type'] == 'upload' and isset( $item['file_path'] ) and $item['file_path'] != '' )
            {
                unlink($item['file_path']);
            }
        }
    }
}

$sql3="DELETE ei.*, ea.*
      FROM ezinfocollection ei,
           ezinfocollection_attribute ea
      WHERE ea.data_int='1'
        AND ei.id = ea.informationcollection_id
        AND ei.created <= '$max_createtime'";
$db->arrayQuery($sql3);

$db->commit();

$cli->notice("Script is done.");
$script->shutdown();