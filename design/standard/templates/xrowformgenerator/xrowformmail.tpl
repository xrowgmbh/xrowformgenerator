{set-block scope=root variable=subject}{if $content.show_amount}#{$content.no}: {/if}{$content.subject}{/set-block}
{set-block scope=root variable=email_receiver}{$content.receiver}{/set-block}
{set-block scope=root variable=email_sender}{$content.sender}{/set-block}
{if and( is_set( $object.data_map.mail_header ), $object.data_map.mail_header.has_content )}

{$object.data_map.mail_header.content}
{/if}

{if $content.show_amount}{"No.:"|i18n( 'xrowformgenerator/mail' )} {$content.no}

-------------------------------------------------------------------------------

{/if}
{if $content.form_elements|count|gt(0)}
{foreach $content.form_elements as $key => $item}
{if and($item.type|ne( 'spacer' ),$item.type|ne( 'desc' ))}
{concat( $item.name, ': ' )}
{switch match=$item.type}
{case match="checkbox"}{if $item.def}{"Yes"|i18n( 'xrowformgenerator/mail' )}{else}{"No"|i18n( 'xrowformgenerator/mail' )}{/if}{/case}
{case match="upload"}{cond( is_set( $item.def ), "Yes"|i18n( 'xrowformgenerator/mail' ),'' )}{/case}
{case match="options"}
{switch match=$item.option_type}
{case match="checkbox"}


{foreach $item.option_array as $opt_key => $opt_item}
{if $opt_item.def}{$opt_item.name}, {/if}
{/foreach}
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


{foreach $item.option_array as $opt_key => $opt_item}
{if $opt_item.def}{$opt_item.name}, {/if}
{/foreach}
{/case}
{/switch}
{/case}
{case match="imageoptions"}
{switch match=$item.option_type}
{case match="checkbox"}


{foreach $item.option_array as $opt_key => $opt_item}
{if $opt_item.def}{$opt_item.name}, {/if}
{/foreach}
{/case}
{case match="radio"}
{foreach $item.option_array as $opt_key => $opt_item}
{if $opt_item.def}{$opt_item.name}{/if}
{/foreach}


{/case}
{/switch}
{/case}
{case match="number"}{$item.def}{/case}
{case match="text"}{$item.def}{/case}

{case}{$item.def}{/case}
{/switch}

-------------------------------------------------------------------------------

{/if}
{/foreach}
{/if}

{if and( is_set( $object.data_map.mail_footer ), $object.data_map.mail_footer.has_content )}

{$object.data_map.mail_footer.content}
{/if}