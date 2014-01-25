// content-script.js - PWgen's module
// author: ThunderK

// This file is executed on the page content

$(function(){

    // Manage every password input
    $('input[type="password"]').each(function(){
        var input = $(this);
        pwgenBindToInput(input);
    });
});
