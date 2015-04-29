{def $inputArray = array('text', 'number', 'email', 'telephonenumber')
     $optionsArray = array('options','imageoptions')
     $optionsSelectArray = array('select-one', 'select-all')
     $optionsCheckboxRadioArray = array('checkbox', 'radio')
     $cssClassDescription = 'input_desc'
     $itemName = $item.name|wash
     $loadFieldCheck = cond(and(ezini_hasvariable('Settings', 'LoadFieldCheck', 'xrowformgenerator.ini'), ezini('Settings', 'LoadFieldCheck', 'xrowformgenerator.ini')|eq('disabled')), false(), true())}
{if is_set($itemNameOverwrite)}{set $itemName = $itemNameOverwrite}{/if}
{switch match=$fieldType}
    {case match="text"}
        {if ezini_hasvariable( 'PatternSetting', 'InputText', 'xrowformgenerator.ini' )}
            {def $pattern = ezini( 'PatternSetting', 'InputText', 'xrowformgenerator.ini' )}
        {/if}
    {/case}
    {case match="number"}
        {if ezini_hasvariable( 'PatternSetting', 'InputNumber', 'xrowformgenerator.ini' )}
            {def $pattern = ezini( 'PatternSetting', 'InputNumber', 'xrowformgenerator.ini' )}
        {/if}
    {/case}
    {case match="email"}
        {if ezini_hasvariable( 'PatternSetting', 'InputEmail', 'xrowformgenerator.ini' )}
            {def $pattern = ezini( 'PatternSetting', 'InputEmail', 'xrowformgenerator.ini' )}
        {else}
            {def $pattern = ezini( 'Settings', 'EmailDefaultPattern', 'xrowformgenerator.ini' )}
        {/if}
    {/case}
    {case match="telephonenumber"}
        {if ezini_hasvariable( 'Settings', 'TelephoneNumberPattern', 'xrowformgenerator.ini' )}
            {def $pattern = ezini( 'Settings', 'TelephoneNumberPattern', 'xrowformgenerator.ini' )}
        {else}
            {def $areaCodes = ezini( 'Settings', 'TelephoneAreaCodes', 'xrowformgenerator.ini' )
                 $defaultPattern = ezini( 'Settings', 'TelephoneDefaultPattern', 'xrowformgenerator.ini' )
                 $pattern = concat( '/^\+(', $areaCodes, ')[ |]?', $defaultPattern, '/' )}
        {/if}
    {/case}
    {case}{/case}
{/switch}

{if or($inputArray|contains($fieldType), $optionsArray|contains($fieldType), $fieldType|eq('textarea'), 
       $fieldType|eq('upload'), $fieldType|eq('country'))}
    {* LABEL ON/OFF *}
    {if or(is_set($labelOff)|not(), and(is_set($labelOff), $labelOff|not()))}
        <label for="{$fieldType}:{if is_set($underFieldType)}{$underFieldType}:{/if}{$id}:{$key}"{if or($item.error, and(is_set($item_tmp_error), $item_tmp_error))} class="xrow-form-label-error"{/if}>
            {$itemName}<abbr id="abbr{$fieldType}{if is_set($underFieldType)}{$underFieldType}{/if}{$id}{$key}"{if $item.req} class="required"{/if} title="{if $item.req}{'Input required.'|i18n( 'kernel/classes/datatypes' )}{/if}"></abbr>
        </label>
    {/if}
    {* INPUT TEXT|NUMBER|EMAIL|TELEPHONENUMBER *}
    {if $inputArray|contains($fieldType)}
        <input id="{$fieldType}:{$id}:{$key}" name="{if is_set($overwriteNameValue)}{$overwriteNameValue}{else}XrowFormInput[{$id}][{$key}]{/if}" type="{if $fieldType|eq('telephonenumber')}tel{else}{$fieldType}{/if}"
                                              {if $content.has_error|not()}{if or(and(and(is_set($labelOff), $labelOff), $item.def|eq('')), $item.def|ne(''))} placeholder="{if $item.def|eq('')}{$itemName}{else}{$item.def|wash}{/if}{if and($item.req, is_set($labelOff), $labelOff)} *{/if}" {/if}
                                              {else} value="{$item.def|wash}" 
                                              {/if}
                                              class="{if and(is_set($pattern), $loadFieldCheck)}onloadCheckFieldType {/if}{if is_set($cssClass)}{$cssClass}{/if}"
                                              {if is_set($pattern)} pattern="{$pattern|format_pattern}"
                                                {if and(is_set($invalidText), $invalidText|ne(''))}data-invalidtext="{$invalidText}"{/if}
                                              {/if}
                                              {if and($item.req, $loadFieldCheck)} required
                                                {if and(is_set($emptyText), $emptyText|ne(''))}data-emptytext="{$emptyText}"{/if}
                                              {/if}
                                              {if is_set($autocompleteOff)} autocomplete="off"{/if}
                                              {if is_set($item.min)} min="{$item.min}"{/if} 
                                              {if is_set($item.max)} max="{$item.max}"{/if}
                                              {if is_set($item.step)} step="{$item.step}"{/if} />
    {* OPTIONS *}
    {elseif $fieldType|eq('options')}
        {set $cssClassDescription = concat($fieldType, '_desc')}
        {* SELECT ONE|SELECT MULTI *}
        {if is_set($underFieldType)}
            {if $optionsSelectArray|contains($underFieldType)}
                <select id="{$fieldType}{$underFieldType}:{$id}:{$key}" name="{if is_set($overwriteNameValue)}{$overwriteNameValue}{else}XrowFormInput[{$id}][{$key}]{/if}"
                                                                        {if and($item.req, $loadFieldCheck)} required class="onloadCheckFieldType{if is_set($cssClass)} {$cssClass}{/if}"
                                                                            {if and(is_set($emptyText), $emptyText|ne(''))}data-emptytext="{$emptyText}"{/if}
                                                                        {elseif is_set($cssClass)} class="{$cssClass}"{/if}
                                                                        {if is_set($size)} size="{$size}"{/if}
                                                                        {if is_set($multiple)}  multiple="multiple"{/if}>
                    {if and(is_set($labelOff), $labelOff)}
                    <option value="" class="optionDisabled">{$itemName}{if $item.req} *{/if}</option>
                    {elseif is_set($startWithEmptyValue)}
                    <option value="0"></option>
                    {/if}
                    {foreach $item.option_array as $opt_key => $opt_item}
                    <option value="{$opt_item.name|wash}"{if $opt_item.def} selected="selected"{/if} title="{$opt_item.name|wash}">{$opt_item.name|wash}</option>
                    {/foreach}
                </select>
            {* CHECKBOX|RADIO *}
            {elseif $optionsCheckboxRadioArray|contains($underFieldType)}
                <ul class="options_{$underFieldType}">
                    {foreach $item.option_array as $opt_key => $opt_item}
                        <li>
                            <span class="radio_button">
                               <input id="{$fieldType}{$underFieldType}:{$id}:{$key}:{$opt_key}" name="XrowFormInput[{$id}][{$key}]{if $underFieldType|eq('checkbox')}[{$opt_key}]{/if}"
                                                                                                 type="{$underFieldType}"
                                                                                                 value="{$opt_item.name|wash}"
                                                                                                 {if and($item.req, $loadFieldCheck)} required{/if}
                                                                                                 {if is_set($autocompleteOff)} autocomplete="off"{/if}
                                                                                                 {if $opt_item.def}checked="checked" {/if}
                                                                                                 {if is_set($cssClass)} class="{$cssClass}"{/if} />
                            </span>
                            <span class="radio_label">
                               <label class="black_label" for="{$fieldType}{$underFieldType}:{$id}:{$key}:{$opt_key}">{$opt_item.name|wash}</label>
                            </span>
                        </li>
                    {/foreach}
                </ul>
            {/if}
        {/if}
    {* OPTIONS WITH IMAGES *}
    {elseif $fieldType|eq('imageoptions')}
        {set $cssClassDescription = 'desc_eingabe_bild'}
        {* SELECT ONE|SELECT MULTI *}
        {if is_set($underFieldType)}
        <div class="block">
            {foreach $item.option_array as $opt_key => $opt_item}
            <div class="element">
                <div class="che">
                    <input id="{$fieldType}{$underFieldType}:{$id}:{$key}:{$opt_key}" name="XrowFormInput[{$id}][{$key}]{if $fieldType|eq('checkbox')}[{$opt_key}]{/if}"
                                                                                      type="{$underFieldType}"
                                                                                      {if is_set($cssClass)} class="{$cssClass}"{/if}
                                                                                      {if is_set($autocompleteOff)} autocomplete="off"{/if}
                                                                                      value="{$opt_item.name|wash}"
                                                                                      {if $opt_item.def}checked="checked" {/if} />
                </div>
                {def $tempimg = fetch('content', 'node', hash('node_id', $opt_item.image))}
                {if $tempimg}
                <div class="img">
                    {foreach $tempimg.data_map as $ditem}
                        {if and($ditem.data_type_string|eq('ezimage'), $ditem.has_content)}
                        {attribute_view_gui attribute=$ditem image_class="small"}
                        {break}
                        {/if}
                    {/foreach}
                </div>
                {/if}
                {undef $tempimg}
                <div class="bes">&nbsp;{$opt_item.name|wash}</div>
            </div>
            {delimiter modulo=3}<div class="break"></div>{/delimiter}
            {/foreach}
        </div>
        <div class="break"></div>
        {/if}
    {* TEXTAREA *}
    {elseif $fieldType|eq('textarea')}
        <textarea id="{$fieldType}:{$id}:{$key}" name="{if is_set($overwriteNameValue)}{$overwriteNameValue}{else}XrowFormInput[{$id}][{$key}]{/if}" 
                                                 {if and($item.req, $loadFieldCheck)} required{/if}
                                                 class="{if $loadFieldCheck}onloadCheckFieldType {/if}{if is_set($cssClass)}{$cssClass}{/if}"
                                                 {if is_set($pattern)} pattern="{$pattern|format_pattern}"{/if}
                                                 {if and($item.req, is_set($emptyText), $emptyText|ne(''))}data-emptytext="{$emptyText}"{/if}
                                                 {if and(is_set($pattern), is_set($invalidText), $invalidText|ne(''))}data-invalidtext="{$invalidText}"{/if}
                                                 {if is_set($cols)} cols="{$cols}"{/if}
                                                 {if is_set($rows)} rows="{$rows}"{/if}
                                                 {if $content.has_error|not()}{if or(and(and(is_set($labelOff), $labelOff), $item.def|eq('')), $item.def|ne(''))} placeholder="{if $item.def|eq('')}{$itemName}{else}{$item.def|wash}{/if}{if $item.req} *{/if}" {/if}>{else}>{$item.def|wash}{/if}</textarea>
    {* UPLOAD *}
    {elseif $fieldType|eq('upload')}
        <input id="{$fieldType}:{$id}:{$key}" name="XrowFormInputFile_{$id}_{$key}"
                                              type="file"
                                              {if and($item.req, $loadFieldCheck)} required{/if}
                                              value=""
                                              {if is_set($cssClass)} class="{$cssClass}"{/if} />
    {* COUNTRY *}
    {elseif $fieldType|eq('country')}
        {set $cssClassDescription = 'options'}
        {if is_set($countries)|not()}{def $countries=fetch('content', 'country_list')}{/if}
        <input id="{$fieldType}:{$id}:{$key}" value="{if and( is_set( $item.def ), $item.def|ne('') )}{$item.def}{/if}" type="hidden" name="XrowFormInput[{$id}][{$key}]" />
        <select id="select_{$id}_{$key}" {if and($item.req, $loadFieldCheck)} required{/if}
                                         class="field_half{if and($item.req, $loadFieldCheck)} onloadCheckFieldType{/if}"
                                         {if and(is_set($emptyText), $emptyText|ne(''))}data-emptytext="{$emptyText}"{/if}
                                         onchange="$('input[name=\'XrowFormInput[{$id}][{$key}]\']').val($('#select_{$id}_{$key} option:selected').text());">
            {if and(is_set($labelOff), $labelOff)}
                <option value="" class="optionDisabled">{$itemName}{if $item.req} *{/if}</option>
            {else}
                <option value=""></option>
            {/if}
            {foreach $countries as $country_list_item}
            <option value="{$country_list_item.Name}"{if and(is_set($item.def), $item.def|eq($country_list_item.Name))} selected{/if}>{$country_list_item.Name}</option>
            {/foreach}
        </select>
    {/if}
{* CHECKBOX *}
{elseif $fieldType|eq('checkbox')}
    {if or(is_set($labelOff)|not(), and(is_set($labelOff), $labelOff|not()))}
        <label for="{$fieldType}:{$id}:{$key}"{if $itemName|eq('')} class="emptyname"{/if}>
    {/if}
        <input id="{$fieldType}:{$id}:{$key}" name="{if is_set($overwriteNameValue)}{$overwriteNameValue}{else}XrowFormInput[{$id}][{$key}]{/if}"
                                              type="{$fieldType}"
                                              value="1"
                                              {if and($item.req, $loadFieldCheck)} required class="onloadCheckFieldType{if $itemName|eq('')} xrow-form-checkbox-emptyname{/if}"
                                                {if and(is_set($emptyText), $emptyText|ne(''))}data-emptytext="{$emptyText}"{/if}
                                              {elseif $itemName|eq('')} class="xrow-form-checkbox-emptyname"{/if}
                                              {if is_set($autocompleteOff)} autocomplete="off"{/if}
                                              {if $item.def} checked="checked"{/if}
                                               />
        {if $itemName|ne('')} &nbsp;{$itemName}<abbr id="abbr{$fieldType}{$id}{$key}"{if $item.req} class="required"{/if} title="{if $item.req}{'Input required.'|i18n( 'kernel/classes/datatypes' )}{/if}"></abbr>{/if}
    {if or(is_set($labelOff)|not(), and(is_set($labelOff), $labelOff|not()))}</label>{/if}
    {if and(is_set($item.desc), $item.desc|ne(''))}
        <div class="form-checkbox-padding{if $itemName|eq('')} emptyname{/if}">
            {$item.desc}{if or($itemName|eq(''), and(is_set($labelOff), $labelOff))}<abbr id="abbr{$fieldType}{$id}{$key}"{if $item.req} class="required"{/if} title="{if $item.req}{'Input required.'|i18n( 'kernel/classes/datatypes' )}{/if}"></abbr>{/if}
        </div>
    {/if}
{/if}
{if and(is_set($item.desc), $item.desc|ne(''), $fieldType|ne('checkbox'))}<p class="{$cssClassDescription}">{$item.desc}</p>{/if}
{undef}