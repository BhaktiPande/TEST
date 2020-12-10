function encrypt(string) {
    //Changing the key values should also be changed in Common.ConstEnum.Javascript_Encryption_Key
    var KeyValue = "8080808080808080";
    var key = CryptoJS.enc.Utf8.parse(KeyValue);
    var iv = CryptoJS.enc.Utf8.parse(KeyValue);
    var encryptedlogin = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(string), key,
    {
        keySize: 128 / 8,
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    });
    return encryptedlogin.toString();
}

function decrypt(string) {
    //Changing the key values should also be changed in Common.ConstEnum.Javascript_Encryption_Key
    var KeyValue = "8080808080808080";
    var key = CryptoJS.enc.Utf8.parse(KeyValue);
    var iv = CryptoJS.enc.Utf8.parse(KeyValue);
    var decryptedlogin = CryptoJS.AES.decrypt(string, key,
    {
        keySize: 128 / 8,
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    });
    return decryptedlogin.toString(CryptoJS.enc.Utf8);
}