
    $(function () {
        $(window).load(function () {
            $('#hiddenbtnSave').hide();//Hide save button on Restricted List view page
            var CmpId = $('#RestrictedID').val();
            var ddlCmpName = $('#CompanyName').val();
            var ddlBSECode = $('#BSECode').val();
            var ddlNSECode = $('#NSECode').val();
            var ddlISINCode = $('#ISINCode').val();
            var txtApplicableFrm = $('#dApplicableFrom').val();
            var txtApplicableTo = $('#dApplicableTo').val();
            if (CmpId != 0) {
                //Assign value to Dropdown and Textbox's
                $("#ddlCompanyName option:selected").text(ddlCmpName);
                $("#ddlBSECode option:selected").text(ddlBSECode);
                $("#ddlNSECode option:selected").text(ddlNSECode);
                $("#ddlISINCode option:selected").text(ddlISINCode);
                $('#ApplicableFrom').val(txtApplicableFrm);
                $('#ApplicableTo').val(txtApplicableTo);
                $(".field-validation-error").empty();//Validation message remove
                //alert("Company ID :- " + CmpId + " " + "Company Name :- " + ddlCmpName + " " + "BSE Code :- " + ddlBSECode + " " + "NSE Code :- " + ddlNSECode + " " + "ISIN Code :- " + ddlISINCode);
            }
        })
    });

//Company search functionality for Gride
$(function () {
	$(document).ready(function () {
            $("#1").change(function () {
                var companyid = $("#1").val();
                if (companyid != "") {
                    $.ajax({
                        url: '@Url.Content("~/RestrictedList/GetCompanyDetails/")',
                        type: "GET",
                        data: { companyid: companyid },
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        success: function (data) {
                            if (data.RlCompanyId != null) {
                                $("#2").val(data.ISINCode)
                                $("#3").val(data.BSECode)
                                $("#4").val(data.NSECode)
                            }
                        }
                    });
                }
                else {
                    $("#2").val("")
                    $("#3").val("")
                    $("#4").val("")
                }
            });
                   
        });
});
