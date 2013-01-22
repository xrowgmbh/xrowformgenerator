{ezscript_require( array( 'yahoo-dom-event/yahoo-dom-event.js', 'xrowformgenerator.js' ) )}
{ezcss_require( array( 'xrowformgenerator.css' ) )}

{def $content=$attribute.content
     $id=$attribute.id}

{if ezini( 'ExtensionSettings', 'ActiveExtensions', 'site.ini' )|contains( 'xrowcaptcha' )}
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
    <input type="checkbox" name="XrowFormAnzeige{$id}" value="1"{if and( is_set( $content.show_anzeige ), $content.show_anzeige )} checked="checked"{/if} /> {"Display Data After Submit"|i18n( 'xrowformgenerator/edit' )}
</label>

<div class="block ezcca-edit-datatype-ezstring ezcca-edit-receiver">
    <label>{"Receiver(separate multiple Emails with a semicolon)"|i18n( 'xrowformgenerator/edit' )}</label>
    <input type="text" class="box" name="XrowFormReceiver{$id}" value="{$content.receiver}" />
</div>

<div class="block ezcca-edit-datatype-ezstring ezcca-edit-subject">
    <label>{"Subject"|i18n( 'xrowformgenerator/edit' )}</label>
    <input type="text" class="box" name="XrowFormSubject{$id}" value="{$content.subject}" />
</div>

<div class="block ezcca-edit-datatype-ezemail ezcca-edit-sender">
    <label>{"Sender"|i18n( 'xrowformgenerator/edit' )}</label>
    <input type="text" class="box" name="XrowFormSender{$id}" value="{$content.sender}" />
</div>

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

    <ol class="xrow-form-list hidden" id="xrow-form-list-{$id}">
{* string *}
        <li class="xrow-form-element xrow-form-element-string" id="xrow-form-element-string-{$id}">
            <fieldset>
                <legend>{"String input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[yyyxrowindexyyy]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="string" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
                        </div>
                        <div class="block">
                            <label>{"Default value"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]" value="yyyxrowdefyyy" />
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
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
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
{* hidden field *}
        <li class="xrow-form-element xrow-form-element-hidden" id="xrow-form-element-hidden-{$id}">
            <fieldset>
                <legend>{"Hidden input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[yyyxrowindexyyy]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="hidden" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
                        </div>
                        <div class="block">
                            <label>{"Value"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]" value="yyyxrowdefyyy" />
                        </div>
                        <div class="block">
                            <label>{"Description"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <textarea class="box" rows="2" cols="70" name="x1XrowFormElementDesc{$id}[yyyxrowindexyyy]">yyyxrowdescyyy</textarea>
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
{* text *}
        <li class="xrow-form-element xrow-form-element-text" id="xrow-form-element-text-{$id}">
            <fieldset>
                <legend>{"Text input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="text" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
                        </div>
                        <div class="block">
                            <label>{"Default value"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <textarea class="box" rows="3" cols="70" name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]"></textarea>
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
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* number *}
        <li class="xrow-form-element xrow-form-element-number" id="xrow-form-element-number-{$id}">
            <fieldset>
                <legend>{"Number input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="number" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
                        </div>
                        <div class="block">
                            <label>{"Default value"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]" value="yyyxrowdefyyy" />
                        </div>
                        <div class="block">
                            <label>{"Description"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <textarea class="box" rows="2" cols="70" name="x1XrowFormElementDesc{$id}[yyyxrowindexyyy]">yyyxrowdescyyy</textarea>
                        </div>

                        <div class="block inline">
                            <label><input class="xrow-form-element-required" name="x1XrowFormElementReq{$id}[yyyxrowindexyyy]" value="yyyxrowreqyyy" title="{"Use this checkbox if the input of this form field is required."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Required"|i18n( 'xrowformgenerator/edit' )}
                            </label>
                            <label><input class="xrow-form-element-validation" name="x1XrowFormElementVal{$id}[yyyxrowindexyyy]" value="yyyxrowvalyyy" title="{"Use this checkbox if the input of this form field should be validated."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Input requires validation"|i18n( 'xrowformgenerator/edit' )}
                            </label>
                        </div>
                    </div>
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* checkbox *}
        <li class="xrow-form-element xrow-form-element-checkbox"  id="xrow-form-element-checkbox-{$id}">
            <fieldset>
                <legend>{"Checkbox input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="checkbox" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
                        </div>
                        <div class="block">
                            <label>{"Default value"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]" value="yyyxrowdefyyy" title="{"Use this checkbox if the checkbox should be selected by default."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />
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
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* email *}
        <li class="xrow-form-element xrow-form-element-email" id="xrow-form-element-email-{$id}">
            <fieldset>
                <legend>{"Email input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="email" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
                        </div>
                        <div class="block">
                            <label>{"Default value"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementDefault{$id}[yyyxrowindexyyy]" value="yyyxrowdefyyy" />
                        </div>
                        <div class="block">
                            <label>{"Description"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <textarea class="box" rows="2" cols="70" name="x1XrowFormElementDesc{$id}[yyyxrowindexyyy]">yyyxrowdescyyy</textarea>
                        </div>
                        <div class="block inline">
                            <label><input class="xrow-form-element-required" name="x1XrowFormElementReq{$id}[yyyxrowindexyyy]" value="yyyxrowreqyyy" title="{"Use this checkbox if the input of this form field is required."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Required"|i18n( 'xrowformgenerator/edit' )}
                            </label>
                            <label><input class="xrow-form-element-validation" name="x1XrowFormElementVal{$id}[yyyxrowindexyyy]" value="yyyxrowvalyyy" title="{"Use this checkbox if the input of this form field should be validated."|i18n( 'xrowformgenerator/edit' )}" type="checkbox" />{"Input requires validation"|i18n( 'xrowformgenerator/edit' )}
                            </label>
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
                <legend>{"Options input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="options" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
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
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* upload *}
        <li class="xrow-form-element xrow-form-element-upload" id="xrow-form-element-upload-{$id}">
            <fieldset>
                <legend>{"Upload input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[]" value="yyyxrowindexyyy" />
                        <input type="hidden" name="x1XrowFormElementType{$id}[yyyxrowindexyyy]" value="upload" />
                        <div class="block">
                            <label>{"Name"|i18n( 'xrowformgenerator/edit' )}:</label>
                            <input class="box" type="text" name="x1XrowFormElementName{$id}[yyyxrowindexyyy]" value="yyyxrownameyyy" />
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
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
{* options with image *}
        <li class="xrow-form-element xrow-form-element-options" id="xrow-form-element-imageoptions-{$id}">
            <fieldset>
                <legend>{"Options with image input field"|i18n( 'xrowformgenerator/edit' )}</legend>
                <div class="block">
                    <div class="element xrow-trash-width"><img class="xrow-form-element-trash-button" src={"trash-icon-16x16.gif"|ezimage} alt="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}"  title="{"Delete form element."|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" /></div>
                    <div class="element xrow-form-element-width">
                        <input type="hidden" name="x1XrowFormElementArray{$id}[]" value="yyyxrowindexyyy" />
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
                    <div class="element xrow-move-width"><img class="xrow-element-button-up" src={"button-move_up.gif"|ezimage} alt="{"Move up"|i18n( 'xrowformgenerator/edit' )}"  title="{"Move up"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" />&nbsp;<img class="xrow-element-button-down" src={"button-move_down.gif"|ezimage} alt="{"Move down"|i18n( 'xrowformgenerator/edit' )}" width="16" height="16" title="{"Move down"|i18n( 'xrowformgenerator/edit' )}" /></div>
                </div>
                <div class="break"></div>
            </fieldset>
        </li>
    </ol>

<script type="text/javascript">
    var xrow_index_{$id}_y = 0;
</script>

<ol id="xrow-form-container-{$id}" class="xrow-form-container"></ol>
{if $content.form_elements|count|gt(0)}
<script type="text/javascript">
<!--
{foreach $content.form_elements as $key => $item}

    var xrow_form_{$id}_{$key} = {$item.json};
    {switch match=$item.type}
        {case match='options'}
            xrow_index_{$id}_y = xrow_add_form_options( 'xrow-form-element-{$item.type}-{$id}', 'xrow-form-container-{$id}', '{$id}', xrow_index_{$id}_y, xrow_form_{$id}_{$key}, 'xrow-options-tpl-{$id}', 'XrowOptionList_{$id}_' );
        {/case}
        {case match='imageoptions'}
            xrow_index_{$id}_y = xrow_add_form_options( 'xrow-form-element-{$item.type}-{$id}', 'xrow-form-container-{$id}', '{$id}', xrow_index_{$id}_y, xrow_form_{$id}_{$key}, 'xrow-imageoptions-tpl-{$id}', 'XrowOptionList_{$id}_' );
        {/case}
        {case}
            xrow_index_{$id}_y = xrow_add_form_default( 'xrow-form-element-{$item.type}-{$id}', 'xrow-form-container-{$id}', '{$id}', xrow_index_{$id}_y, xrow_form_{$id}_{$key}, '{$item.type}' );
        {/case}
    {/switch}
{/foreach}
//-->
</script>
{/if}
<div class="block">
    <label>{"Add a form field"|i18n( 'xrowformgenerator/edit' )}
        <select name="xrow-add-form-element-name-{$id}" id="xrow-add-form-element-id-{$id}">
            <option value="string">{"string"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="text">{"text"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="number">{"number"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="checkbox">{"checkbox"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="options">{"options"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="imageoptions">{"options with image"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="email">{"email"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="upload">{"upload"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="hidden">{"hidden"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="spacer">{"spacer"|i18n( 'xrowformgenerator/edit' )}</option>
            <option value="desc">{"description"|i18n( 'xrowformgenerator/edit' )}</option>
        </select>
        <button class="button" name="XrowAddElementButton{$id}" onclick="xrow_index_{$id}_y = xrow_add_form_element( 'xrow-add-form-element-id-{$id}', 'xrow-form-container-{$id}', xrow_index_{$id}_y, '{$id}', {ldelim}name: ''{rdelim} ); return false;" value="{"Add element"|i18n( 'xrowformgenerator/edit' )}" title="{"Add a new form element"|i18n( 'xrowformgenerator/edit' )}">{"Add element"|i18n( 'xrowformgenerator/edit' )}</button>
    </label>
</div>



