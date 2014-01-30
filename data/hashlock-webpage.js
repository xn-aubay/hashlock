// content-script.js - HashLock module

// This file is executed on the page content

$(function(){

    // Manage every password input
    $('input[type="password"]').each(function(){
        var input = $(this);
        hashlockBindToInput(input);
    });
});
