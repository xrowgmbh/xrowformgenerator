<?php

$offset = 0;

if ( isset( $Params['Offset'] ) and is_numeric( $Params['Offset'] ) )
{
    $offset = $Params['Offset'];
}
$limit = 1000;
if ( isset( $Params['Limit'] ) and is_numeric( $Params['Limit'] ) )
{
    $limit = $Params['Limit'];
}
if ( $limit > 1000 )
{
    $limit = 1000;
}
$nodeID = 0;
if ( isset( $Params['NodeID'] ) and is_numeric( $Params['NodeID'] ) )
{
    $nodeID = $Params['NodeID'];
}

$node = eZContentObjectTreeNode::fetch( $nodeID );
if ( $node instanceof eZContentObjectTreeNode )
{
    $dataMap = $node->attribute( 'data_map' );
    foreach ( $dataMap as $attribute )
    {
        if ( $attribute->attribute( 'data_type_string' ) == 'xrowformgenerator' )
        {
            // found the attribute ...
            $xform = new xrowFormGeneratorType();
            $export = $xform->exportFormData( $attribute->attribute( 'id' ), $node->attribute( 'contentobject_version' ),  $offset, $limit );
            
            // excel don't like utf-8...
            $export = chr(255).chr(254).mb_convert_encoding( $export, 'UTF-16LE', 'UTF-8');             
            
            $httpCharset = eZTextCodec::httpCharset();
            header( 'Content-type: application/csv' );
            header( 'Content-Length: '. mb_strlen( $export ) );
            header( 'X-Powered-By: eZ Publish' );
            header("Content-Disposition: attachment; filename=\"formexport_" . $nodeID . "_" . $offset . "_" . $limit . ".csv\"");
            
            //header( 'Cache-Control: public, must-revalidate, max-age=' . $timeout );

            
            while ( @ob_end_clean() );
            
            echo $export;
            
            eZExecution::cleanExit();
        }
    }
}
else 
{
    eZDebug::writeError( 'NodeID ' . $nodeID . ' not found', 'xrow form generator csv export' );
}

if ( $nodeID == 0 )
{
    $nodeID = 2;
}

$http = eZHTTPTool::instance();
return $http->redirect( '/content/view/full/' . $nodeID );
?>