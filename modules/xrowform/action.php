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
        return $module->run( "collectinformation", array() );
    }
    else
    {
        return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
    }
}
else if ( $http->hasPostVariable( 'RedirectButton' ) )
{
    if ( $http->hasPostVariable( 'RedirectURI' ) )
    {
        $module->redirectTo( $http->postVariable( 'RedirectURI' ) );
        return;
    }
}
else if ( $http->hasPostVariable( 'DestinationURL' ) )
{
    $postVariables = $http->attribute( 'post' );
    $destinationURL = $http->postVariable( 'DestinationURL' );
    $additionalParams = '';

    foreach( $postVariables as $key => $value )
    {
        if ( is_array( $value ) )
        {
            $value = implode( ',', $value );
        }
        if ( strpos( $key, 'Param' ) === 0 )
        {
            $destinationURL .= '/' . $value;
        }
        else if ( $key != 'DestinationURL' &&
                  $key != 'Submit' )
        {
            $additionalParams .= "/$key/$value";
        }
    }

    $module->redirectTo( '/' . $destinationURL . $additionalParams );
    return;
}
else if ( !isset( $result ) )
{
    return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

// return module contents
$Result = array();
$Result['content'] = isset( $result ) ? $result : null;