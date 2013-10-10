{def $content=$attribute.content
     $id=$attribute.id}

<div class="xrow-form-full">
<form action="/content/action" enctype="multipart/form-data" method="post">
{if $content.form_elements|count|eq(0)}
    <p>{"No form fields defined."|i18n( 'xrowformgenerator/edit' )}</p>
{else}
    {if $content.has_error}
        <div class="xrow-form-error">
            <p>{"One ore more errors at the input occured. Please correct the input of the fields which are marked red."|i18n( 'xrowformgenerator/edit' )}</p>
            {if $content.error_array|count}
            <ul>
            {foreach $content.error_array as $error}
                 <li>{$error|wash}</li>
            {/foreach}
            </ul>
            {/if}
        </div>
    {/if}
    <ol class="xrow-form xrow-form-{$attribute.object.class_identifier} xrow-form-{$id}">
        {foreach $content.form_elements as $key => $item}
            <li class="xrow-form-element xrow-form-{$item.type} xrow-form-element-{$key}{if $item.error} xrow-form-error{/if}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}">
    
                {switch match=$item.type}
                    {case match="checkbox"}
                        <label><input type="checkbox" name="XrowFormInput[{$id}][{$key}]" value="1" {if $item.def}checked="checked" {/if}/> &nbsp;{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> ({"required"|i18n( 'xrowformgenerator/mail' )})</abbr>{/if}</label>
                        <div class="form-checkbox-padding">{cond( is_set( $item.desc ), $item.desc, '')}</div>
                    {/case}
                    {case match="text"}
                        <label>{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> ({"required"|i18n( 'xrowformgenerator/mail' )})</abbr>{/if}</label>
                        <textarea cols="70" rows="10" name="XrowFormInput[{$id}][{$key}]" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}">{$item.def|wash}</textarea>
                        {cond( is_set( $item.desc ), $item.desc, '')}
                    {/case}
                    {case match="upload"}
                        <label>{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> ({"required"|i18n( 'xrowformgenerator/mail' )})</abbr>{/if}</label>
                        <input type="file" name="XrowFormInputFile_{$id}_{$key}" value="" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" />
                        {cond( is_set( $item.desc ), $item.desc, '')}
    
                    {/case}
                    {case match="options"}
                        <label>{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> ({"required"|i18n( 'xrowformgenerator/mail' )})</abbr>{/if}</label>
    
                        {switch match=$item.option_type}
                            {case match="checkbox"}
                                {foreach $item.option_array as $opt_key => $opt_item}
                                    <label>
                                    <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="checkbox" name="XrowFormInput[{$id}][{$key}][{$opt_key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /> &nbsp;{$opt_item.name|wash}</label>
                                {/foreach}
                            {/case}
                            {case match="radio"}
                                {foreach $item.option_array as $opt_key => $opt_item}
                                    <label><input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="radio" name="XrowFormInput[{$id}][{$key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /> &nbsp;{$opt_item.name|wash}</label>
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
    
                        {cond( is_set( $item.desc ), $item.desc, '')}
    
                    {/case}
                    {case match="imageoptions"}
                        <label>{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> ({"required"|i18n( 'xrowformgenerator/mail' )})</abbr>{/if}</label>
                        <div class="block">
                        {switch match=$item.option_type}
                            {case match="checkbox"}
                                {foreach $item.option_array as $opt_key => $opt_item}
                                <div class="element xrow-image-opt-ele">
                                    <label class="xrow-image-options">
                                    {def $tempimg=fetch( 'content', 'node', hash( 'node_id', $opt_item.image ) )}
                                    {if $tempimg}
                                    {foreach $tempimg.data_map as $ditem}
                                        {if and( $ditem.data_type_string|eq( 'ezimage' ), $ditem.has_content )}
                                        {attribute_view_gui attribute=$ditem image_class="small_2"}<br />
                                        {break}
                                        {/if}
                                    {/foreach}
                                    {/if}
                                    {undef $tempimg}
                                    <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="checkbox" name="XrowFormInput[{$id}][{$key}][{$opt_key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /> &nbsp;{$opt_item.name|wash}</label>
    
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
                                            {attribute_view_gui attribute=$ditem image_class="small_2"}<br />
                                            {break}
                                            {/if}
                                        {/foreach}
                                        {/if}
                                        {undef $tempimg}
                                        <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="radio" name="XrowFormInput[{$id}][{$key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /> &nbsp;{$opt_item.name|wash}
    
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
                        <label>{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> ({"required"|i18n( 'xrowformgenerator/mail' )})</abbr>{/if}</label>
                        <input type="text" name="XrowFormInput[{$id}][{$key}]" value="{$item.def|wash}" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" />
                        {cond( is_set( $item.desc ), $item.desc, '')}
                    {/case}
                    {case match="telephonenumber"}
                        <label>{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> ({"required"|i18n( 'xrowformgenerator/mail' )})</abbr>{/if}</label>
                        <input type="tel" name="XrowFormInput[{$id}][{$key}]" value="{$item.def|wash}" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" />
                        {cond( is_set( $item.desc ), $item.desc, '')}
                    {/case}
                    {case match="hidden"}
                        <input type="hidden" class="formhidden" name="XrowFormInput[{$id}][{$key}]" value="{$item.def|wash}" />
    
                    {/case}
                    {case match="spacer"}
                        <hr class="xrow-form-spacer" />
    
                    {/case}
                    {case match="desc"}
                        <div class="xrow-form-desc">{cond( is_set( $item.desc ), $item.desc, '')}</div>
    
                    {/case}
                    {case}
                        <label>{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> ({"required"|i18n( 'xrowformgenerator/mail' )})</abbr>{/if}</label>
                        <input type="text" name="XrowFormInput[{$id}][{$key}]" value="{$item.def|wash}" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" />
                        {cond( is_set( $item.desc ), $item.desc, '')}
                    {/case}
                {/switch}
                {* we need to do this because some idiot defined nice styles for all input fields ... *}
                <div class="hiddenbox">
                    <input class="formhidden" type="hidden" name="XrowFormInputArray[{$id}][]" value="{$key}" />
                    <input class="formhidden" type="hidden" name="XrowFormInputType[{$id}][{$key}]" value="{$item.type}" />
                </div>
            </li>
        {/foreach}
    </ol>
    <p class=formsmall">{"Please fill out the form. The input of fields which are marked with a asterisk (*) is required."|i18n( 'xrowformgenerator/edit' )}</p>
    {if $content.use_captcha}
        {set-block scope=global variable=cache_ttl}0{/set-block}
        <p>{"Please insert the signs of the image below"|i18n("design/base")}:</p>
        <div class="block_spam">
            <img src={ezhumancaptcha_image()|ezroot()} alt="eZHumanCAPTCHACode" />
            {default attribute_base=ContentObjectAttribute}
            <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier} text" type="text" size="10" name="{$attribute_base}_data_text_{$attribute.id}" value="" />
            {/default}
        </div>
    {/if}
{/if}
{undef}
</form>
</div>