jQuery(document).ready(function($){
    $("#nosubmit").show();
    $("#noScriptPrompt").hide();
    if($('.onloadCheckFieldType').length) {
        $('.onloadCheckFieldType').each(function() {
            var input = $(this)[0];
            if($(this).is("input")) {
                if($(this).attr("type") == 'checkbox' || $(this).attr("type") == 'radio') {
                    if(input.hasAttribute('data-emptytext') && input.validity.valueMissing)
                        input.setCustomValidity($(this).data('emptytext'));
                    $(this).click(function() {
                         checkFieldType(this);
                     });
                }
                else {
                    if(input.hasAttribute('data-emptytext') && $.trim($(this).val()) == '')
                        input.setCustomValidity($(this).data('emptytext'));
                    $(this).change(function() {
                        checkFieldType(this);
                    });
                }
            }
            else if($(this).is("select")) {
                if(input.hasAttribute('data-emptytext') && input.validity.valueMissing)
                    input.setCustomValidity($(this).data('emptytext'));
                $(this).change(function() {
                    checkFieldType(this);
                });
                if(input.hasAttribute('required') && $(this).val() != 0)
                    checkFieldType(this);
            }
        });
    }
    // required for safari
    $('.html5validation').submit(function (e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            $('[required]').each(function() {
                if($(this).val() == '')
                    $(this).parent().addClass('xrow-form-error');
            });
        } else {
            $(this).children().removeClass('xrow-form-error');
        }
    });
});

function checkFieldType(formField) {
    var field = $(formField),
        abbrId = field.attr('id').replace(/:/g, '')
        abbr = $('#abbr'+abbrId);
    if($.trim(field.val()) != '') {
        //window.console.log(field.is("input") + ' :: ' + field.attr("type"));
        //window.console.log(formField.validity);
        if((field.is("input") && field.attr("type") != 'checkbox' && field.attr("type") != 'radio' && formField.validity.patternMismatch) ||
           (field.is("input") && (field.attr("type") == 'checkbox' || field.attr("type") == 'radio') && formField.validity.valueMissing) || 
           (field.is("select") && (formField.validity.valueMissing || $.trim(field.val()) == 0))) {
            if(formField.hasAttribute('data-invalidtext'))
                formField.setCustomValidity(field.data('invalidtext'));
            if(abbr.length)
                abbr.removeClass('valid').removeClass('required').addClass('invalid');
            else
                field.parent().addClass('xrow-form-error');
        }
        else {
            formField.setCustomValidity('');
            if(abbr.length)
                abbr.removeClass('invalid').removeClass('required').addClass('valid');
            else
                field.parent().removeClass('xrow-form-error');
        }
    }
    else if(formField.hasAttribute('required') && formField.hasAttribute('data-emptytext')) {
        formField.setCustomValidity(field.data('emptytext'));
        if(abbr.length)
            abbr.removeClass('invalid').removeClass('valid').addClass('required');
        else
            field.parent().addClass('xrow-form-error');
    }
}
