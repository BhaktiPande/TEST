var BrowserLeave = "false";
$(window).on('mouseover', (function () {
    window.onbeforeunload = null;
}));

$(window).on('mouseout', (function () {
    window.onbeforeunload = ConfirmLeave;
}));

$(window).on('click', (function () {
    window.onunload = null;
}));

$(window).on('mouseout', (function () {
    window.onunload = deleteCookies;
}));

function ChkBrowserLeave() {
    BrowserLeave = "true";
    $(window).on('mousedown', (function () {
        window.onunload = null;
    }));
}

function ConfirmLeave() {
    setTimeout(ChkBrowserLeave(), 0);
    return undefined;
}

function deleteCookies() {
    if (BrowserLeave == "true") {
        $.ajax({
            method: "GET",
            url: "../Account/LogOut",
            datatype: 'json',
            async: false,
            success: function (data) { },
            error: function (data) { }
        });
    }
}