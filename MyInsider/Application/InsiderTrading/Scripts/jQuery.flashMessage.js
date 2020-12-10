$.fn.flashMessage = function (options) {
    var target = this;
    options = $.extend({}, options, { timeout: 3000, alert: 'info' });
 
    if (!options.message) {
        setFlashMessageFromCookie(options);
    }
 
    if (options.message) {
        $(target).addClass(options.alert.toString().toLowerCase());
 
        if (typeof options.message === "string") {
            $('p', target).html("<span>" + options.message + "</span>");
        } else {
            target.empty().append(options.message);
        }
    } else {
        return;
    }
 
    if (target.children().length === 0) return;
 
    target.fadeIn().one("click", function () {
        $(this).fadeOut();
    });
 
    if (options.timeout > 0) {
        setTimeout(function () { target.fadeOut(); }, options.timeout);
    }
 
    return this;
 
    // Get the first alert message read from the cookie
    function setFlashMessageFromCookie() {
        $.each(new Array('Success', 'Error', 'Warning', 'Info'), function (i, alert) {
            try{
                var cookie = $.cookie("Flash." + alert);
 
                if (cookie) {
                    options.message = cookie;
                    options.alert = alert;
 
                    deleteFlashMessageCookie(alert);
                    return;
                }
            }
            catch(e){
                deleteFlashMessageCookie(alert);
            }
        });
    }
 
    // Delete the named flash cookie
    function deleteFlashMessageCookie(alert) {
        var cookies_app_path = $('#cookies_app_path').val();
        $.cookie("Flash." + alert, null, { path: cookies_app_path });
    }
};