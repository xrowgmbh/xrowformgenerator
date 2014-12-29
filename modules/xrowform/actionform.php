<?php
/**
 * @copyright Copyright (C) eZ Systems AS. All rights reserved.
 * @license For full copyright and license information view LICENSE file distributed with this source code.
 * @version //autogentag//
 * @package kernel
 */

$http = eZHTTPTool::instance();
$module = $Params['Module'];

if ( $module->hasActionParameter( 'LanguageCode' ) )
    $languageCode = $module->actionParameter( 'LanguageCode' );
else
{
    $languageCode = false;
}

$viewMode = 'full';
if ( $http->hasPostVariable( 'ViewMode' ) )
    $viewMode = $http->postVariable( 'ViewMode' ) ;

// Merge post variables and variables that were used before login
if ( $http->hasSessionVariable( 'LastPostVars' ) )
{
    $post = $http->attribute( 'post' );
    $currentPostVarNames = array_keys( $post );
    foreach ( $http->sessionVariable( 'LastPostVars' ) as $var => $value )
    {
        if ( !in_array( $var, $currentPostVarNames ) )
        {
            $http->setPostVariable( $var, $value );
        }
    }

    $http->removeSessionVariable( 'LastPostVars' );
}
if ( $http->hasPostVariable( "ContentObjectID" )  )
{
    $objectID = $http->postVariable( "ContentObjectID" );

    // Check which action to perform
    if ( $http->hasPostVariable( "ActionCollectInformation" ) )
    {
        $result = $module->run( "collectinformation", array() );
    }
    else
    {
        return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
    }
}
else if ( !isset( $result ) )
{
    return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

// return module contents
$Result = array();
if(isset($result))
{
    foreach ($result as $key => $item)
    {
        $Result[$key] = $item;
    }
}
$Result['pagelayout'] = 'design:' . $viewMode . '/pagelayout.tpl';