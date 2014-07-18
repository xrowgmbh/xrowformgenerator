<?php

class xrowFormOperator
{
    function operatorList()
    {
        return array( 'get_campaigns', 'get_crmfields' );
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array( 'get_campaigns' => array(),
                      'get_crmfields' => array() );
    }

    function modify( $tpl, $operatorName, $operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        $pluginOptions = new ezpExtensionOptions( array( 'iniFile' => 'xrowformgenerator.ini',
                                                         'iniSection' => 'PluginSettings',
                                                         'iniVariable' => 'FormCRMPlugin' ) );
        $pluginHandler = eZExtension::getHandlerClass( $pluginOptions );
        if( !( $pluginHandler instanceof xrowFormCRM ) )
        {
            eZDebug::writeError( 'PluginHandler does not exist: ', __METHOD__ );
        }
        try
        {
            switch ( $operatorName )
            {
                case 'get_campaigns':
                {
                    $operatorValue = $pluginHandler->getCampaigns();
                }break;
                case 'get_crmfields':
                {
                    $operatorValue = $pluginHandler->getFields();
                }break;
            }
        }
        catch( xrowSalesForceException $e )
        {
            eZDebug::writeError( 'Fehler ' . $e->getMessage() . ', Zeile ' . $e->getLine(), __METHOD__ );
        }
    }
}