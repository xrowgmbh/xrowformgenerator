{def $content = $attribute.content
     $id = $attribute.id
     $crmIsEnabled = false()}
{if and( ezini_hasvariable( 'Settings', 'UseCRM', 'xrowformgenerator.ini' ), ezini( 'Settings', 'UseCRM', 'xrowformgenerator.ini' )|eq( 'enabled' ) )}
    {set $crmIsEnabled = true()}
{/if}
{ezcss_require( array( 'xrowformgenerator.css' ) )}
<div class="xrow-form-full">

{if $content.use_captcha}
    <p>{"Using captcha for input."|i18n( 'xrowformgenerator/edit' )}</p>
{else}
    <p>{"No captcha for input."|i18n( 'xrowformgenerator/edit' )}</p>
{/if}
<p>{"No.:"|i18n( 'xrowformgenerator/mail' )} {$content.no}</p>

{if $crmIsEnabled}
    {if $content.campaign_id}
        {def $campaigns = get_campaigns()}
        {if $campaigns|count|gt( 0 )}
            {foreach $campaigns as $campaignID => $campaignName}
                {if $content.campaign_id|eq( $campaignID )}
                    <p>{"Campaign"|i18n( 'xrowformgenerator/edit' )}: {$campaignName}</p>
                    {break}
                {/if}
            {/foreach}
        {/if}
        {undef $campaigns}
    {/if}
{/if}

{if $content.form_elements|count|eq(0)}
    <p>{"No form fields defined."|i18n( 'xrowformgenerator/edit' )}</p>
{else}
    <ol class="xrow-form xrow-form-{$attribute.contentobject_attribute.contentclass_attribute_identifier} xrow-form-{$id}">
    {foreach $content.form_elements as $key => $item}
        <li class="xrow-form-element xrow-form-{$item.type} xrow-form-element-{$key}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}">
        {if and( $item.type|contains( 'crmfield:' ), $crmIsEnabled )}
            {include uri='design:content/datatype/result/info/xrowformcrmfielditem.tpl'}
        {else}
            {if $item.type|eq('spacer')}
            <div class="xrow-form-spacer"></div>
            {else}
                {if $item.name|trim|ne('')}<strong>{$item.name}{if $item.req}*{/if}:</strong>{elseif $item.type|eq('checkbox')}<strong>{if $item.def}{"Yes"|i18n( 'xrowformgenerator/mail' )}{else}{"No"|i18n( 'xrowformgenerator/mail' )}{/if}{if $item.req}*{/if}:</strong>{/if}
                {switch match=$item.type}
                      {case match="checkbox"}{if $item.desc|ne('')}{$item.desc|shorten(150, '...')|wash()}{/if}{/case}
                      {case match="upload"}{cond( is_set( $item.def ), $item.original_filename|wash() ,'' )}{/case}
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
                     {case match="hidden"}{$item.desc}{/case}
                     {case}{$item.def}{/case}
                {/switch}
            {/if}
        {/if}
        </li>
    {/foreach}
    </ol>
{/if}
</div>