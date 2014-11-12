{def $collection = cond( $collection_id, fetch( content, collected_info_collection, hash( collection_id, $collection_id ) ),
                          fetch( content, collected_info_collection, hash( contentobject_id, $node.contentobject_id ) ) )}

{set-block scope=global variable=title}{'Form %formname'|i18n( 'design/ezwebin/collectedinfo/form', , hash( '%formname', $node.name|wash() ) )}{/set-block}

<div class="thankyou_page">

<div class="attribute-header">
    <h1>{'Form sent successfully'|i18n( 'xrowformgenerator/mail' )}</h1>
</div>

{if $node.data_map.thankyou_page.has_content}
   {attribute_view_gui attribute=$node.data_map.thankyou_page}
{else}
    <p>{'Thank You! You have successfully submitted the form.'|i18n( 'xrowformgenerator/mail' )}</p>
{/if}

{if $error}

{if $error_existing_data}
<p>{'You have already submitted this form. The data you entered was:'|i18n('design/ezwebin/collectedinfo/form')}</p>
{/if}

{/if}

{if $node.data_map.form.content.show_anzeige}
<div class="content-view-full">
{if $collection.data_map.form.content.form_elements|count|gt(0)}
    <table class="anzeige_table" cellspacing="0" cellpadding="2">
        <caption>{'Your data'|i18n('xrowformgenerator/mail')}</caption>
            <tbody>
            {foreach $collection.data_map.form.content.form_elements as $key => $item}
            {if and($item.type|ne( 'spacer' ),$item.type|ne( 'desc' ), $item.type|ne('hidden'))}
            <tr>
                <th>{cond( and($item.type|ne( 'spacer' ),$item.type|ne( 'desc' )), concat( $item.name, ': ' ), '' )}</th>
                <td>
                    {switch match=$item.type}
                        {case match="checkbox"}{if $item.def}{"Yes"|i18n( 'xrowformgenerator/mail' )}{else}{"No"|i18n( 'xrowformgenerator/mail' )}{/if}{/case}
                        {case match="upload"}{cond( is_set( $item.def ), $item.name,'' )}{/case}
                        {case match="options"}
                            {switch match=$item.option_type}
                                {case match="checkbox"}
                                    {def $output = ''}
                                    {foreach $item.option_array as $opt_key => $opt_item}{if $opt_item.def}{if $output|ne( '' ){set $output = concat( ', ', $output )}{/if}{set $output = concat( $output, $opt_item.name )}{/if}{/foreach}
                                    {$output}
                                    {undef $output}
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
                                    {def $output = ''}
                                    {foreach $item.option_array as $opt_key => $opt_item}{if $opt_item.def}{if $output|ne( '' ){set $output = concat( ', ', $output )}{/if}{set $output = concat( $output, $opt_item.name )}{/if}{/foreach}
                                    {$output}
                                    {undef $output}
                                {/case}
                            {/switch}
                        {/case}   /*Options*/
                        {case match="imageoptions"}
                            {switch match=$item.option_type}
                                {case match="checkbox"}
                                    {foreach $item.option_array as $opt_key => $opt_item}
                                        {if $opt_item.def}{$opt_item.name}, {/if}
                                    {/foreach}
                                {/case}  /*checkbox*/
                                {case match="radio"}
                                    {foreach $item.option_array as $opt_key => $opt_item}
                                        {if $opt_item.def}{$opt_item.name}{/if}
                                    {/foreach}
                                {/case}  /*Radio*/
                            {/switch}   
                        {/case}/*Bild Options*/
                        {case match="number"}{$item.def}{/case}
                        {case match="telephonenumber"}{$item.def}{/case}
                        {case match="text"}{$item.def}{/case}
                        {case}{$item.def}{/case}
                    {/switch}
                </td>
            </tr>
        {/if}
        {/foreach}
        </tbody>
    </table>
{/if}
</div>
{/if}
<p><a href={$node.parent.url|ezurl}>{'Return to site'|i18n('design/ezwebin/collectedinfo/form')}</a></p>
</div>