<?php

/**
 * class xrowFormGenerator datatype generates
 * dynamic forms per content object
 * It supports various types of formular data
 * @author Georg Franz, georg@xrow.de
 */

class xrowFormGeneratorType extends eZDataType
{
    const DATA_TYPE_STRING = "xrowformgenerator";
    const REGEXP = '(((\"[^\"\f\n\r\t\v\b]+\")|([A-Za-z0-9_\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}\.]+(\.[A-Za-z0-9_\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}\.]+)*))@((\[(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))\])|(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))|((([A-Za-z0-9\-])+\.)+[A-Za-z\-]{2,})))';


    function xrowFormGeneratorType()
    {
        $this->eZDataType( self::DATA_TYPE_STRING, ezpI18n::tr( 'kernel/classes/datatypes', "Form generator", 'Datatype name' ),
                           array( 'serialize_supported' => false ) );
    }

    /*
     * unset the content cache at storing the object attribute
     */
    function storeObjectAttribute( $objectAttribute )
    {
        if ( isset( $GLOBALS['XrowFormCache'] ) )
        {
            unset( $GLOBALS['XrowFormCache'] );
        }
        return true;
    }

    /*!
     Sets the default value.
    */
    function initializeObjectAttribute( $contentObjectAttribute, $currentVersion, $originalContentObjectAttribute )
    {
        if ( $currentVersion != false )
        {
            $dataText = $originalContentObjectAttribute->attribute( "data_text" );
            $contentObjectAttribute->setAttribute( "data_text", $dataText );

        }
    }

    /*
     * The input of the form setup is always valid.
     */
    function validateObjectAttributeHTTPInput( $http, $base, $contentObjectAttribute )
    {
        return eZInputValidator::STATE_ACCEPTED;
    }

    function validateCollectionAttributeHTTPInput( $http, $base, $objectAttribute )
    {
        $content = $objectAttribute->content();
        if ( $content['has_http_input'] == true
             and $content['has_error'] == false )
        {
            return eZInputValidator::STATE_ACCEPTED;
        }
        return eZInputValidator::STATE_INVALID;
    }

    function strip($value)
    {
        return is_array($value) ? array_map('xrowFormGeneratorType::strip', $value) : strip_tags($value);
    }

    function strip_a_tag($value)
    {
        return is_array($value) ? array_map('xrowFormGeneratorType::strip_a_tag', $value) : strip_tags($value,"<a><br>");
    }

    /*
     * Fetches the input of the form generator config
     */
    function httpConfigInput( eZHTTPTool $http, eZContentObjectAttribute $attribute )
    {
        $id = $attribute->attribute( "id" );
        $data_array['use_captcha'] = false;
        $data_array['show_anzeige'] = false;
        $data_array['button_text'] = "";
        $tplKey = "XrowFormElementArray" . $id;
        if ( $http->hasPostVariable( $tplKey ) )
        {
            $formElementArray = self::strip( $http->postVariable( $tplKey ) );
            $data = array();
            
            $tplKeyArray = array( 'XrowFormCaptcha' => 'use_captcha',
                                  'XrowFormAmount' => 'show_amount',
                                  'XrowFormReceiver' => 'receiver',
                                  'XrowFormSubject' => 'subject',
                                  'XrowFormSender' => 'sender',
                                  'XrowFormButton' => 'button_text',
                                  'XrowFormAnzeige'=> 'show_anzeige');
            foreach( $tplKeyArray as $tplKeyIndex => $tplKeyItem )
            {
                if ( $http->hasPostVariable( $tplKeyIndex . $id ) )
                {
                    $data_array[$tplKeyItem] = self::strip( $http->postVariable( $tplKeyIndex . $id ) );
                }
            }

            // form config array
            $keyArray = array( "XrowFormElementType" . $id => "type",
                               "XrowFormElementName" . $id => "name",
                               "XrowFormElementDefault" . $id => "def",
                               "XrowFormElementDesc" . $id => "desc",
                               "XrowFormElementReq" . $id => "req",
                               "XrowFormElementVal" . $id => "val",
                               "XrowFormElementUnique" . $id => "unique",
                               "XrowFormElementOptionType" . $id => "option_type",
                               "XrowFormElementOptionArray" . $id => "option",
                               "XrowFormElementOption" . $id => "option_name",
                               "XrowFormElementOptionDefault" . $id => "option_def",
                               "XrowFormElementOptionImageArray" . $id => "option_image" );

            // Read the formular config array
            foreach ( $keyArray as $tplFormKey => $dataKey )
            {
                $varName = $dataKey . "Array";
                $$varName = array();
                if ( $http->hasPostVariable( $tplFormKey ) )
                {
                    if($dataKey != "desc"){
                        $$varName = self::strip($http->postVariable( $tplFormKey ));
                    }else{
                        $$varName = self::strip_a_tag($http->postVariable( $tplFormKey ));
                    }
                }
            }

            // Map the content
            foreach ( $formElementArray as $key )
            {
                $data = array();
                if ( isset( $typeArray[$key] ) )
                {
                    $type = $typeArray[$key];
                    $data['type'] = $type;
                    $data['name'] = $data['desc'] = $data['def'] = null;
                    $data['req'] = $data['val'] = $data['unique'] = false;

                    if ( isset( $nameArray[$key] ) )
                    {
                        $data['name'] = $nameArray[$key];
                    }

                    if ( $type == 'checkbox' )
                    {
                        if ( isset( $defArray[$key] ) )
                        {
                            $data['def'] = true;
                        }
                        else
                        {
                            $data['def'] = false;
                        }
                    }
                    else
                    {
                        if ( isset( $defArray[$key] ) )
                        {
                            $data['def'] = $defArray[$key];
                        }
                    }

                    if ( isset( $descArray[$key] ) )
                    {
                        $data['desc'] = $descArray[$key];
                    }

                    if ( isset( $reqArray[$key] ) )
                    {
                        $data['req'] = true;
                    }
                    if ( isset( $valArray[$key] ) )
                    {
                        $data['val'] = true;
                    }
                    if ( isset( $uniqueArray[$key] ) )
                    {
                        $data['unique'] = true;
                    }

                    if ( $type == 'options' or $type == 'imageoptions' )
                    {
                        if ( isset( $optionArray[$key] ) )
                        {
                            $data['option_type'] = $option_typeArray[$key];
                            $options = array();
                            foreach ( $optionArray[$key] as $optKey )
                            {
                                $item = array( 'name' => '', 'def' => false );
                                if ( $type == 'imageoptions' )
                                {
                                    $item['image'] = 0;
                                }
                                if ( isset( $option_nameArray[$key][$optKey] ) )
                                {
                                    $item['name'] = $option_nameArray[$key][$optKey];
                                }
                                if ( isset( $option_defArray[$key][$optKey] ) )
                                {
                                    $item['def'] = true;
                                }
                                if ( isset( $option_imageArray[$key][$optKey] ) )
                                {
                                    $item['image'] = $option_imageArray[$key][$optKey];
                                }
                                $options[$optKey] = $item;
                            }
                            $data['option_array'] = $options;
                        }
                    }
                }
                $data_array['form_elements'][] = $data;
            }
            $attribute->setAttribute( "data_text", serialize( $data_array ) );
            return true;
        }
        return false;
    }

    /*!
     Fetches the http post var string input and stores it in the data instance.
    */
    function fetchObjectAttributeHTTPInput( $http, $base, $objectAttribute )
    {
        
        return $this->httpConfigInput( $http, $objectAttribute );
        
    }

    public static function fetchCollectionCountForObject( $objectID, $infoID )
    {
        if ( !is_numeric( $objectID ) )
        {
            return 1;
        }

        $db = eZDB::instance();
        $resultArray = $db->arrayQuery( "SELECT COUNT( * ) as count FROM ezinfocollection WHERE id != $infoID AND contentobject_id=$objectID" );

        return $resultArray[0]['count'] + 1;
    }

    /*!
     Fetches the http post variables for collected information
    */
    function fetchCollectionAttributeHTTPInput( $collection, $collectionAttribute, $http, $base, $objectAttribute )
    {
        $content = $objectAttribute->content();

        if ( $content['has_http_input'] == true and $content['has_error'] == false  )
        {    
            $amount = $this->fetchCollectionCountForObject( $collection->attribute( 'contentobject_id' ), $collection->attribute( 'id' ) );
            $content['no'] = $amount;

            $dataText = serialize( $content );
            $collectionAttribute->setAttribute( 'data_text', $dataText );

            // Sending the mail
            $this->xrowSendFormMail( $collection, $collectionAttribute, $objectAttribute, $content );
            return true;
        }
        return false;
    }

    public function xrowSendFormMail( $collection, $collectionAttribute, $objectAttribute, $content )
    {
        $ini = eZINI::instance();
        $tpl = eZTemplate::factory();

        $object = $objectAttribute->attribute( 'object' );
        $tpl->setVariable( 'collection_id', $collection->attribute( 'id' ) );
        $tpl->setVariable( 'collection', $collection );
        $tpl->setVariable( 'object', $object );

        $tpl->setVariable( 'content', $content );
        $tpl->setVariable( 'object', $object );
        $templateResult = $tpl->fetch( 'design:xrowformgenerator/xrowformmail.tpl' );

        $subject = $tpl->variable( 'subject' );
        $receiverString = $tpl->variable( 'email_receiver_xrow' );
        $ccReceivers = $tpl->variable( 'email_cc_receivers' );
        $bccReceivers = $tpl->variable( 'email_bcc_receivers' );
        $sender = $tpl->variable( 'email_sender' );
        if ( !self::validate( $sender ) )
        {
            $sender = $ini->variable( "MailSettings", "EmailSender" );
        }
        if( $receiverString != '' )
        {
            if( strpos( $receiverString, ';' ) !== false )
            {
                $receiverArray = explode( ";", $receiverString );
            }
            else
            {
                $receiverArray = array( $receiverString );
            }
            if ( count( $receiverArray ) == 0 )
            {
                $receiverArray = array( $ini->variable( "InformationCollectionSettings", "EmailReceiver" ) );
            }
        }
        $this->sendMailWithEzMail( $templateResult, $receiverArray, $sender, $tpl );
        return true;
        ezcMailTools::setLineBreak( "\n" );
        $mail = new ezcMailComposer();
        $mail->charset = 'utf-8';
        $mail->from = new ezcMailAddress( $sender, '', 'utf-8' );
        foreach ( $receiverArray as $receiver )
        {
            $mail->addTo( new ezcMailAddress( $receiver, '', 'utf-8' ) );
        }

        //  Handle CC recipients
        if ( $ccReceivers )
        {
            if ( !is_array( $ccReceivers ) )
                $ccReceivers = array( $ccReceivers );
            foreach ( $ccReceivers as $ccReceiver )
            {
                if ( self::validate( $ccReceiver ) )
                {
                    $mail->addCc( $ccReceiver );
                }
            }
        }

        // Handle BCC recipients
        if ( $bccReceivers )
        {
            if ( !is_array( $bccReceivers ) )
                $bccReceivers = array( $bccReceivers );

            foreach ( $bccReceivers as $bccReceiver )
            {
                if ( self::validate( $bccReceiver ) )
                {
                    $mail->addBcc( $bccReceiver );
                }
            }
        }

        $mail->subject = $subject;
        $mail->plainText = $templateResult;
        foreach ( $content['form_elements'] as $item )
        {
            if ( $item['type'] == 'upload' and isset( $item['def'] ) and $item['def'] != '' )
            {
                $binaryFile = eZHTTPFile::fetch( $item['def'] );
                if ( $binaryFile instanceof eZHTTPFile )
                {
                    $disposition = new ezcMailContentDispositionHeader();
                    $disposition->fileName =  $binaryFile->OriginalFilename;
                    $disposition->fileNameCharSet = 'utf-8'; // if using non-ascii characters in the file name
                    $disposition->disposition = 'attachment'; // default value is 'inline'
                    $mail->addAttachment( $binaryFile->Filename, null, null, null, $disposition );
                }
            }
        }
        $mail->build();
        $transport = new ezcMailMtaTransport();
        try
        {
            $transport->send( $mail );
        }
        catch ( ezcMailTransportException $e )
        {
            eZDebug::writeError( $e->getMessage(), 'xrowFormGeneratorType::xrowSendFormMail' );
        }
    }

    public function sendMailWithEzMail( $templateResult, $receiverArray, $sender, $tpl )
    {
        $mail = new eZMail();
        $mail->setSender( $sender );
        $mail->setBody( $templateResult  );
        $mail->setSubject( $tpl->variable( 'subject' ) );
        foreach ( $receiverArray as $receiver )
        {
            $mail->setReceiver( $receiver );
            if ( $transport != 'file' )
            {
                try
                {
                    eZMailTransport::send( $mail );
                }
                catch( Exception $e )
                {
                    eZDebug::writeError( $e->getMessage(), __METHOD__ );
                }
            }
        }
    }

    /*!
     Returns the content.
    */
    function objectAttributeContent( $contentObjectAttribute )
    {
       
        $id = $contentObjectAttribute->attribute( 'id' );
        $contentobject_id = $contentObjectAttribute->attribute( 'contentobject_id' );

        $cacheKey = 'col';
        if ( $contentObjectAttribute instanceof eZContentObjectAttribute )
        {
            $cacheKey = 'attr';
        }

        if ( isset( $GLOBALS['XrowFormCache'][$id][$cacheKey] ) )
        {
            return $GLOBALS['XrowFormCache'][$id][$cacheKey];
        }

        $trans = eZCharTransform::instance();

        $raw_content = $contentObjectAttribute->attribute( "data_text" );
        $content = array( 'form_elements' => array(),
                          'use_captcha' => false,
                          'show_amount' => false,
                          'show_anzeige'=> false,
                          'json' => json_encode( array() ),
                          'has_error' => false,
                          'error_array' => array(),
                          'has_http_input' => false,
                          'no' => 1 );

        // Checking if there is http input for the form fields
        $httpInput = false;
        $httpKey =  "XrowFormInputArray";
        $http = eZHTTPTool::instance();
        if ( $http->hasPostVariable( $httpKey ) )
        {
            $inputAllKeyArray = self::strip( $http->postVariable( $httpKey ) );
            $inputKeyArray = $inputAllKeyArray[$id];

            if ( count( $inputKeyArray ) > 0 )
            {
                $httpInput = true;
                $content['has_http_input'] = true;
                $inputAllArray = self::strip( $http->postVariable( 'XrowFormInput' ) );
                $inputArray = $inputAllArray[$id];
                $inputAllTypeArray = self::strip( $http->postVariable( 'XrowFormInputType' ) );
                $inputTypeArray = $inputAllTypeArray[$id];
            }
        }

        if ( strlen( $raw_content ) > 0 )
        {
            $content = unserialize( $raw_content );
            $content['has_http_input'] = false;
            $content['error_array'] = array();
            $content['has_error'] = false;
            $content['has_http_input'] = $httpInput;
            $content['json'] = json_encode( array() );
            $usedIDArray = array();
            $locale = eZLocale::instance();
            #eZDebug::writeDebug( $content, 'form content' );
            foreach ( $content['form_elements'] as $key => $item )
            {
                $content['form_elements'][$key]['error'] = false;
                $content['form_elements'][$key]['has_input'] = false;
                if ( trim( $item['name'] ) == "" )
                {
                    $item['name'] = $key;
                }
                $i = 0;
                $elementID = mb_strtolower( $trans->transformByGroup( $item['name'], 'identifier' ) );
                $testID = $elementID;
                do
                {
                    if ( !in_array( $testID, $usedIDArray ) )
                    {
                        $usedIDArray[] = $testID;
                        $content['form_elements'][$key]['class'] = "xrow-form-" .  mb_strtolower( $trans->transformByGroup( $item['name'], 'urlalias' ) );
                        $content['form_elements'][$key]['id'] = $testID;
                        break;
                    }
                    $testID = $elementID . '-' . $i;
                    $i++;
                } while ( $i < 100 );

                // checking if there is any http input for the current element
                // the http input overrides the default values
                if ( $httpInput )
                {
                    $elKey = $inputKeyArray[$key];
                    if ( $item['type'] == $inputTypeArray[$elKey] )
                    {
                        switch ( $item['type'] )
                        {
                            case "text":
                            case "string":
                            {
                                $data = '';
                                if ( isset( $inputArray[$elKey] ) )
                                {
                                    $data = $inputArray[$elKey];
                                }
                                if ( $item['req'] == true )
                                {
                                    if ( trim( $data ) == '' )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Input required." );
                                    }
                                }
                                $content['form_elements'][$key]['def'] = $data;
                            }break;

                            case "email":
                            {
                                $data = '';
                                if ( isset( $inputArray[$elKey] ) )
                                {
                                    $data = trim( $inputArray[$elKey] );
                                }
                               
                                if ( $item['req'] == true )
                                {
                                    if ( $data == '' )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Input required." );
                                    }elseif($item['val'] == true)
                                     {
                                        if ( !self::validate( $data ) )
                                        {
                                            $content['form_elements'][$key]['error'] = true;
                                            $content['has_error'] = true;
                                            $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "E-mail address is not valid." );
                                        }elseif($item['unique'] == true)
                                        {
                                            if ( !self::email_unique( $data, $contentobject_id ) )
                                            {
                                                $content['form_elements'][$key]['error'] = true;
                                                $content['has_error'] = true;
                                                $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Your email was already submitted to us. You can't use the form twice." );
                                            }       
                                        }
                                     }    
                                }elseif ( $item['val'] == true && $data != '')
                                {
                                    if ( !self::validate( $data ) )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "E-mail address is not valid." );
                                    }elseif($item['unique'] == true) 
                                    {
                                        if ( !self::email_unique( $data, $contentobject_id ) )
                                        {
                                            $content['form_elements'][$key]['error'] = true;
                                            $content['has_error'] = true;
                                            $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Your email was already submitted to us. You can't use the form twice." );
                                        }                             
                                    }
                                }elseif($item['unique'] == true && $data != '')
                                {
                                    if ( !self::email_unique( $data, $contentobject_id ) )
                                        {
                                            $content['form_elements'][$key]['error'] = true;
                                            $content['has_error'] = true;
                                            $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Your email was already submitted to us. You can't use the form twice." );
                                        }   
                                }
                                
                                $content['form_elements'][$key]['def'] = $data;
                            }break;

                            case "checkbox":
                            {
                                $data = false;
                                if ( isset( $inputArray[$elKey] ) )
                                {
                                    $data = true;
                                }
                                if ( $item['req'] == true )
                                {
                                    if ( !$data )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "You need to select this checkbox." );
                                    }
                                }
                                $content['form_elements'][$key]['def'] = $data;
                            }break;
                            
                            case "telephonenumber":
                            {
                                $data = '';
                                if ( isset( $inputArray[$elKey] ) )
                                {
                                    $data = trim( $inputArray[$elKey] );
                                    $data = str_replace(" ", "", $data );
                                }
                                if ( $item['req'] == true )
                                {
                                    if ( $data == '' )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Input required." );
                                    }elseif ( !self::telephone_validate( $data ) || strlen($data)>=20 )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Please enter a valid phone number." );
                                    }
                                }elseif ( $item['val'] == true && $data != '' )
                                 {
                                    if ( !self::telephone_validate( $data ) || strlen($data)>=20  )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Please enter a valid phone number." );
                                    }
                                 }
                                $content['form_elements'][$key]['def'] = $data;
                            }break;

                            case "number":
                            {
                                $data = '';
                                if ( isset( $inputArray[$elKey] ) )
                                {
                                    $data = trim( $inputArray[$elKey] );
                                    $data = str_replace(" ", "", $data );
                                }
                                if ( $item['req'] == true )
                                {
                                    if ( $data == '' )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Input required." );
                                    }
                                }
                                if ( $item['val'] == true && $data != '')
                                {
                                    $dataTest = $locale->internalNumber( $data );
                                    $floatValidator = new eZFloatValidator();
                                    $state = $floatValidator->validate( $dataTest );
                                    if ( $state !== 1 )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Please enter a valid number." );
                                    }
                                }
                                $content['form_elements'][$key]['def'] = $data;
                            }break;

                            case "options":
                            case "imageoptions":
                            {
                                if ( isset( $inputArray[$elKey] ) )
                                {
                                    $dataArray = $inputArray[$elKey];
                                    if ( !is_array( $dataArray ) )
                                    {
                                        $dataArray = array( $dataArray );
                                    }
                                    $optSelected = false;
                                    #eZDebug::writeDebug( $dataArray, 'dataArray' );
                                    foreach ( $item['option_array'] as $optKey => $optItem )
                                    {
                                        $content['form_elements'][$key]['option_array'][$optKey]['def'] = false;
                                        if ( in_array( $optItem['name'], $dataArray ) )
                                        {
                                            $content['form_elements'][$key]['option_array'][$optKey]['def'] = true;
                                            $optSelected = true;
                                        }
                                        /*
                                        if ( $item['type'] == 'imageoptions'
                                             AND $item['req'] == true
                                             AND $item['image'] == 0 )
                                        {
                                            $content['form_elements'][$key]['error'] = true;
                                            $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Please select an image for the option." );
                                        }
                                        */
                                    }
                                    if ( $item['req'] == true )
                                    {
                                        if ( !$optSelected )
                                        {
                                            $content['form_elements'][$key]['error'] = true;
                                            $content['has_error'] = true;
                                            $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Please select at least one option." );
                                        }
                                    }
                                }
                                else
                                {
                                    if ( $item['req'] == true )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Please select at least one option." );
                                    }
                                }

                            }break;
                            case "upload":
                            {
                                $test = new eZBinaryFileType();
                                $test->checkFileUploads();
                                $fileKey = "XrowFormInputFile_" . $id . '_' . $key;
                                $maxSize = 1024 * 1024 * 50;
                                $checkUpload = eZHTTPFile::canFetch( $fileKey, $maxSize );
                                #eZDebug::writeDebug( $checkUpload, 'upload check' );

                                if ( $checkUpload >= 0 )
                                {
                                    $binaryFile = eZHTTPFile::fetch( $fileKey );

                                    if ( $binaryFile instanceof eZHTTPFile )
                                    {
                                        $content['form_elements'][$key]['def'] = $fileKey;
                                        $content['form_elements'][$key]['original_filename'] = $binaryFile->attribute( 'original_filename' );
                                    }
                                }
                                else
                                {
                                    if ( $item['req'] == true AND $checkUpload == eZHTTPFile::UPLOADEDFILE_DOES_NOT_EXIST )
                                    {
                                       $content['form_elements'][$key]['error'] = true;
                                       $content['has_error'] = true;
                                       $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "Please add a valid file for upload." );
                                    }
                                    else if ( $checkUpload == eZHTTPFile::UPLOADEDFILE_EXCEEDS_PHP_LIMIT or
                                              $checkUpload == eZHTTPFile::UPLOADEDFILE_EXCEEDS_MAX_SIZE )
                                    {
                                        $content['form_elements'][$key]['error'] = true;
                                        $content['has_error'] = true;
                                        $content['error_array'][] = $item['name'] . ": " . ezpI18n::tr( 'kernel/classes/datatypes', "The uploaded file is too big. Please select a smaller one." );
                                    }
                                    else
                                    {
                                        eZDebug::writeError( 'Unknown file upload error', __METHOD__ );
                                    }
                                }
                            }break;
                            default:
                            {
                                #no validation needed
                            }break;
                        }
                    }
                    else
                    {
                        eZDebug::writeError( 'xrowForm input error: Wrong type of element.', __METHOD__ );
                    }
                } /* if $http_input */

                if ( $item['type'] == 'imageoptions' )
                {
                    foreach ( $item['option_array'] as $optKey => $optItem )
                    {
                        if ( isset( $content['form_elements'][$key]['option_array'][$optKey]['image'] )
                             AND $content['form_elements'][$key]['option_array'][$optKey]['image'] > 0 )
                        {
                            self::getImageForOption( $content['form_elements'][$key]['option_array'][$optKey], $id );
                        }
                    }
                }

                // json encode for javascript
                $content['form_elements'][$key]['json'] = json_encode( $content['form_elements'][$key] );
                $content['data_map'][$testID] = $content['form_elements'][$key];
            }
        }

        // Checking the captcha code
        $ini = eZINI::instance('xrowformgenerator.ini');
        if( $ini->variable( "Settings", "Captcha" ) == "recaptcha")
        {
            if ( $httpInput and $content['use_captcha'] )
            {
                $dataType = new recaptchaType();
                $spamTest = $dataType->validateCollectionAttributeHTTPInput( $http, 'ContentObjectAttribute', $contentObjectAttribute );
                if( $spamTest == eZInputValidator::STATE_INVALID )
                {
                    $content['has_error'] = true;
                    $content['error_array'][] = ezpI18n::tr( 'kernel/classes/datatypes', "The reCAPTCHA wasn't entered correctly. Please try again." );
                }
            }
        }elseif( $ini->variable( "Settings", "Captcha" )=="humancaptcha")
        {
            if ( $httpInput and $content['use_captcha'] )
            {
                $dataType = new eZHumanCAPTCHAType();
                $spamTest = $dataType->validateObjectAttributeHTTPInput( $http, 'ContentObjectAttribute', $contentObjectAttribute );

                if ( $spamTest !== eZInputValidator::STATE_ACCEPTED )
                {
                    $content['has_error'] = true;
                    $content['error_array'][] = ezpI18n::tr( 'kernel/classes/datatypes', "Spam protection. The signs of the captcha code didn't match. Please enter the correct code of the image at the bottom." );
                }
            }
        }
        #eZDebug::writeDebug( $content, 'form config content' );
        $GLOBALS['XrowFormCache'][$id][$cacheKey] = $content;
        
        return $content;
    }

    function customObjectAttributeHTTPAction( $http, $action, $contentObjectAttribute, $parameters )
    {
        $action = explode( "_", $action );
        if ( count( $action ) == 3 )
        {
            $row = $action[0];
            $item = $action[1];
            $action = $action[2];
        }

        switch ( $action )
        {
            case "selectimage" :
            {
                if ( $http->hasPostVariable( 'BrowseActionName' ) and
                          $http->postVariable( 'BrowseActionName' ) == 'xrowFormImageBrowse'
                          and $http->hasPostVariable( "SelectedNodeIDArray" ) )
                {
                    if ( !$http->hasPostVariable( 'BrowseCancelButton' ) )
                    {
                        $selectedNodeIDArray = $http->postVariable( "SelectedNodeIDArray" );
                        $nodeID = $selectedNodeIDArray[0];
                        $dataText = $contentObjectAttribute->attribute( "data_text" );
                        $content = unserialize( $dataText );
                        #eZDebug::writeDebug( $content, 'content' );
                        if ( isset( $content['form_elements'] ) )
                        {
                            $content['form_elements'][$row]['option_array'][$item]['image'] = $nodeID;

                            if ( $nodeID > 0 )
                            {
                                self::getImageForOption( $content['form_elements'][$row]['option_array'][$item], $contentObjectAttribute->attribute( 'id' ) );
                            }
                            $contentObjectAttribute->setAttribute( "data_text", serialize( $content ) );
                            $contentObjectAttribute->store();
                            
                        }
                    }
                }
            } break;

            case "browse" :
            {
                $module = $parameters['module'];
                $redirectionURI = $parameters['current-redirection-uri'];

                eZContentBrowse::browse( array( 'action_name' => 'xrowFormImageBrowse',
                                                'browse_custom_action' => array( 'name' => 'CustomActionButton[' . $contentObjectAttribute->attribute( 'id' ) . '_' . $row . '_' . $item . '_selectimage]',
                                                                                 'value' => '' ),
                                                'persistent_data' => array( 'HasObjectInput' => 0 ),
                                                'from_page' => $redirectionURI ),
                                         $module );
            } break;

            default :
            {
                eZDebug::writeError( "Unknown custom HTTP action: " . $action, __METHOD__ );
            } break;
        }
    }

    /**
     * Returns the image url of an image option
     *
     * @param array $imgArray
     * @param int $attributeID
     * @return mixed
     */
    public static function getImageForOption( array &$imgArray, $attributeID )
    {
        $result = array();
        $nodeID = $imgArray['image'];
        $iNode = eZContentObjectTreeNode::fetch( $nodeID );
        if ( $iNode instanceof eZContentObjectTreeNode )
        {
            $dataMap = $iNode->attribute( 'data_map' );
            foreach ( $dataMap as $dataItem )
            {
                if ( $dataItem->attribute( 'data_type_string' ) == 'ezimage'
                     AND $dataItem->hasContent() )
                {
                    // image attribute found
                    $image = $dataItem->content();
                    $imageVariant = $image->attribute( 'small' );
                    if ( is_array( $imageVariant ) and count( $imageVariant ) > 0 )
                    {
                        $imageURL = $imageVariant['url'];
                        $imgArray['image_src'] = '/' . $imageURL;
                        $imgArray['attribute_id'] = $attributeID;
                        $imgArray['width'] = $imageVariant['width'];
                        $imgArray['height'] = $imageVariant['height'];
                        return;
                    }
                }
            }
        }
        eZDebug::writeDebug( 'Invalid node id', __METHOD__ );
    }

    function hasObjectAttributeContent( $contentObjectAttribute )
    {
        $content = $contentObjectAttribute->content();
        if ( count( $content['form_elements'] ) > 0 )
        {
            return true;
        }
        return false;
    }

    /*!
     \reimp
    */
    function isInformationCollector()
    {
        return true;
    }

    /*!
     \return true if the data type can do information collection
    */
    function hasInformationCollection()
    {
        return true;
    }

    /**
     * Exports all collected form data
     *
     * @param int $attributeID
     * @param int $version
     * @param int $offset
     * @param int $limit
     * @return string
     */
    public function exportFormData( $attributeID, $version, $offset, $limit = 1000 )
    {
        $this->separationChar = chr( 9 );
        $attribute = eZContentObjectAttribute::fetch( $attributeID, $version );
        if ( !( $attribute instanceof eZContentObjectAttribute ) )
        {
            eZDebug::writeError( $attribute . " attribute id not found ", __METHOD__ );
            return "";
        }
        $content = $attribute->content();

        $db = eZDB::instance();
        $sql = "SELECT
                   a.data_text,
                   b.id,
                   b.created
                FROM
                   ezinfocollection_attribute a,
                   ezinfocollection b
                WHERE
                   a.contentobject_attribute_id='$attributeID'
                   AND a.informationcollection_id = b.id
                ORDER BY b.id";

        $resultArray = $db->arrayQuery( $sql, array( 'offset' => $offset, 'limit' => $limit ) );

        $first = true;

        $contentArray = array();
        $i = 0;
        $contentArray[$i]['no'] = ezpI18n::tr( 'xrowformgenerator/mail', "No.:" );
        $contentArray[$i]['created_xrow'] = ezpI18n::tr( 'xrowformgenerator/mail', "Date" );
        foreach ( $content['form_elements'] as $fItem )
        {
            if ( trim( $fItem['name'] ) == '' )
            {
                $contentArray[0][$fItem['id']] = $fItem['id']; 
            }
            else 
            {
                $contentArray[0][$fItem['id']] = $fItem['name']; 
            } 
        }

        $keyArray = array_keys( $contentArray[0] );

        $i++;
        if ( count( $resultArray ) > 0 )
        {
            foreach ( $resultArray as $item )
            {
                $formData = unserialize( $item['data_text'] );

                if ( count( $formData['form_elements'] ) > 0 )
                {
                    if ( isset( $formData['no'] ) )
                    {
                        $contentArray[$i]['no'] = $formData['no'];
                    }
                    else 
                    {
                        $contentArray[$i]['no'] = $i;
                    }
                    
                    $contentArray[$i]['created_xrow'] = date( "d.m.Y H:i:s", $item['created'] );
                    
                    foreach ( $formData['form_elements'] as $aItem )
                    {
                        /**
                         * If the key isn't present in the definition, add the data
                         * at the end
                         */
                        if ( !in_array( $aItem['id'], $keyArray ) )
                        {
                            $keyArray[] = $aItem['id'];
                            if ( trim( $aItem['name'] ) == '' )
                            {
                                $contentArray[0][$aItem['id']] = $aItem['id']; 
                            }
                            else 
                            {
                                $contentArray[0][$aItem['id']] = $aItem['name']; 
                            }                              
                        }
                        switch ( $aItem['type'] )
                        {
                            case 'checkbox':
                            {
                                if ( $aItem['def'] )
                                {
                                    $contentArray[$i][$aItem['id']] = ezpI18n::tr( 'xrowformgenerator/mail', "Yes" );
                                }
                                else
                                {
                                    $contentArray[$i][$aItem['id']] = ezpI18n::tr( 'xrowformgenerator/mail', "No" );
                                }
                            }break;
                            case "options":
                            case "imageoptions":
                            {
                                $oFirst = true;
                                foreach ( $aItem['option_array'] as $optItem )
                                {
                                    if ( $optItem['def'] )
                                    {
                                        if ( $oFirst )
                                        {
                                            $oFirst = false;
                                        }
                                        else
                                        {
                                            $contentArray[$i][$aItem['id']] .= ', ';
                                        }
                                        $contentArray[$i][$aItem['id']] .= trim( $optItem['name'] );
                                    }
                                }
                            }break;
                            default:
                            {
                                $contentArray[$i][$aItem['id']] = trim( $aItem['def'] );
                            }break;
                        }
                    }

                    $i++;
                }
            }
        }

        $export = "";
        
        foreach ( $contentArray as $no => $line )
        {
            $first = true;
            foreach ( $keyArray as $key )
            {
                if ( isset( $line[$key] ) )
                {
                    $entry = $line[$key];
                }
                else 
                {
                    $entry = "";
                }
                if ( $first )
                {
                    $first = false;
                }
                else
                {
                    $export .= $this->separationChar;
                }
                $export .= $this->escape( str_replace( chr( 9 ), ' ', $entry ) );
            }
            $export .= $this->lineEnding;
        }

        return $export;
    }

    /**
     * Escapes a string for csv export
     *
     * @param string $stringtoescape
     * @return string
     */
    public function escape( $stringtoescape )
    {
        //ASCII/CRLF=0x0D 0x0A   13 10

        if ( $this->escape and ( strpos( $stringtoescape, $this->encloseChar ) !== false or
             strpos( $stringtoescape, $this->separationChar ) !== false or
             strpos( $stringtoescape, chr(13)) !== false or // CR
             strpos( $stringtoescape, chr(10)) !== false )    // LF
           )
        {
           $stringtoescape = str_replace( $this->encloseChar, $this->encloseChar . $this->encloseChar, $stringtoescape );
           return $this->encloseChar . $stringtoescape . $this->encloseChar;
        }
        else
        {
            $stringtoescape = str_replace( chr(13), '', $stringtoescape );
            $stringtoescape = str_replace( chr(10), '', $stringtoescape );
            return $stringtoescape;
        }
    }

    /*!
      \static
      Static function for validating e-mail addresses.

      Returns true if successful, false if not.
    */
    static function validate( $address )
    {
        return preg_match( '/^' . self::REGEXP . '$/', $address );
    }
    
    static function telephone_validate( $address )
    {
        return preg_match( '/^([+]{0,1}\d{2,3}|0+[0-9]{2,5})[ ]?([-]?((\d)|[ ]){1,12})+$/', $address );
    }

    static function email_unique( $address, $contentobject_id )
    {
        // gets DB instance         
        $db = eZDB::instance();

        $sql = "
           SELECT ezinfocollection_attribute.data_text, count( ezinfocollection_attribute.id ) as count 
           FROM 
              ezinfocollection_attribute
           WHERE 
              ezinfocollection_attribute.data_text LIKE '%" . $address . "%'
           AND contentobject_id = " . $contentobject_id;

        // executes query
        $resArray = $db->arrayQuery( $sql );
        if( count( $resArray ) > 0 )
        {
            foreach( $resArray as $resItem )
            {
                $resItemArray = unserialize( $resItem["data_text"] );
                if( is_array( $resItemArray ) && count( $resItemArray ) > 0 )
                {
                    foreach( $resItemArray as $resItemArrayItem )
                    {
                        if( $resItemArrayItem == $address )
                        { 
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }
    
    public $escape = true;
    public $encloseChar = '"';
    public $separationChar = ";";
    public $lineEnding = "\r\n";

}

eZDataType::register( xrowFormGeneratorType::DATA_TYPE_STRING, "xrowFormGeneratorType" );

?>
