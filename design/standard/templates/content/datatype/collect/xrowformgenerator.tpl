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
        <form method="post" enctype="multipart/form-data" action={"xrowform/actionform"|ezurl}>
            <ol class="xrow-form xrow-form-{$attribute.object.class_identifier} xrow-form-{$id}">
            {foreach $content.form_elements as $key => $item}
                <li class="xrow-form-element xrow-form-{$item.type} xrow-form-element-{$key}{if $item.error} xrow-form-error{/if}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}">
                    {switch match=$item.type}
                        {case match="checkbox"}
                            {include uri='design:content/datatype/fields.tpl' 
                                     fieldType=$item.type
                                     autocompleteOff=true()}
                        {/case}
                        {case match="text"}
                            {include uri='design:content/datatype/fields.tpl' 
                                     fieldType='textarea'
                                     cssClass=concat("box xrow-form-", $item.type, cond( $item.class|ne(''), concat( ' ', $item.class ), ''))
                                     cols=70
                                     rows=10
                                     autocompleteOff=true()}
                        {/case}
                        {case match="country"}
                            {include uri='design:content/datatype/fields.tpl' 
                                     fieldType=$item.type
                                     autocompleteOff=true()}
                        {/case}
                        {case match="upload"}
                            {include uri='design:content/datatype/fields.tpl' 
                                     fieldType=$item.type
                                     cssClass=concat("file_input_div box xrow-form-", $item.type, cond($item.class|ne(''), concat(' ', $item.class), ''))}
                        {/case}
                        {case match="options"}
                            {switch match=$item.option_type}
                                {case match="checkbox"}
                                    {include uri='design:content/datatype/fields.tpl' 
                                             fieldType=$item.type
                                             underFieldType=$item.option_type
                                             autocompleteOff=true()
                                             cssClass=concat("xrow-form-", $item.type, cond( $item.class|ne(''), concat( ' ', $item.class ), ''))}
                                {/case}
                                {case match="radio"}
                                    {include uri='design:content/datatype/fields.tpl' 
                                             fieldType=$item.type
                                             underFieldType=$item.option_type
                                             autocompleteOff=true()
                                             cssClass=concat("xrow-form-", $item.type, cond( $item.class|ne(''), concat( ' ', $item.class ), ''))}
                                {/case}
                                {case match="select-one"}
                                    {include uri='design:content/datatype/fields.tpl' 
                                             fieldType=$item.type
                                             underFieldType=$item.option_type
                                             startWithEmptyValue=true()
                                             autocompleteOff=true()
                                             cssClass=concat("xrow-form-", $item.type, cond( $item.class|ne(''), concat( ' ', $item.class ), ''))}
                                {/case}
                                {case match="select-all"}
                                    {include uri='design:content/datatype/fields.tpl' 
                                             fieldType=$item.type
                                             underFieldType=$item.option_type
                                             size=4
                                             multiple=true()
                                             autocompleteOff=true()
                                             cssClass=concat('xrow-form-', $item.type, cond($item.class|ne(''), concat(' ', $item.class), ''))}
                                {/case}
                            {/switch}
                        {/case}
                        {case match="imageoptions"}
                            {include uri='design:content/datatype/fields.tpl'
                                     fieldType=$item.type
                                     underFieldType=$item.option_type
                                     autocompleteOff=true()
                                     cssClass=concat('xrow-form-', $item.type, cond($item.class|ne(''), concat(' ', $item.class), ''))}
                        {/case}
                        {case match="number"}
                            {include uri='design:content/datatype/fields.tpl'
                                     fieldType=$item.type
                                     autocompleteOff=true()
                                     validate=$item.val
                                     cssClass=concat("box xrow-form-", $item.type, cond( $item.class|ne(''), concat( ' ', $item.class ), ''))}
                        {/case}
                        {case match="telephonenumber"}
                            {include uri='design:content/datatype/fields.tpl'
                                     fieldType=$item.type
                                     autocompleteOff=true()
                                     validate=$item.val
                                     cssClass=concat("box xrow-form-", $item.type, cond( $item.class|ne(''), concat( ' ', $item.class ), ''))}
                        {/case}
                        {case match="hidden"}
                            <input type="{$item.type}" class="formhidden" name="XrowFormInput[{$id}][{$key}]" value="{$item.def|wash}" />
                        {/case}
                        {case match="spacer"}
                            <div class="xrow-form-spacer"></div>
                        {/case}
                        {case match="desc"}
                            {if and(is_set($item.desc), $item.desc|ne(''))}<p class="xrow-form-desc">{$item.desc}</p>{/if}
                        {/case}
                        {case match="email"}
                            {include uri='design:content/datatype/fields.tpl' 
                                     fieldType=$item.type
                                     autocompleteOff=true()
                                     validate=$item.val
                                     cssClass=concat("box xrow-form-", $item.type, cond( $item.class|ne(''), concat( ' ', $item.class ), ''))}
                        {/case}
                        {case}
                            {if and( $item.type|contains( 'crmfield:' ), $crmIsEnabled )}
                                {include uri='design:content/datatype/collect/xrowformcrmfielditem.tpl'}
                            {else}
                                {include uri='design:content/datatype/fields.tpl' 
                                         fieldType='text'
                                         autocompleteOff=true()
                                         cssClass=concat("box xrow-form-", $item.type, cond( $item.class|ne(''), concat( ' ', $item.class ), ''))}
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