{def $content = $attribute.content
     $id = $attribute.id
     $crmIsEnabled = false()}
{if and( ezini_hasvariable( 'Settings', 'UseCRM', 'xrowformgenerator.ini' ), ezini( 'Settings', 'UseCRM', 'xrowformgenerator.ini' )|eq( 'enabled' ) )}
    {set $crmIsEnabled = true()}
{/if}
{ezscript_require( array( 'yahoo-dom-event/yahoo-dom-event.js', 'xrowformgenerator_backend.js', 'json2.js' ) )}
{if and( ezini_hasvariable( 'Settings', 'ShowCaptchaAlways', 'xrowformgenerator.ini' ), ezini( 'Settings', 'ShowCaptchaAlways', 'xrowformgenerator.ini' )|eq("true"), ezini( 'ExtensionSettings', 'ActiveExtensions', 'site.ini' )|contains( 'xrowcaptcha' ) )}
    <label>
        <input type="checkbox" name="XrowFormCaptcha{$id}" value="1" disabled="true" checked="checked"/> {"Form is using a captcha"|i18n( 'xrowformgenerator/edit' )} (* {"Captcha is automatically applied to all forms."|i18n( 'xrowformgenerator/edit' )} )
    </label>
{else}
    <label>
        <input type="checkbox" name="XrowFormCaptcha{$id}" value="1" {if $content.use_captcha} checked="checked"{/if} /> {"Form is using a captcha"|i18n( 'xrowformgenerator/edit' )}
    </label>
{/if}

<label>
    <input type="checkbox" name="XrowFormAmount{$id}" value="1"{if and( is_set( $content.show_amount ), $content.show_amount )} checked="checked"{/if} /> {"Show the amount of forms in the mail"|i18n( 'xrowformgenerator/edit' )}
</label>

<label>
    <input type="checkbox" name="XrowFormAnzeige{$id}" value="1"{if and( is_set( $content.show_anzeige ), $content.show_anzeige )} checked="checked"{/if} /> {"Display data after submit"|i18n( 'xrowformgenerator/edit' )}
</label>

<label>
    <input type="checkbox" name="XrowFormOptin{$id}" value="1"{if and( is_set( $content.optin ), $content.optin )} checked="checked"{/if} /> {"Double Opt-in"|i18n( 'xrowformgenerator/edit' )}
</label>

<div class="block ezcca-edit-datatype-ezstring ezcca-edit-receiver">
    <label>{"Receiver (separate multiple emails with a semicolon)"|i18n( 'xrowformgenerator/mail' )}</label>
    <input type="text" class="box" name="XrowFormReceiver{$id}" value="{$content.receiver}" />
</div>

<div class="block ezcca-edit-datatype-ezstring ezcca-edit-subject">
    <label>{"Subject"|i18n( 'xrowformgenerator/mail' )}</label>
    <input type="text" class="box" name="XrowFormSubject{$id}" value="{$content.subject}" />
</div>

<div class="block ezcca-edit-datatype-ezemail ezcca-edit-sender">
    <label>{"Sender"|i18n( 'xrowformgenerator/mail' )} <abbr style="font-weight: normal" title="{"Please note that if the sender e-mail domain differs from the server domain, some recipients will block them as spam. In that case, ensure that it is allow for the 'foreign' mailing server to send e-mails for your domain (SPF Records)."|i18n( 'xrowformgenerator/mail' )}">(<u>?</u>)</abbr></label>
    <input type="text" class="box" name="XrowFormSender{$id}" value="{$content.sender}" />
</div>

<div class="block ezcca-edit-datatype-ezstring ezcca-edit-button">
    <label>{"Changing default text on button"|i18n( 'xrowformgenerator/edit' )}</label>
    <input type="text" class="box" name="XrowFormButton{$id}" value="{$content.button_text}" />
</div>

{if $crmIsEnabled}
    {def $campaigns = get_campaigns()}
    {if $campaigns|count|gt( 0 )}
    {def $crmFields = get_crmfields()}
    {include uri='design:content/datatype/edit/xrowformcrmfieldreplace.tpl'}
    <input type="hidden" value="enabled" name="crmIsEnabled" />
    <div class="block ezcca-edit-datatype-ezstring ezcca-edit-button">
        <label>{"Select a campaign"|i18n( 'xrowformgenerator/edit' )}:
            <select class="xrow-form-element-option-type" name="XrowCampaignID{$id}">
                <option value="0"></option>
            {if is_set( $campaigns.optiongroups )}
                {foreach $campaigns.optiongroups as $optiongroups}
                    <optgroup label="{$optiongroups.optiongroupname}">
                    {foreach $optiongroups.campaigns as $campaignID => $campaignName}
                        <option value="{$campaignID}"{if $content.campaign_id|eq( $campaignID )} selected="selected"{/if}>{$campaignName}</option>
                    {/foreach}
                    </optgroup>
                {/foreach}
            {else}
                {foreach $campaigns as $campaignID => $campaignName}
                <option value="{$campaignID}"{if $content.campaign_id|eq( $campaignID )} selected="selected"{/if}>{$campaignName}</option>
                {/foreach}
            {/if}
            </select>
        </label>
    </div>
    {else}
    <div class="block ezcca-edit-datatype-ezstring ezcca-edit-button">{"There are no campain ids in your CRM"|i18n( 'xrowformgenerator/edit' )}</div>
    {/if}
{/if}

{* options list tpl *}
<div class="hidden">
    <div id="xrow-options-tpl-{$id}">
        <label><img class="xrow-option-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete option"|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete option"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />
        {"Option"|i18n( 'xrowformgenerator/edit' )}:
            <input type="hidden" name="x1XrowFormElementOptionArray{$id}[yyyxrowindexyyy][]" value="zzzxrowindexzzz" />
            <input class="halfbox" type="text" name="x1XrowFormElementOption{$id}[yyyxrowindexyyy][zzzxrowindexzzz]" value="zzzxrowoptionnamezzz" />

            <input class="xrow-option-default-button" type="checkbox" name="x1XrowFormElementOptionDefault{$id}[yyyxrowindexyyy][zzzxrowindexzzz]" value="zzzxrowindexzzz" title="{"Click here to select this value by default"|i18n( 'xrowformgenerator/edit' )}" /> {"Default value"|i18n( 'xrowformgenerator/edit' )}
            <img class="xrow-option-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-option-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" />
        </label>
    </div>
</div>

{* imageoptions list tpl *}
<div class="hidden">
    <div id="xrow-imageoptions-tpl-{$id}">
        <div class="block">
            <div class="element">
                <img class="xrow-option-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete option"|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete option"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />
            </div>
            <div class="element"><img src={"1x1.gif"|ezimage} alt="" border="0" id="x1XrowOptionImage{$id}_yyyxrowindexyyy_zzzxrowindexzzz" width="100" height="1"/><br /><input type="submit" class="button xrow-add-option-image" name="CustomActionButton[{$id}_Yyyxrowindexyyy_zzzxrowindexzzz_browse]" value="{"Select image"|i18n( 'xrowformgenerator/edit' )}" /></div>
            <div class="element" style="width:50%;"><label>{"Option"|i18n( 'xrowformgenerator/edit' )}:</label>
                <input type="hidden" name="x1XrowFormElementOptionArray{$id}[yyyxrowindexyyy][]" value="zzzxrowindexzzz" />
                <textarea class="box" cols="30" rows="3" name="x1XrowFormElementOption{$id}[yyyxrowindexyyy][zzzxrowindexzzz]">zzzxrowoptionnamezzz</textarea>
            </div>
            <div class="element">
                <input class="xrow-option-default-button" type="checkbox" name="x1XrowFormElementOptionDefault{$id}[yyyxrowindexyyy][zzzxrowindexzzz]" value="zzzxrowindexzzz" title="{"Click here to select this value by default"|i18n( 'xrowformgenerator/edit' )}" /> {"Default value"|i18n( 'xrowformgenerator/edit' )}
            </div>
            <div class="element">
                <img class="xrow-option-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-option-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" />
            </div>
            <input type="hidden" name="x1XrowFormElementOptionImageArray{$id}[yyyxrowindexyyy][zzzxrowindexzzz]" value="zzzxrowoptionimagezzz" />
        </div>
        <div class="break"></div>
    </div>
</div>

{* options: default: true|false, description: true|false, required: true|false, validation: true|false, unique: true|false, min: true, max: true, step: true*}
{def $types = hash( 'string', hash( 'name', 'String input field', 'default', true(), 'required', true() ),
                    'email', hash( 'name', 'Email input field', 'default', true(), 'required', true(), 'unique', true(), 'validation', true() ),
                    'text', hash( 'name', 'Text input field', 'default', true(), 'required', true() ),
                    'telephonenumber', hash( 'name', 'Telephone number input field', 'default', true(), 'required', true(), 'validation', true() ),
                    'number', hash( 'name', 'Number input field', 'default', true(), 'required', true(), 'validation', true(), 'min', true(), 'max', true(), 'step', true() ),
                    'upload', hash( 'name', 'Upload input field', 'required', true() ),
                    'country', hash( 'name', 'Country select dropdown', 'required', true() ),
                    'checkbox', hash( 'name', 'Checkbox', 'default', true(), 'required', true() ),
                    'options', hash( 'name', 'Options' ),
                    'imageoptions', hash( 'name', 'Options with image' ),
                    'desc', hash( 'name', 'Description' ),
                    'spacer', hash( 'name', 'Spacer' ),
                    'hidden', hash( 'name', 'Hidden field' ) )}

    <ol class="xrow-form-list hidden" id="xrow-form-list-{$id}">
        {foreach $types as $type => $typeElements}
        {if and($type|ne('options'), $type|ne('imageoptions'), $type|ne('description'), $type|ne('spacer'))}
        <li class="xrow-form-element xrow-form-element-{$type}" id="xrow-form-element-{$type}-{$id}">
            <fieldset>
                <legend>{$typeElements.name|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[yyyxrowindexyyy]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="{$type}" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
                        </div>
                        {if and( is_set( $typeElements.default ), $typeElements.default )}
                        <div class="block">
                            <label>{"Default value"|i18n( 'xrowformgenerator/edit' )}:</label>
                            {if $type|eq( 'text' )}
                            <textarea class="box" rows="3" cols="70" name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]">yyyxrowdefyyy</textarea>
                            {elseif $type|eq( 'checkbox' )}
                            <input name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]" value="yyyxrowdefyyy" title="{"Use this checkbox if the checkbox should be selected by default."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />
                            {else}
                            <input class="box" type="text" name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]" value="yyyxrowdefyyy" />
                            {/if}
                        </div>
                        {/if}
                        {if or( and( is_set( $typeElements.min ), $typeElements.min ), and( is_set( $typeElements.max ), $typeElements.max ), and( is_set( $typeElements.step ), $typeElements.step ) )}
                        <div class="block">
                            {if and( is_set( $typeElements.min ), $typeElements.min )}<label>{"Min"|i18n( 'xrowformgenerator/edit' )}:</label><input class="box" type="text" name="x1XrowFormElementMin{$id}[yyyxrowindexyyy]" value="yyyxrowminyyy" />{/if}
                            {if and( is_set( $typeElements.max ), $typeElements.max )}<label>{"Max"|i18n( 'xrowformgenerator/edit' )}:</label><input class="box" type="text" name="x1XrowFormElementMax{$id}[yyyxrowindexyyy]" value="yyyxrowmaxyyy" />{/if}
                            {if and( is_set( $typeElements.step ), $typeElements.step )}<label>{"Step"|i18n( 'xrowformgenerator/edit' )}:</label><input class="box" type="text" name="x1XrowFormElementStep{$id}[yyyxrowindexyyy]" value="yyyxrowstepyyy" />{/if}
                        </div>
                        {/if}
                        {if or( is_set( $typeElements.description )|not(), and( is_set( $typeElements.description ), $typeElements.description ) )}
                        <div class="block">
                            <label>{"Description"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <textarea class="box" rows="2" cols="70" name="x1XrowFormElementDesc{$id}[yyyxrowindexyyy]">yyyxrowdescyyy</textarea>
                        </div>
                        {/if}
                        {if or( and( is_set( $typeElements.required ), $typeElements.required ), and( is_set( $typeElements.validation ), $typeElements.validation ), and( is_set( $typeElements.unique ), $typeElements.unique ) )}
                        <div class="block inline">
                            {if and( is_set( $typeElements.required ), $typeElements.required )}<label><input class="xrow-form-element-required" name="x1XrowFormElementReq{$id}[yyyxrowindexyyy]" value="yyyxrowreqyyy" title="{"Use this checkbox if the input of this form field is required."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Required"|i18n( 'xrowformgenerator/edit' )}</label>{/if}
                            {if and( is_set( $typeElements.unique ), $typeElements.unique )}<label><input class="xrow-form-element-unique" name="x1XrowFormElementUnique{$id}[yyyxrowindexyyy]" value="yyyxrowuniqueyyy" title="{"Unique"|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Unique"|i18n( 'xrowformgenerator/edit' )}</label>{/if}
                            {if and( is_set( $typeElements.validation ), $typeElements.validation )}<label><input class="xrow-form-element-validation" name="x1XrowFormElementVal{$id}[yyyxrowindexyyy]" value="yyyxrowvalyyy" title="{"Use this checkbox if the input of this form field should be validated."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Input requires validation"|i18n( 'xrowformgenerator/edit' )}</label>{/if}
                        </div>
                        {/if}
                    </div>
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
        {/if}
        {/foreach}
{* description *}
        <li class="xrow-form-element xrow-form-element-desc" id="xrow-form-element-desc-{$id}">
            <fieldset>
                <legend>{"Description input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[yyyxrowindexyyy]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="desc" />
                        <div class="block">
                            <label>{"Description"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input type="hidden" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="" />
                            <input type="hidden" name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]" value="" />
                            <textarea class="box" rows="5" cols="70" name="x1XrowFormElementDesc{$id}[yyyxrowindexyyy]">yyyxrowdescyyy</textarea>
                        </div>
                    </div>
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* spacer *}
        <li class="xrow-form-element xrow-form-element-spacer" id="xrow-form-element-spacer-{$id}">
            <fieldset>
                <legend>{"Spacer"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[yyyxrowindexyyy]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="spacer" />
                        <div class="block">
                            <p>{"Spacer"|i18n( 'xrowformgenerator/edit' )}</p>
                        </div>
                    </div>
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* options *}
        <li class="xrow-form-element xrow-form-element-options" id="xrow-form-element-options-{$id}">
            <fieldset>
                <legend>{"Options"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[yyyxrowindexyyy]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="options" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" id="x1XrowFormElementName{$id}[yyyxrowindexyyy]" />
                        </div>
                        <div class="block">
                            <label>{"Choose option type"|i18n( 'xrowformgenerator/edit' )}:
                                <select class="xrow-form-element-option-type" id="x1XrowFormElementOptionID{$id}_yyyxrowindexyyy" name="x1XrowFormElementOptionType{$id}[yyyxrowindexyyy]" title="{"Choose how to display your option list in the form."|i18n( 'xrowformgenerator/edit' )}">
                                    <option value="radio">{"Radio button list - 1 option is choosable"|i18n( 'xrowformgenerator/edit' )}</option>
                                    <option value="checkbox">{"Checkbox list - all options are choosable"|i18n( 'xrowformgenerator/edit' )}</option>
                                    <option value="select-one">{"Select box - 1 option is choosable"|i18n( 'xrowformgenerator/edit' )}</option>
                                    <option value="select-all">{"Select box - all options are choosable"|i18n( 'xrowformgenerator/edit' )}</option>
                                </select>
                            </label>
                        </div>
                        <div class="block">
                            <ol class="xrow-option-list" id="x1XrowOptionList_{$id}_yyyxrowindexyyy"></ol>
                            <button class="button xrow-form-add-option-button" onclick="xrow_add_option( 'xrow-options-tpl-{$id}', 'XrowOptionList_{$id}_yyyxrowindexyyy', {ldelim}{rdelim} ); return false;" name="XrowAddOptionButton{$id}[]" value="{"Add option"|i18n( 'xrowformgenerator/edit' )}" title="{"A click on this button adds one option."|i18n( 'xrowformgenerator/edit' )}">{"Add option"|i18n( 'xrowformgenerator/edit' )}</button>
                        </div>
                        <div class="block">
                            <label>{"Description"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <textarea class="box" rows="2" cols="70" name="x1XrowFormElementDesc{$id}[yyyxrowindexyyy]">yyyxrowdescyyy</textarea>
                        </div>
                        <div class="block inline">
                            <label><input class="xrow-form-element-required" name="x1XrowFormElementReq{$id}[yyyxrowindexyyy]" value="yyyxrowreqyyy" title="{"Use this checkbox if the input of this form field is required."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Required"|i18n( 'xrowformgenerator/edit' )}
                            </label>
                        </div>
                    </div>
                    <div class="element xrow-move-width">
                        <img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;
                        <img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" />&nbsp;
                        {*<img class="xrow-element-button-copy" src={"2/icon-copy-16x16.png"|ezimage} alt="{"Copy"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Copy"|i18n( 'xrowformgenerator/edit' )}" />*}
                    </div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* options with image *}
        <li class="xrow-form-element xrow-form-element-options" id="xrow-form-element-imageoptions-{$id}">
            <fieldset>
                <legend>{"Options with image"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[yyyxrowindexyyy]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="imageoptions" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
                        </div>
                        <div class="block">
                            <label>{"Choose option type"|i18n( 'xrowformgenerator/edit' )}:
                                <select class="xrow-form-element-option-type" id="x1XrowFormElementOptionID{$id}_yyyxrowindexyyy" name="x1XrowFormElementOptionType{$id}[yyyxrowindexyyy]" title="{"Choose how to display your option list in the form."|i18n( 'xrowformgenerator/edit' )}">
                                    <option value="radio">{"Radio button list - 1 option is choosable"|i18n( 'xrowformgenerator/edit' )}</option>
                                    <option value="checkbox">{"Checkbox list - all options are choosable"|i18n( 'xrowformgenerator/edit' )}</option>
                                </select>
                            </label>
                        </div>
                        <div class="block">
                            <ol class="xrow-option-list" id="x1XrowOptionList_{$id}_yyyxrowindexyyy"></ol>
                            <button class="button xrow-form-add-option-button" onclick="xrow_add_option( 'xrow-imageoptions-tpl-{$id}', 'XrowOptionList_{$id}_yyyxrowindexyyy', {ldelim}{rdelim} ); return false;" name="XrowAddOptionButton{$id}[]" value="{"Add option"|i18n( 'xrowformgenerator/edit' )}" title="{"A click on this button adds one option."|i18n( 'xrowformgenerator/edit' )}">{"Add option"|i18n( 'xrowformgenerator/edit' )}</button>
                        </div>
                        <div class="block">
                            <label>{"Description"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <textarea class="box" rows="2" cols="70" name="x1XrowFormElementDesc{$id}[yyyxrowindexyyy]">yyyxrowdescyyy</textarea>
                        </div>
                        <div class="block inline">
                            <label><input class="xrow-form-element-required" name="x1XrowFormElementReq{$id}[yyyxrowindexyyy]" value="yyyxrowreqyyy" title="{"Use this checkbox if the input of this form field is required."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Required"|i18n( 'xrowformgenerator/edit' )}
                            </label>
                        </div>
                    </div>
                    <div class="element xrow-move-width">
                        <img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;
                        <img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" />
                    </div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* crm field *}
        {if $crmIsEnabled}
            {include uri='design:content/datatype/edit/xrowformcrmfielditem.tpl'}
        {/if}
    </ol>

<script type="text/javascript">
    var xrow_index_{$id}_y = 0;
</script>

<ol id="xrow-form-container-{$id}" class="xrow-form-container"></ol>
{if $content.form_elements|count|gt(0)}
<script type="text/javascript">
<!--
{foreach $content.form_elements as $key => $item}

    {if $item.type|contains( 'crmfield:' )}
    var jsonString = JSON.stringify({$item.json}),
        xrow_form_{$id}_{$key} = JSON.parse(jsonString);
    {else}
    var xrow_form_{$id}_{$key} = {$item.json},
        xrow_form_element = 'xrow-form-element-{$item.type}-{$id}';
    {/if}
    {switch match=$item.type}
        {case match='options'}
            xrow_add_form_options( xrow_form_element, 'xrow-form-container-{$id}', '{$id}', xrow_form_{$id}_{$key}, 'xrow-options-tpl-{$id}', 'XrowOptionList_{$id}_' );
        {/case}
        {case match='imageoptions'}
            xrow_add_form_options( xrow_form_element, 'xrow-form-container-{$id}', '{$id}', xrow_form_{$id}_{$key}, 'xrow-imageoptions-tpl-{$id}', 'XrowOptionList_{$id}_' );
        {/case}
        {case}
            {if $item.type|contains( 'crmfield:' )}
                if(typeof xrow_add_form_crm == 'function' && typeof document.getElementById('crmIsEnabled') != 'undefined'){ldelim}
                    var crmclass = 'Lead';
                    {if is_set( $item.crmclass )}
                        crmclass = '{$item.crmclass}';
                    {/if}
                    xrow_form_element = 'xrow-form-container-{$id}';
                    xrow_add_form_crm( xrow_form_element, '{$id}', xrow_form_{$id}_{$key}, '{$item.type}', crmclass, {$key}, {$attribute.version} );
                {rdelim}
                else
                    alert('Please add a custom function for the crm fields.');
            {else}
                xrow_add_form_default( xrow_form_element, 'xrow-form-container-{$id}', '{$id}', xrow_form_{$id}_{$key}, '{$item.type}' );
            {/if}
        {/case}
    {/switch}
{/foreach}
//-->
</script>
{/if}


<div class="block">
    <label>{"Add a form field"|i18n( 'xrowformgenerator/edit' )}
        <select name="xrow-add-form-element-name-{$id}" id="xrow-add-form-element-id-{$id}">
            {foreach $types as $type => $typeElements}
            <option value="{$type}">{$typeElements.name|i18n( 'xrowformgenerator/edit' )}</option>
            {/foreach}
            {if $crmIsEnabled}
                {include uri='design:content/datatype/edit/xrowformcrmfields.tpl'}
            {/if}
        </select>
        <button class="button" name="XrowAddElementButton{$id}" onclick="xrow_add_form_element('xrow-add-form-element-id-{$id}', 'xrow-form-container-{$id}', '{$id}', {ldelim}name: ''{rdelim} ); return false;" value="{"Add element"|i18n( 'xrowformgenerator/edit' )}" title="{"Add a new form element"|i18n( 'xrowformgenerator/edit' )}">{"Add element"|i18n( 'xrowformgenerator/edit' )}</button>
    </label>
</div>