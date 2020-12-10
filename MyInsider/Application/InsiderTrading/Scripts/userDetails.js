var objSearchResultsTableSearch;

$(document).ready(function () {
    var dataTable = null;

    $('input,textarea', 'form').blur(function () {
        $(this).valid();

        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");

    });

  
    $('#Delete').click(function () {
        if (confirmDialog("Are you sure want to delete this user.?")) {
            return true;
        }
        else {
            return false;
        }

    });

    
    $("#TxtSearch").keyup(function () {
        if (objSearchResultsTableSearch != null) {
            objSearchResultsTableSearch.fnFilter(this.value);
        }
    });

       
    SearchUser();

    $(document).delegate("#cousr_detail_save", "click", function () {
        if ($("#confirm_role").val() == "True" && $('#SubmittedRole option:selected').length <= 0) {
            return confirm("Role has not been assigned to user - do you want to continue?");
        }
    });

  
});



function SearchUser() {
    var EmployeeId = $.trim($('#EmployeeId').val());
    var LoginID = $.trim($('#LoginID').val());
    var FirstName = $.trim($('#FirstName').val());
    var LastName = $.trim($('#LastName').val());
    var CompanyId = $.trim($('#CompanyId').val());
    var StatusCodeId = $.trim($('#StatusCodeId').val());
   

    var objSearchResultsTable;
    //if (From != "" && To != ""  ) {

    if (objSearchResultsTable == null) {
        //Get Search Results dataTable
        objSearchResultsTable = $('#tblSearchResults').dataTable({
            "bDeferRender": true,
            "bDestroy": true,
            "bFilter": false,
            "searchable": false,
           // bPaginate: true,
            bDeferRender: true,
            //'sPaginationType': 'bootstrap',
            ////UI format for displaying datatable, paging, count and processing
            // sDom: '<"DiarySearch">lrtp>',
            //"bPaginate": true,
            "bAutoWidth": false,
            success: function (response) {
                renderTable(response.d);
                $("input[type='text']").removeAttr("valuechanged");
            },
            //Set the message if datatable is empty
            //oLanguage: {
            //    "sSearch": "Search all columns:",
            //    "sEmptyTable": "No matching records found.",
            //},

            //"bServerSide": true,
            //"ajax": "/UserDetails/CRUserSearchList",
            //"bProcessing": true,


            "sServerMethod": "POST",
            "sAjaxSource": $('#CRUserSearchList').val(),
            "bSort": true,
            "aaSorting": [],
            "aoColumns": [
                {
                    mData: "FirstName", mRender: function (obj, type, row) {
                        var str = row.FirstName;
                        return str;
                    }, sDefaultContent: "",  "sClass": "FirstName"
                },
              {
                  mData: "EmployeeId", mRender: function (obj, type, row) {
                      var str = row.EmployeeId;
                      return str;
                  }, sDefaultContent: "", "sClass": "EmployeeId"
              },
                {
                    mData: "UserName", mRender: function (obj, type, row) {

                        var str = row.UserName;
                        return str;
                    }, sDefaultContent: ""
                },
                {
                    mData: "CompanyName", mRender: function (obj, type, row) {

                        var str = row.CompanyName;
                        return str;
                    }, sDefaultContent: ""
                }
                ,
                {
                    mData: "MobileNumber", mRender: function (obj, type, row) {

                        var str = row.MobileNumber;
                        return str;
                    }, sDefaultContent: ""
                }
                ,
                {
                    mData: "EmailId", mRender: function (obj, type, row) {

                        var str = row.EmailId;
                        return str;
                    }, sDefaultContent: ""
                }
                ,
                {
                    mData: "Status", mRender: function (obj, type, row) {

                        var str = row.Status;
                        return str;
                    }, sDefaultContent: "", "align": "center", 
                },
                {

                     mData: "UserInfoId", mRender: function (obj, type, row) {

                         var str = "<input class='btn btn-default' id ='DeleteUser' UserInfoId = '" + row.UserInfoId + "' type='button' value = 'Delete' />" +
                                    "&nbsp;&nbsp;<input class='btn btn-default' id ='EditUser' UserInfoId = '" + row.UserInfoId + "' type='button' value = 'Edit'/>";
                         return str;
                           
                    } 
                   
                                     
                }

            ],

            "fnServerParams": function (aoData) {
             
                aoData.push(
               { "name": "FirstName", "value": FirstName },
               { "name": "LoginID", "value": LoginID },
               { "name": "CompanyId", "value": CompanyId },
               { "name": "StatusCodeId", "value": StatusCodeId },
               { "name": "LastName", "value": LastName },
               { "name": "EmployeeId", "value": EmployeeId }
               
               );
            }
        });
    }
    else {
        objSearchResultsTable.fnFilter(
                { "name": "UserNameSearch", "value": UserNameSearch },
               { "name": "UserIDSearch", "value": UserIDSearch },
               { "name": "CompanyIdSearch", "value": CompanyIdSearch },
               { "name": "StatusSearch", "value": StatusSearch },
               { "name": "LastNameSearch", "value": LastNameSearch },
              { "name": "EmployeeIdSearch", "value": EmployeeIdSearch }
   );
    }
  

    return false;
}






