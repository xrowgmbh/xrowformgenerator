{def $content = $attribute.content
     $id = $attribute.id
     $crmIsEnabled = false()}
{if and( ezini_hasvariable( 'Settings', 'UseCRM', 'xrowformgenerator.ini' ), ezini( 'Settings', 'UseCRM', 'xrowformgenerator.ini' )|eq( 'enabled' ) )}
    {set $crmIsEnabled = true()}
{/if}
{ezcss_require( array( 'xrowformgenerator.css' ) )}
<div class="xrow-form-full">
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
        <form method="post" enctype="multipart/form-data" action={"content/action"|ezurl}>
            <ol class="xrow-form xrow-form-{$attribute.object.class_identifier} xrow-form-{$id}">
            {foreach $content.form_elements as $key => $item}
                <li class="xrow-form-element xrow-form-{$item.type} xrow-form-element-{$key}{if $item.error} xrow-form-error{/if}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}">
                    {switch match=$item.type}
                        {case match="checkbox"}
                            <label for="checkbox:{$id}:{$key}"><input id="checkbox:{$id}:{$key}" type="checkbox" name="XrowFormInput[{$id}][{$key}]" value="1" autocomplete="off" {if $item.def}checked="checked" {/if}/> &nbsp;{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<div class="form-checkbox-padding">{$item.desc}</div>{/if}
                        {/case}
                        {case match="text"}
                            <label for="text:{$id}:{$key}">{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            <textarea cols="70" rows="10" id="text:{$id}:{$key}" name="XrowFormInput[{$id}][{$key}]" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" aria-required="true"  {if not($content.has_error)}placeholder="{$item.def|wash}">{else}>{$item.def|wash}{/if}</textarea>
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="input_desc">{$item.desc}</p>{/if}
                        {/case}
                        {case match="country"}
                            <label for="country:{$id}:{$key}">{$item.name|wash()}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            {if is_set( $countries )|not()}{def $countries = fetch( 'content', 'country_list' )}{/if}
                            <input id="country:{$id}:{$key}"{if and( is_set( $item.def ), $item.def|ne('') )} value="{$item.def}"{/if} type="hidden" autocomplete="off" name="XrowFormInput[{$id}][{$key}]" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" aria-required="true" value="" />
                            <select id="select_{$id}_{$key}" class="field_half" onchange="$('input[name=\'XrowFormInput[{$id}][{$key}]\']').val($('#select_{$id}_{$key} option:selected').text());">
                                <option value=""></option>
                                {foreach $countries as $country_list_item}
                                <option value="{$country_list_item.Alpha3}"{if and( is_set( $item.def ), $item.def|eq( $country_list_item.Name ) )} selected="selected"{/if} title="{$country_list_item.Name}">{$country_list_item.Name}</option>
                                {/foreach}
                            </select>
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="input_desc">{$item.desc}</p>{/if}
                        {/case}
                        {case match="upload"}
                            <label for="upload:{$id}:{$key}">{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            <input id="upload:{$id}:{$key}" type="file" class="file_input_div"  name="XrowFormInputFile_{$id}_{$key}" value="" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" aria-required="true" /><br/>
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="input_desc">{$item.desc}</p>{/if}
                        {/case}
                        {case match="options"}
                            <label class="options">{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            {switch match=$item.option_type}
                                {case match="checkbox"}
                                <ul class="options_checkbox">
                                    {foreach $item.option_array as $opt_key => $opt_item}
                                        <li>
                                            <span class="radio_button">
                                               <input id="options_chekbox:{$id}:{$key}:{$opt_key}" class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="checkbox" autocomplete="off" aria-required="true" name="XrowFormInput[{$id}][{$key}][{$opt_key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} />
                                            </span>
                                            <span class="radio_label">
                                               <label class="black_label" for="options_chekbox:{$id}:{$key}:{$opt_key}">{$opt_item.name|wash}</label>
                                            </span>
                                        </li>
                                    {/foreach}
                                </ul>
                                {/case}
                                {case match="radio"}
                                <ul class="options_radio">
                                    {foreach $item.option_array as $opt_key => $opt_item}
                                    <li>
                                        <span class="radio_button">
                                            <input id="options_radio:{$id}:{$key}:{$opt_key}" class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="radio" autocomplete="off" aria-required="true" name="XrowFormInput[{$id}][{$key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} />
                                        </span>
                                        <span class="options_label">
                                            <label class="black_label" for="options_radio:{$id}:{$key}:{$opt_key}">{$opt_item.name|wash}</label>
                                        </span>
                                    </li>
                                    {/foreach}
                                </ul>
                                {/case}
                                {case match="select-one"}
                                    <select class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" name="XrowFormInput[{$id}][{$key}][]">
                                        <option value="0"></option>
                                    {foreach $item.option_array as $opt_key => $opt_item}
                                        <option value="{$opt_item.name|wash}"{if $opt_item.def} selected="selected"{/if} title="{$opt_item.name|wash}">{$opt_item.name|wash}</option>
                                    {/foreach}
                                    </select>
                                {/case}
                                {case match="select-all"}
                                    <select id="xrow-form-bes" class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" name="XrowFormInput[{$id}][{$key}][]" size="4" multiple="multiple">
                                    {foreach $item.option_array as $opt_key => $opt_item}
                                        <option value="{$opt_item.name|wash}"{if $opt_item.def} selected="selected"{/if} title="{$opt_item.name|wash}">{$opt_item.name|wash}</option>
                                    {/foreach}
                                    </select>
                                {/case}
                            {/switch}
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="option_bes">{$item.desc}</p>{/if}
                        {/case}
                        {case match="imageoptions"}
                            <label>{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            <div class="block">
                            {switch match=$item.option_type}
                                {case match="checkbox"}
                                    {foreach $item.option_array as $opt_key => $opt_item}
                                    <div class="element xrow-image-opt-ele">
                                        <label for="imageoptions_checkbox:{$id}:{$key}:{$opt_key}" class="xrow-image-options">
                                        <div class="che"> <input id="imageoptions_checkbox:{$id}:{$key}:{$opt_key}" class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="checkbox" autocomplete="off" name="XrowFormInput[{$id}][{$key}][{$opt_key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /></div>
                                        <div class="img">{def $tempimg=fetch( 'content', 'node', hash( 'node_id', $opt_item.image ) )}
                                            {if $tempimg}
                                            {foreach $tempimg.data_map as $ditem}
                                                {if and( $ditem.data_type_string|eq( 'ezimage' ), $ditem.has_content )}
                                                {attribute_view_gui attribute=$ditem image_class="small"}
                                                {break}
                                                {/if}
                                            {/foreach}
                                            {/if}
                                            {undef $tempimg}
                                        </div>
                                        <div class="bes">&nbsp;{$opt_item.name|wash}</div>
                                        </label>
                                    </div>
                                    {delimiter modulo=3}<div class="break"></div>{/delimiter}
                                    {/foreach}
                                {/case}
                                {case match="radio"}
                                    {foreach $item.option_array as $opt_key => $opt_item}
                                        <div class="element">
                                            <label for="imageoptions_radio:{$id}:{$key}:{$opt_key}" class="xrow-image-options">
                                            <div class="che"><input id="imageoptions_radio:{$id}:{$key}:{$opt_key}" class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="radio" autocomplete="off" name="XrowFormInput[{$id}][{$key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /></div>
                                            <div class="img">{def $tempimg=fetch( 'content', 'node', hash( 'node_id', $opt_item.image ) )}
                                                {if $tempimg}
                                                {foreach $tempimg.data_map as $ditem}
                                                    {if and( $ditem.data_type_string|eq( 'ezimage' ), $ditem.has_content )}
                                                    {attribute_view_gui attribute=$ditem image_class="small"}
                                                    {break}
                                                    {/if}
                                                {/foreach}
                                                {/if}
                                                {undef $tempimg}
                                            </div>
                                            <div class="bes">&nbsp;{$opt_item.name|wash}</div>
                                            </label>
                                        </div>
                                        {delimiter modulo=3}<div class="break"></div>{/delimiter}
                                    {/foreach}
                                {/case}
                            {/switch}
                            </div>
                            <div class="break"></div>
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="desc_eingabe_bild">{$item.desc}</p>{/if}
                        {/case}
                        {case match="number"}
                            <label for="number:{$id}:{$key}">{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            <input id="number:{$id}:{$key}" type="number" autocomplete="off" name="XrowFormInput[{$id}][{$key}]" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" aria-required="true" min="{$item.min}" max="{$item.max}" step="{$item.step}"{if not($content.has_error)} placeholder="{$item.def|wash}"{else} value="{$item.def|wash}"{/if}{* pattern="[-+]?[0-9]*[.,]?[0-9]+"*} /><br/>
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="input_desc">{$item.desc}</p>{/if}
                        {/case}
                        {case match="telephonenumber"}
                            <label for="telephonenumber:{$id}:{$key}:number">{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            <input{if not( $content.has_error )} placeholder="{$item.def|wash}"{else} value="{if is_set( $item.def_error.number )}{$item.def_error.number|wash}{else}{$item.def|wash}{/if}"{/if} id="telephonenumber:{$id}:{$key}{if $countryCodeIsSet}:number{/if}" type="tel" autocomplete="off" name="XrowFormInput[{$id}][{$key}]{if $countryCodeIsSet}[number]{/if}" class="box xrow-form-{$item.type}{if $countryCodeIsSet}-right{/if}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" aria-required="true"{* pattern="^\+([1-9]){ldelim}1,4{rdelim}?[ |]?[1-9]{ldelim}1{rdelim}?(?:[0-9][ |]?){ldelim}4,14{rdelim}[0-9]$"*} /><br/>
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="input_desc">{$item.desc}</p>{/if}
                        {/case}
                        {case match="hidden"}
                            <input type="hidden" class="formhidden" name="XrowFormInput[{$id}][{$key}]" {if not( $content.has_error )} placeholder="{$item.def|wash}" {else} value="{$item.def|wash}" {/if} />
                        {/case}
                        {case match="spacer"}
                            <div class="xrow-form-spacer"></div>
                        {/case}
                        {case match="desc"}
                            <p class="xrow-form-desc">{cond( is_set( $item.desc ), $item.desc, '')}</p>
                        {/case}
                        {case match="email"}
                            <label for="email:{$id}:{$key}">{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                            <input id="email:{$id}:{$key}" type="email" autocomplete="off" name="XrowFormInput[{$id}][{$key}]" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" aria-required="true" {if not($content.has_error)} placeholder="{$item.def|wash}" {else} value="{$item.def|wash}" {/if} />
                            {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="input_desc">{$item.desc}</p>{/if}
                        {/case}
                        {case}
                            {if and( $item.type|contains( 'crmfield:' ), $crmIsEnabled )}
                                {include uri='design:content/datatype/collect/xrowformcrmfielditem.tpl'}
                            {else}
                                <label for="description:{$id}:{$key}">{$item.name|wash}{if $item.req}<abbr class="required" title="{"Input required."|i18n( 'kernel/classes/datatypes' )}"> * </abbr>{/if}</label>
                                <input id="description:{$id}:{$key}" type="text" autocomplete="off" name="XrowFormInput[{$id}][{$key}]" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" aria-required="true" {if not($content.has_error)} placeholder="{$item.def|wash}" {else} value="{$item.def|wash}" {/if} />
                                {if and( is_set( $item.desc ), $item.desc|ne( '' ) )}<p class="input_desc">{$item.desc}</p>{/if}
                            {/if}
                        {/case}
                    {/switch}
                    {* we need to do this because some idiot defined nice styles for all input fields ... *}
                    <div class="hiddenbox">
                        <input class="formhidden" type="hidden" name="XrowFormInputArray[{$id}][]" value="{$key}" />
                        <input class="formhidden" type="hidden" name="XrowFormInputType[{$id}][{$key}]" value="{$item.type}" />
                    </div>
                </li>
            {/foreach}
                {foreach $content.form_elements as $key => $item}
                    {if $item.req}
                        <li>
                            <p class="formsmall">{"Please fill out the form. The input of fields which are marked with a asterisk (*) is required."|i18n( 'xrowformgenerator/edit' )}</p>
                        </li>
                        {break}
                    {/if}
                {/foreach}
            </ol>

            {set-block scope=global variable=cache_ttl}0{/set-block}
            {if ezini_hasvariable("Settings", "Captcha", "xrowformgenerator.ini")}
                {if eq(ezini("Settings", "Captcha", "xrowformgenerator.ini"), 'xrowcaptcha')}
                    {if $content.use_captcha}
                        <div class="xrow-captcha"></div>
                    {/if}
                {elseif eq(ezini("Settings", "Captcha", "xrowformgenerator.ini"), 'recaptcha')}
                    {if $content.use_captcha}
                        <script type="text/javascript">
                            var RecaptchaTheme='{ezini( 'Display','Theme','recaptcha.ini' )}';
                            var RecaptchaLang='{ezini( 'Display','OverrideLang','recaptcha.ini' )}';
                            {literal}
                                var RecaptchaOptions = {
                                theme: RecaptchaTheme,
                                lang: RecaptchaLang
                                };
                            {/literal}
                        </script>
                        {recaptcha_get_html()}
                    {/if}
                {elseif eq(ezini("Settings", "Captcha", "xrowformgenerator.ini"), 'humancaptcha')}
                    {if $content.use_captcha}
                        {set-block scope=global variable=cache_ttl}0{/set-block}
                        <p>{"Please insert the signs of the image below"|i18n("design/base")}:</p>
                        <div class="block_spam">
                            <img src={ezhumancaptcha_image()|ezroot()} alt="eZHumanCAPTCHACode" />
                            {default attribute_base=ContentObjectAttribute}
                            <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier} text" type="text" autocomplete="off" size="10" name="{$attribute_base}_data_text_{$attribute.id}" value="" />
                            {/default}
                        </div>
                    {/if}
                {/if}
            {/if}

            <div class="content-action">
                <input id="nosubmit" type="submit" class="defaultbutton" name="ActionCollectInformation" {if $content.button_text|eq("") }value="{"Send form"|i18n("design/base")}"{else}value="{$content.button_text}"{/if} style="display:block" />
                <div id="noScriptPrompt" style="display:none">{"Javascript must be enabled to submit this form."|i18n("design/base")}</div>
                <input type="hidden" name="ContentNodeID" value="{$attribute.object.main_node_id}" />
                <input type="hidden" name="ContentObjectID" value="{$attribute.contentobject_id}" />
                <input type="hidden" name="ViewMode" value="full" />
            </div>
        </form>
    {/if}
    {undef}
</div>