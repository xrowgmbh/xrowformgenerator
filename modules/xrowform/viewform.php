<?php
/**
 * @copyright Copyright (C) eZ Systems AS. All rights reserved.
 * @license For full copyright and license information view LICENSE file distributed with this source code.
 * @version //autogentag//
 * @package kernel
 */

$tpl = eZTemplate::factory();

$ViewMode = $Params['ViewMode'];
$NodeID = $Params['NodeID'];
$Module = $Params['Module'];
$LanguageCode = $Params['Language'];
$Offset = $Params['Offset'];

if ( isset( $Params['UserParameters'] ) )
{
    $UserParameters = $Params['UserParameters'];
}
else
{
    $UserParameters = array();
}

if ( $Offset )
    $Offset = (int) $Offset;

$NodeID = (int) $NodeID;

if ( $NodeID < 2 )
{
    return $Module->handleError( eZError::KERNEL_NOT_FOUND, 'kernel' );
}

$ini = eZINI::instance();

$viewCacheEnabled = ( $ini->variable( 'ContentSettings', 'ViewCaching' ) == 'enabled' );
if ( isset( $Params['ViewCache'] ) )
{
    $viewCacheEnabled = $Params['ViewCache'];
}
elseif ( $viewCacheEnabled && !in_array( $ViewMode, $ini->variableArray( 'ContentSettings', 'CachedViewModes' ) ) )
{
    $viewCacheEnabled = false;
}

if ( $viewCacheEnabled && $ini->hasVariable( 'ContentSettings', 'ViewCacheTweaks' ) )
{
    $viewCacheTweaks = $ini->variable( 'ContentSettings', 'ViewCacheTweaks' );
    if ( isset( $viewCacheTweaks[$NodeID] ) && strpos( $viewCacheTweaks[$NodeID], 'disabled' ) !== false )
    {
        $viewCacheEnabled = false;
    }
}

$collectionAttributes = false;
if ( isset( $Params['CollectionAttributes'] ) )
    $collectionAttributes = $Params['CollectionAttributes'];

$validation = array( 'processed' => false,
                     'attributes' => array() );
if ( isset( $Params['AttributeValidation'] ) )
    $validation = $Params['AttributeValidation'];

$res = eZTemplateDesignResource::instance();
$keys = $res->keys();
if ( isset( $keys['layout'] ) )
    $layout = $keys['layout'];
else
    $layout = false;

$viewParameters = array(
    'offset' => $Offset,
    'namefilter' => false,
    '_custom' => $UserParameters
);
// Keep the following array_merge for BC
// All user parameters will be exposed as direct variables in template.
$viewParameters = array_merge( $viewParameters, $UserParameters );

$user = eZUser::currentUser();

eZDebugSetting::addTimingPoint( 'kernel-content-view', 'Operation start' );

$operationResult = array();
if ( eZOperationHandler::operationIsAvailable( 'content_read' ) )
{
    $operationResult = eZOperationHandler::execute( 'content', 'read', array( 'node_id' => $NodeID,
                                                                              'user_id' => $user->id(),
                                                                              'language_code' => $LanguageCode ), null, true );
}

if ( ( isset( $operationResult['status'] ) && $operationResult['status'] != eZModuleOperationInfo::STATUS_CONTINUE ) )
{
    switch( $operationResult['status'] )
    {
        case eZModuleOperationInfo::STATUS_HALTED:
        case eZModuleOperationInfo::STATUS_REPEAT:
        {
            if ( isset( $operationResult['redirect_url'] ) )
            {
                $Module->redirectTo( $operationResult['redirect_url'] );
                return;
            }
            else if ( isset( $operationResult['result'] ) )
            {
                $result = $operationResult['result'];
                $resultContent = false;
                if ( is_array( $result ) )
                {
                    if ( isset( $result['content'] ) )
                    {
                        $resultContent = $result['content'];
                    }
                    if ( isset( $result['path'] ) )
                    {
                        $Result['path'] = $result['path'];
                    }
                }
                else
                {
                    $resultContent = $result;
                }
                $Result['content'] = $resultContent;
            }
        } break;
        case eZModuleOperationInfo::STATUS_CANCELLED:
        {
            $Result = array();
            $Result['content'] = "Content view cancelled<br/>";
        } break;
    }
    return $Result;
}
else
{
    $args = compact(
        array(
            "NodeID", "Module", "tpl", "LanguageCode", "ViewMode", "Offset", "ini", "viewParameters", "collectionAttributes", "validation"
        )
    );
    $data = eZNodeviewfunctions::contentViewGenerate( false, $args ); // the false parameter will disable generation of the 'binarydata' entry
    return $data['content']; // Return the $Result array
}
