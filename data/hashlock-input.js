// Input management

function pwgenBindToInput(input){

    var hashed = false;
    var maxlength = input.attr("maxlength");
    var old_background = input.css('backgroundColor');
    
    if (input.hasClass("nopasshash") || input.hasClass("nopwgen")) {
        return;
    }

    if (maxlength) {
        input.attr("maxlength", "100");
    }

    input.click(function() {
        if (hashed) {
            input.val("");
            input.css('backgroundColor', old_background);
            hashed = false;
        }
    });

    input.blur(function() {
        var value = input.val();
        if (value.length > 0) {
            if (value[0] == '#') {
                input.val(pwgenHashPassword(value.substring(1)));
                hashed = true;
                input.css('backgroundColor', '#D2D2D2');
            }
        }
    });

    input.keypress(function(e) {
        if (e.which == 13) {
            input.blur();
            input.form.submit();
        }
    });
    
}