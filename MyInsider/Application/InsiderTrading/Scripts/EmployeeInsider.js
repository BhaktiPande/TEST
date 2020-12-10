$(document).ready(function () {
    $(function () {
        $("Password").focus(function (pas) {
            $("#Password").val("");
            $("#Password").attr("Type", "Password");
        });
    });
});