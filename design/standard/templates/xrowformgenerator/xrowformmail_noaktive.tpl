{def $crmIsEnabled = false()}
{if and( ezini_hasvariable( 'Settings', 'UseCRM', 'xrowformgenerator.ini' ), ezini( 'Settings', 'UseCRM', 'xrowformgenerator.ini' )|eq( 'enabled' ) )}{set $crmIsEnabled = true()}{/if}
{set-block scope=root variable=subject}{$content.subject}: {"Validate your email address"|i18n( 'xrowformgenerator/mail' )}{/set-block}
{set-block scope=root variable=email_receiver_xrow}{$content.receiver}{/set-block}
{set-block scope=root variable=email_sender}{$content.sender}{/set-block}
{if and( is_set( $object.data_map.mail_header ), $object.data_map.mail_header.has_content )}{$object.data_map.mail_header.content}{/if}

{"We have received your data. To successfully complete the request and to confirm your email address, please click the following link."|i18n( 'xrowformgenerator/mail' )}

{$actual_link}

{if and( is_set( $object.data_map.mail_footer ), $object.data_map.mail_footer.has_content )}

{$object.data_map.mail_footer.content}
{/if}