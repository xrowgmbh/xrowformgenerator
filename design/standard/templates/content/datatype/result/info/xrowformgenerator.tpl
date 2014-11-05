{def $content = $attribute.content
     $id = $attribute.id
     $crmIsEnabled = false()}
{if and( ezini_hasvariable( 'Settings', 'UseCRM', 'xrowformgenerator.ini' ), ezini( 'Settings', 'UseCRM', 'xrowformgenerator.ini' )|eq( 'enabled' ) )}
    {set $crmIsEnabled = true()}
{/if}
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
    {if $content.has_error}
        <p>{"One ore more errors at the input occured. Please correct the input of the fields which are marked red."|i18n( 'xrowformgenerator/edit' )}</p>
        {if $content.error_array|count}
        <ul>
        {foreach $content.error_array as $error}
             <li>{$error|wash}</li>
        {/foreach}
        </ul>
        {/if}
    {/if}
    <ol class="xrow-form xrow-form-{$attribute.contentobject_attribute.contentclass_attribute_identifier} xrow-form-{$id}">
    {foreach $content.form_elements as $key => $item}
        <li class="xrow-form-element xrow-form-{$item.type} xrow-form-element-{$key}{if $item.error} xrow-form-error{/if}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}">
        {if and( $item.type|contains( 'crmfield:' ), $crmIsEnabled )}
            {include uri='design:content/datatype/result/info/xrowformcrmfielditem.tpl'}
        {else}
            {switch match=$item.type}
                {case match="checkbox"}
                    <label><input type="checkbox" name="XrowFormInput[{$id}][{$key}]" value="1" {if $item.def}checked="checked" {/if}/> {$item.name|wash}{if $item.req}*{/if}</label>
                {/case}
                {case match="text"}
                    <label>{$item.name|wash}{if $item.req}*{/if}</label>
                    <p>{$item.def|wash|nl2br}</p>

                {/case}
                {case match="upload"}
                    <label>{$item.name|wash}{if $item.req}*{/if}</label>
                    <p>{$item.def}</p>

                {/case}
                {case match="options"}
                    <label>{$item.name|wash}{if $item.req}*{/if}</label>

                    {switch match=$item.option_type}
                        {case match="checkbox"}
                            {foreach $item.option_array as $opt_key => $opt_item}
                                <label>
                                <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="checkbox" name="XrowFormInput[{$id}][{$key}][{$opt_key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /> {$opt_item.name|wash}</label>
                            {/foreach}
                        {/case}
                        {case match="radio"}
                            {foreach $item.option_array as $opt_key => $opt_item}
                                <label><input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="radio" name="XrowFormInput[{$id}][{$key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /> {$opt_item.name|wash}</label>
                            {/foreach}
                        {/case}
                        {case match="select-one"}
                            <select class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" name="XrowFormInput[{$id}][{$key}][]">
                            {foreach $item.option_array as $opt_key => $opt_item}
                                <option value="{$opt_item.name|wash}"{if $opt_item.def} selected="selected"{/if}>{$opt_item.name|wash}</option>
                            {/foreach}
                            </select>
                        {/case}
                        {case match="select-all"}
                            <select class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" name="XrowFormInput[{$id}][{$key}][]" size="10" multiple="multiple">
                            {foreach $item.option_array as $opt_key => $opt_item}
                                <option value="{$opt_item.name|wash}"{if $opt_item.def} selected="selected"{/if}>{$opt_item.name|wash}</option>
                            {/foreach}
                            </select>
                        {/case}
                        {case /}
                    {/switch}

                    <br />

                {/case}
                {case match="imageoptions"}
                    <label>{$item.name|wash}{if $item.req}*{/if}</label>
                    <div class="block">
                    {switch match=$item.option_type}
                        {case match="checkbox"}
                            {foreach $item.option_array as $opt_key => $opt_item}
                            <div class="element">
                                <label class="xrow-image-options">
                                {def $tempimg=fetch( 'content', 'node', hash( 'node_id', $opt_item.image ) )}
                                {if $tempimg}
                                {foreach $tempimg.data_map as $ditem}
                                    {if and( $ditem.data_type_string|eq( 'ezimage' ), $ditem.has_content )}
                                    {attribute_view_gui attribute=$ditem image_class="small"}<br />
                                    {break}
                                    {/if}
                                {/foreach}
                                {/if}
                                {undef $tempimg}
                                <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="checkbox" name="XrowFormInput[{$id}][{$key}][{$opt_key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /> {$opt_item.name|wash}</label>

                            </div>
                            {delimiter modulo=3}<div class="break"></div>{/delimiter}
                            {/foreach}
                        {/case}
                        {case match="radio"}
                            {foreach $item.option_array as $opt_key => $opt_item}
                                <div class="element">
                                    <label class="xrow-image-options">
                                    {def $tempimg=fetch( 'content', 'node', hash( 'node_id', $opt_item.image ) )}
                                    {if $tempimg}
                                    {foreach $tempimg.data_map as $ditem}
                                        {if and( $ditem.data_type_string|eq( 'ezimage' ), $ditem.has_content )}
                                        {attribute_view_gui attribute=$ditem image_class="small"}<br />
                                        {break}
                                        {/if}
                                    {/foreach}
                                    {/if}
                                    {undef $tempimg}
                                    <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="radio" name="XrowFormInput[{$id}][{$key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /> {$opt_item.name|wash}

                                    </label>
                                </div>
                                {delimiter modulo=3}<div class="break"></div>{/delimiter}
                            {/foreach}
                        {/case}

                        {case /}
                    {/switch}
                    </div>
                    <div class="break"></div>

                    {cond( is_set( $item.desc ), $item.desc, '')}

                {/case}
                {case match="number"}
                    <label>{$item.name|wash}{if $item.req}*{/if}</label>
                    <p>{$item.def|wash}</p>
                {/case}
                {case match="telephonenumber"}
                    <label>{$item.name|wash}{if $item.req}*{/if}</label>
                    <p>{$item.def|wash}</p>
                {/case}
                {case match="hidden"}
                    <label>{$item.name|wash}{if $item.req}*{/if}</label>
                    <p>{$item.def|wash}</p>
                {/case}
                {case match="spacer"}
                    <div class="xrow-form-spacer"></div>
                {/case}
                {case match="desc"}
                    <div class="xrow-form-desc"></div>
                {/case}
                {case}
                    <label>{$item.name|wash}{if $item.req}*{/if}</label>
                    <p>{$item.def|wash}</p>
                {/case}
            {/switch}
        {/if}
        </li>
    {/foreach}
    </ol>
{/if}
</div>