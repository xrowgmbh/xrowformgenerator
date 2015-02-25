<?php
$module = $Params['Module'];
$tpl = eZTemplate::factory();
$xform = new xrowFormGeneratorType();
$db = eZDB::instance();
$ini = eZINI::instance();

if(!empty($_GET["id"]))
{
    $aktiv_id = $xform->urlsafe_b64decode($_GET["id"]);
    $sql_check = $db->arrayQuery("SELECt data_int FROM ezinfocollection_attribute WHERE informationcollection_id='".$aktiv_id."'");
    if($sql_check[0]["data_int"] == "1")
    {
    $sql = "UPDATE ezinfocollection_attribute SET data_int =0 WHERE informationcollection_id='".$aktiv_id."'";
    $db->arrayQuery( $sql );
    $results= $db->arrayQuery('SELECT * FROM ezinfocollection_attribute WHERE informationcollection_id="'.$aktiv_id.'"');
    
    if(count( $results ) > 0)
    {
        foreach($results as $result)
        {
            if($result["data_int"] === "0") 
            {
                $tpl->setVariable( "active",0);
                $object = eZContentObject::fetch($result["contentobject_id"]);
                $info_collect = eZInformationCollection::fetch($aktiv_id);
                $attributes = $info_collect->informationCollectionAttributes();
                $content = $attributes[0]->content();
                
                $collection = eZInformationCollection::fetch($result["informationcollection_id"],true);
                $inhalt = unserialize($xform->decryptData($result["data_text"]));
                
                $tplc = eZTemplate::factory();
                $tplc->setVariable( 'collection_id', $result["informationcollection_id"] );
                $tplc->setVariable( 'collection', $collection );
                $tplc->setVariable( 'object', $object );
                $tplc->setVariable( "active",0);
                $tplc->setVariable( 'content', $content );
                $templateResult = $tplc->fetch( 'design:xrowformgenerator/xrowformmail.tpl' );
                $subject = $object->Name;
                $receiverString = $inhalt["receiver"];
                if($receiverString != "")
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
                if(is_array( $receiverArray ))
                {
                    $sender = $inhalt["sender"];
                    if ( ! $xform->validate( $sender ) )
                    {
                        if( $ini->hasVariable( 'MailSettings', 'EmailSender' ) )
                        {
                            $sender = $ini->variable( "MailSettings", "EmailSender" );
                        }
                        else
                        {
                            $sender = $ini->variable( "MailSettings", "AdminEmail" );
                        }
                    }
                    ezcMailTools::setLineBreak( "\n" );
                    $mail = new ezcMailComposer();
                    $mail->charset = 'utf-8';
                    $mail->from = new ezcMailAddress( $sender, '', $mail->charset );
                    $mail->returnPath = $mail->from;
                    foreach ( $receiverArray as $receiver )
                    {
                        $mail->addTo( new ezcMailAddress( $receiver, '', $mail->charset ) );
                    }
                    $mail->subject = $subject;
                    $mail->subjectCharset = $mail->charset;
                    $mail->plainText = $templateResult;
                    foreach ( $inhalt['form_elements'] as $item )
                    {
                        if ( $item['type'] == 'upload' and isset( $item['file_path'] ) and $item['file_path'] != '' )
                        {
                            $disposition = new ezcMailContentDispositionHeader();
                            $disposition->fileName =  $item['original_filename'];
                            $disposition->fileNameCharSet = 'utf-8';
                            $disposition->disposition = 'attachment';
                            $mail->addAttachment( $item['file_path'], null, null, null, $disposition );
                        }
                    }
                    $mail->build();
                    
                    $mailsettings = array();
                    $mailsettings["transport"] = $ini->variable( "MailSettings", "Transport" );
                    $mailsettings["server"] = $ini->variable( "MailSettings", "TransportServer" );
                    $mailsettings["port"] = $ini->variable( "MailSettings", "TransportPort" );
                    $mailsettings["user"] = $ini->variable( "MailSettings", "TransportUser" );
                    $mailsettings["password"] = $ini->variable( "MailSettings", "TransportPassword" );
                    $mailsettings["connectionType"] = $ini->variable( 'MailSettings', 'TransportConnectionType' );
                    
                    if( trim($mailsettings["port"]) == "" )
                    {
                        $mailsettings["port"] = null;
                    }
                    if ( strtolower($mailsettings["transport"]) == "smtp" )
                    {
                        $options = new ezcMailSmtpTransportOptions();
                        if( trim($mailsettings["password"]) === "" )
                        {
                            $transport = new ezcMailSmtpTransport( $mailsettings["server"], "", "", $mailsettings["port"], $options );
                        }
                        else
                        {
                            $options->preferredAuthMethod = ezcMailSmtpTransport::AUTH_AUTO;
                            $transport = new ezcMailSmtpTransport( $mailsettings["server"], $mailsettings["user"], $mailsettings["password"], $mailsettings["port"], $options );
                        }
                    }
                    else if ( strtolower($mailsettings["transport"]) == "sendmail" )
                    {
                        $transport = new ezcMailMtaTransport();
                    }
                    else if ( strtolower($mailsettings["transport"]) == "file" )
                    {
                        $mail = new eZMail();
                        $mail->setSender( $sender );
                        $mail->addReceiver( $receiverString );
                        $mail->setSubject( $subject );
                        $mail->setBody( $templateResult );
                        eZFileTransport::send( $mail );
                    }
                    else
                    {
                        eZDebug::writeError( "Wrong Transport in MailSettings in", 'xrowFormGeneratorType::xrowSendFormMail' );
                        return null;
                    }
                    
                    if ( strtolower($mailsettings["transport"]) != "file" )
                    {
                        try
                        {
                            $transport->send( $mail );
                        }
                        catch ( ezcMailTransportException $e )
                        {
                            eZDebug::writeError( $e->getMessage(), 'xrowFormGeneratorType::xrowSendFormMail' );
                        }
                    }
                    foreach ( $inhalt['form_elements'] as $item )
                    {
                        if ( $item['type'] == 'upload' and isset( $item['file_path'] ) and $item['file_path'] != '' )
                        {
                            unlink($item['file_path']);
                        }
                    }
                }
                
            }else {
                $tpl->setVariable( "active",1);
            }
        }
    }
    }
}

$Result = array();
$Result['content'] = $tpl->fetch( "design:content/collectedinfo/xrowform.tpl" );
$Result['path'] = array( array( 'text' => ezpI18n::tr( 'xrowformgenerator/mail', 'active' ),
                                'url' => false ) );