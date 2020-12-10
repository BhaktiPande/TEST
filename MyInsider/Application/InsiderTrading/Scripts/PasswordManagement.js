
$(document).ready(function () {

    $("#Create").click(function (event) {
        if (!validatePassword()) {
           // event.preventDefault();
        }
    });

    function validatePassword() {
        var old_pass = $('#OldPassword').val();
        var new_pass = $('#NewPassword').val();
        var conf_pass = $('#ConfirmNewPassword').val();
        if (old_pass === "") {
            alert('Old password should not be blank.');
        }
        else if (new_pass === "") {
            alert('New password should not be blank.');
        }
        else if (conf_pass === "") {
            alert('Confirm password should not be blank');
        }
        else if (old_pass == new_pass) {            
            alert('Old and New Password should NOT be same');
        }
        else if (new_pass !== conf_pass) {
            alert('New and confirm password should be same');
        }
        return false
    }
 

});