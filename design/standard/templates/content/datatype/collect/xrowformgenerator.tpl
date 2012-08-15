{ezcss_require( array( 'xrowformgenerator.css' ) )}

{def $content=$attribute.content
     $id=$attribute.id}

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
                    <label for="checkbox"><input type="checkbox" name="XrowFormInput[{$id}][{$key}]" value="1" {if $item.def}checked="checked" {/if}/> &nbsp;{$item.name|wash}{if $item.req}<a title={"Input required"|i18n( 'xrowformgenerator/kernel/classes/datatypes' )}> ({"required"|i18n( 'xrowformgenerator/mail' )})</a>{/if}</label>
                    <div class="form-checkbox-padding">{cond( is_set( $item.desc ), $item.desc, '')}</div>
                {/case}
                {case match="text"}
                    <label for="text"=>{$item.name|wash}{if $item.req}<a title={"Input required"|i18n( 'xrowformgenerator/kernel/classes/datatypes' )}> ({"required"|i18n( 'xrowformgenerator/mail' )})</a>{/if}</label>
                    <textarea cols="70" rows="10" name="XrowFormInput[{$id}][{$key}]" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}">{$item.def|wash}</textarea>
                    <span>{cond( is_set( $item.desc ), $item.desc, '')}</span>
                {/case}
                {case match="upload"}
                    <label for="upload">{$item.name|wash}{if $item.req}<a title={"Input required"|i18n( 'xrowformgenerator/kernel/classes/datatypes' )}> ({"required"|i18n( 'xrowformgenerator/mail' )})</a>{/if}</label>
                    <input type="file" class="file_input_div"  name="XrowFormInputFile_{$id}_{$key}" value="" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" /><br/>
                    <span>{cond( is_set( $item.desc ), $item.desc, '')}</span>

                {/case}
                {case match="options"}
                    <label for="options">{$item.name|wash}{if $item.req}<a title={"Input required"|i18n( 'xrowformgenerator/kernel/classes/datatypes' )}> ({"required"|i18n( 'xrowformgenerator/mail' )})</a>{/if}</label>

                    {switch match=$item.option_type}
                        {case match="checkbox"}
                            {foreach $item.option_array as $opt_key => $opt_item}
                                <span class="radio_button">
                                   <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="checkbox" name="XrowFormInput[{$id}][{$key}][{$opt_key}]" id="XrowFormInput[{$id}][{$key}][{$opt_key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} />
                                </span>
                                <span>
                                   <label class="black_label" for="XrowFormInput[{$id}][{$key}][{$opt_key}]">{$opt_item.name|wash}</label>
                                </span>
                            {/foreach}
                        {/case}
                        {case match="radio"}
                            {foreach $item.option_array as $opt_key => $opt_item}
                                <span class="radio_button">
                                    <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="radio" name="XrowFormInput[{$id}][{$key}]" id="XrowFormInput{$id}{$key}{$opt_key}" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} />
                                </span>
                                <span>
                                    <label class="black_label" for="XrowFormInput{$id}{$key}{$opt_key}">{$opt_item.name|wash}</label>            
                                </span>
                            {/foreach}
                        {/case}
                        {case match="select-one"}
                            <select class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" name="XrowFormInput[{$id}][{$key}][]">
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
                        {case /}
                    {/switch}

                   <span class="option_bes">{cond( is_set( $item.desc ), $item.desc, '')}</span>

                {/case}
                {case match="imageoptions"}
                    <label for="imageoptions">{$item.name|wash}{if $item.req}<a title={"Input required"|i18n( 'xrowformgenerator/kernel/classes/datatypes' )}> ({"required"|i18n( 'xrowformgenerator/mail' )})</a>{/if}</label>
                    <div class="block">
                    {switch match=$item.option_type}
                        {case match="checkbox"}
                            {foreach $item.option_array as $opt_key => $opt_item}
                            <div class="element xrow-image-opt-ele">
                                <label class="xrow-image-options">
                                <div class="che"> <input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="checkbox" name="XrowFormInput[{$id}][{$key}][{$opt_key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /></div>
                                <div class="img">{def $tempimg=fetch( 'content', 'node', hash( 'node_id', $opt_item.image ) )}
                                {if $tempimg}
                                {foreach $tempimg.data_map as $ditem}
                                    {if and( $ditem.data_type_string|eq( 'ezimage' ), $ditem.has_content )}
                                    {attribute_view_gui attribute=$ditem image_class="gallery_90"}
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
                                    <label class="xrow-image-options">
                                    
                                    <div class="che"><input class="xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" type="radio" name="XrowFormInput[{$id}][{$key}]" value="{$opt_item.name|wash}" {if $opt_item.def}checked="checked" {/if} /></div>
                                     <div class="img">{def $tempimg=fetch( 'content', 'node', hash( 'node_id', $opt_item.image ) )}
                                    {if $tempimg}
                                    {foreach $tempimg.data_map as $ditem}
                                        {if and( $ditem.data_type_string|eq( 'ezimage' ), $ditem.has_content )}
                                        {attribute_view_gui attribute=$ditem image_class="gallery_90"}
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

                        {case /}
                    {/switch}
                    </div>
                    <div class="break"></div>
                    
                   <span class="desc_eingabe_bild">{cond( is_set( $item.desc ), $item.desc, '')}</span>
                  
                {/case}
                {case match="number"}
                    <label for="number">{$item.name|wash}{if $item.req}<a title={"Input required"|i18n( 'xrowformgenerator/kernel/classes/datatypes' )}> ({"required"|i18n( 'xrowformgenerator/mail' )})</a>{/if}</label>
                    <input type="text" name="XrowFormInput[{$id}][{$key}]" value="{$item.def|wash}" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" /><br/>
                    <span></span>{cond( is_set( $item.desc ), $item.desc, '')}</span>
                {/case}
                {case match="hidden"}
                    <input type="hidden" class="formhidden" name="XrowFormInput[{$id}][{$key}]" value="{$item.def|wash}" />

                {/case}
                {case match="spacer"}
                    <div class="xrow-form-spacer"></div>

                {/case}
                {case match="desc"}
                    <div class="xrow-form-desc">{cond( is_set( $item.desc ), $item.desc, '')}</div>

                {/case}
                {case}
                    <label for="description">{$item.name|wash}{if $item.req}<a title={"Input required"|i18n( 'xrowformgenerator/kernel/classes/datatypes' )}> ({"required"|i18n( 'xrowformgenerator/mail' )})</a>{/if}</label>
                    <input type="text" name="XrowFormInput[{$id}][{$key}]" value="{$item.def|wash}" class="box xrow-form-{$item.type}{cond( $item.class|ne(''), concat( ' ', $item.class ), '')}" />
                    <span>{cond( is_set( $item.desc ), $item.desc, '')}</span>
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
{/if}


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
            
                <div class="content-action">
                    <input id="nosubmit" type="submit" class="defaultbutton" name="ActionCollectInformation" value="{"Send form"|i18n("design/base")}" style="visibility:hidden" />
                    <div id="noScriptPrompt">{"Javascript must be enabled to submit this form."|i18n("design/base")}</div>
                    <input type="hidden" name="ContentNodeID" value="{$attribute.object.main_node_id}" />
                    <input type="hidden" name="ContentObjectID" value="{$attribute.contentobject_id}" />
                    <input type="hidden" name="ViewMode" value="full" />
                </div>
            </form>
{undef}

</div>