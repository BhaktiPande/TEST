
$(document).ready(function () {
    $("#sUserName").val("");
    $("#sPassword").val("");

    $('input,textarea', 'form').blur(function () {

    });
    $("#sUserName").click(function () {
        $("#sUserName").val("");
        $("#sUserName").attr("type", "text");
    });
    $("#sPassword").click(function () {
        $("#sPassword").val("");
    });
    $("#sUserName,#sPassword").keydown(function (e) {
        if (e.keyCode == 13) {
            $("button[type='submit'].btn-success").focus();
        }
    });
    $("#sUserName").blur(function () {
        if ($("#sUserName").val() != "") {
            $("#sUserName").val(encrypt($("#sUserName").val()));
            $("#sUserName").attr("type", "password");
        }
    });
    $("#sPassword").blur(function () {
        if ($("#sPassword").val() != "") {
            $("#sPassword").val(encrypt($("#sPassword").val()));
        }
    });
    $("form").submit(function () {
        $("#sUserName").val($("#sUserName").val());
        $("#sPassword").val($("#sPassword").val());
    });
});

function encrypt(string) {

    //Changing the key values should also be changed in Common.ConstEnum.Javascript_Encryption_Key  
    var KeyValue = "8080808080808080";
    //var now = new Date();

    //var datetime = now.getFullYear() + '/' + (now.getMonth() + 1) + '/' + now.getDate();
    //datetime += ' ' + now.getHours() + ':' + now.getMinutes() + ':' + now.getSeconds();
    var sessionValue = $("#hdnSession").val();
    //var randomNo = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
    var encryptStr = string + "~" + sessionValue;

    var key = CryptoJS.enc.Utf8.parse(KeyValue);
    var iv = CryptoJS.enc.Utf8.parse(KeyValue);


    var encryptedlogin = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(encryptStr), key,
    {
        keySize: 128 / 8,
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    });


    return encryptedlogin;
}