{def $crmIsEnabled = false()}
{if and( ezini_hasvariable( 'Settings', 'UseCRM', 'xrowformgenerator.ini' ), ezini( 'Settings', 'UseCRM', 'xrowformgenerator.ini' )|eq( 'enabled' ) )}{set $crmIsEnabled = true()}{/if}
{set-block scope=root variable=subject}{$content.subject}:{"Validate your email address"|i18n( 'xrowformgenerator/mail' )}{/set-block}
{set-block scope=root variable=email_receiver_xrow}{$content.receiver}{/set-block}
{set-block scope=root variable=email_sender}{$content.sender}{/set-block}
{if and( is_set( $object.data_map.mail_header ), $object.data_map.mail_header.has_content )}{$object.data_map.mail_header.content}{/if}

{"We have received your data. To successfully complete the request and to confirm your email address, please click the following link."|i18n( 'xrowformgenerator/mail' )}

{$actual_link}

-------------------------------------------------------------------------------

{if and( is_set( $content.show_amount ), $content.show_amount )}{"No.:"|i18n( 'xrowformgenerator/mail' )} {$content.no}

-------------------------------------------------------------------------------

{/if}

{if $content.form_elements|count|gt(0)}
{foreach $content.form_elements as $key => $item}
{if and( $item.type|contains( 'crmfield:' ), $crmIsEnabled )}
{include uri='design:xrowformgenerator/xrowformmailcrmfielditem.tpl'}
{else}
{if not(array('spacer','desc','hidden')|contains($item.type))}
{concat( $item.name, ': ' )}
{switch match=$item.type}
{case match="checkbox"}{if $item.def}{"Yes"|i18n( 'xrowformgenerator/mail' )}{else}{"No"|i18n( 'xrowformgenerator/mail' )}{/if}{/case}
{case match="upload"}{cond( is_set( $item.def ), $item.original_filename|wash(),'' )}{/case}
{case match="options"}
{switch match=$item.option_type}
{case match="checkbox"}


{def $output = ''}{foreach $item.option_array as $opt_key => $opt_item}{if $opt_item.def}{if $output|ne( '' )}{set $output = concat( ', ', $output )}{/if}{set $output = concat( $output, $opt_item.name )}{/if}{/foreach}
{if $output|ne('')}{$output}{/if}{undef $output}
{/case}
{case match="radio"}
{foreach $item.option_array as $opt_key => $opt_item}
{if $opt_item.def}{$opt_item.name}{/if}
{/foreach}
{/case}
{case match="select-one"}
{foreach $item.option_array as $opt_key => $opt_item}
{if $opt_item.def}{$opt_item.name}{/if}
{/foreach}
{/case}
{case match="select-all"}


{def $output = ''}{foreach $item.option_array as $opt_key => $opt_item}{if $opt_item.def}{if $output|ne( '' )}{set $output = concat( ', ', $output )}{/if}{set $output = concat( $output, $opt_item.name )}{/if}{/foreach}
{if $output|ne('')}{$output}{/if}{undef $output}
{/case}
{/switch}
{/case}
{case match="imageoptions"}
{switch match=$item.option_type}
{case match="checkbox"}


{def $output = ''}{foreach $item.option_array as $opt_key => $opt_item}{if $opt_item.def}{if $output|ne( '' )}{set $output = concat( ', ', $output )}{/if}{set $output = concat( $output, $opt_item.name )}{/if}{/foreach}
{if $output|ne('')}{$output}{/if}{undef $output}
{/case}
{case match="radio"}
{foreach $item.option_array as $opt_key => $opt_item}
{if $opt_item.def}{$opt_item.name}{/if}
{/foreach}


{/case}
{/switch}
{/case}
{case match="number"}{$item.def}{/case}
{case match="telephonenumber"}{$item.def}{/case}
{case match="text"}{$item.def}{/case}

{case}{$item.def}{/case}
{/switch}

-------------------------------------------------------------------------------

{/if}
{/if}
{/foreach}
{/if}

{if and( is_set( $object.data_map.mail_footer ), $object.data_map.mail_footer.has_content )}

{$object.data_map.mail_footer.content}
{/if}