<?php

class xrowFormOperator
{
    function operatorList()
    {
        return array( 'get_campaigns', 'get_crmfields', 'format_pattern' );
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array( 'get_campaigns' => array(),
                      'get_crmfields' => array(),
                      'format_pattern' => array() );
    }

    function modify( $tpl, $operatorName, $operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        if( $operatorName == 'get_campaigns' || $operatorName == 'get_crmfields' )
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
        else
        {
            switch ( $operatorName )
            {
                case 'format_pattern':
                {
                    $operatorValue = preg_replace( '/{/', '&#123;', $operatorValue );
                    $operatorValue = preg_replace( '/}/', '&#125;', $operatorValue );
                    $startsWithSlash = strpos( $operatorValue, '/' );
                    $endsWithSlash = ( strrpos( $operatorValue, '/' ) === ( strlen( $operatorValue ) - strlen ( '/' ) ) );
                    if( $startsWithSlash === 0 && $endsWithSlash !== false )
                    {
                        $operatorValue = substr( $operatorValue, 1, -1);
                    }
                }break;
            }
        }
    }
}
