/*This function can be used for showing popup for restricted list*/
$(function () {
    $(window).load(function () {        
        var Message = $("#myNames").val();
        if (Message != "") {
            $("#txtCompany").val("");
            $("#txtISINCode").val("");
            $("#txtBSECode").val("");
            $("#txtNSECode").val("");
            var Title = "Restricted List Search";
            var YesCallbackFunction = "YesCallbackFunction";
            ConfirmationMsg(Title, Message, YesCallbackFunction)
        }
    })
});

function ConfirmationMsg(Title, Message, YesCallbackFunction) {   
    $.confirm({        
        title: Title,
        text: Message,//"Are you sure want to delete?",                
        confirmButton: "Ok",
        post: false,
        confirmButtonClass: "btn btn-success",       
        dialogClass: "modal-dialog modal-lg",           
    });
    $(".cancel").hide();
}

//This function can be used for stop page postback
$(function () {
    $('#btnSave').on('click', function (evt) {        
        var txtCompanyName = $("#txtCompany").val();
        var isincod = $("#txtISINCode").val();
        var bsecode = $("#txtBSECode").val();
        var nsecode = $("#txtNSECode").val();
        if (txtCompanyName == "" && isincod == "" && bsecode == "" && nsecode == "")
        {
            evt.preventDefault();
        }
    })
});