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
                    if(input.hasAttribute('data-emptytext'))
                        input.setCustomValidity($(this).data('emptytext'));
                    $(this).keyup(function() {
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
            }
        });
    }
    if($('.onloadPasswordChanged').length) {
        $('.onloadPasswordChanged').keyup(function() {
            passwordChanged(this);
        });
    }
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
           (field.is("select") && formField.validity.valueMissing)) {
            if(formField.hasAttribute('data-invalidtext'))
                formField.setCustomValidity(field.data('invalidtext'));
            if(abbr.length)
                abbr.removeClass('valid').removeClass('required').addClass('invalid');
            else
                field.removeClass('valid').addClass('invalid');
        }
        else {
            formField.setCustomValidity('');
            if(abbr.length)
                abbr.removeClass('invalid').removeClass('required').addClass('valid');
            else
                field.removeClass('invalid').addClass('valid');
        }
    }
    else if(formField.hasAttribute('required') && formField.hasAttribute('data-emptytext')) {
        formField.setCustomValidity(field.data('emptytext'));
        if(abbr.length)
            abbr.removeClass('invalid').removeClass('valid').addClass('required');
    }
}