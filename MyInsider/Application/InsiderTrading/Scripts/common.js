$(document).ready(function () {

    /*
        Two digits only positive value
    */
    $(".two-digits").each(function () {
        var val = $(this).val()
            $(this).val(formatIndianFloat(val));
    });

    $(document).delegate(".two-digits", 'keypress', function (e) {

        if (e.keyCode == '9' || e.keyCode == '16') {
            return;
        }
        var code;
        var oldValue = $(this).val();

        if (e.keyCode) code = e.keyCode;
        else if (e.which) code = e.which;
        //alert(e.which);
        if (oldValue.indexOf('.') > 0 && e.which == 46) {
            return false;
        }
        if (code == 8 || code == 46)
            return true;
        if (code < 48 || code > 57)
           return false;
       

    });

    $(document).delegate(".two-digits", 'focusin', function (e) {

        $(this).trigger('click');
    });

    $(document).delegate(".two-digits", "paste", function (e) {
        e.preventDefault();
    });

    $(function () {
        $('.two-digits').keyup(function () {
            if ($(this).val().indexOf('.') != -1) {
                if ($(this).val().split(".")[1].length > 2) {
                    if (isNaN(parseFloat(this.value))) return this;
                    this.value = parseFloat(this.value).toFixed(2);
                }
            }
            return this; //for chaining
        });
    });

    $(document).delegate(".two-digits", 'click', function (e) {
        var val = $(this).val();
        if (val != '0') {
            val = val.replace(/[^0-9.]+/g, "")
            $(this).val(val);
        }
    });

    $(document).delegate(".two-digits", 'focusout', function (e) {
        var val = $(this).val();
        $(this).val(formatIndianFloat(val));
    });


    /*
        Two digits allow negative value
    */
    $(".two-digits-negative").each(function () {
        var val = $(this).val()
        $(this).val(formatIndianFloat(val));
    });

    $(document).delegate(".two-digits-negative", 'keypress', function (e) {

        if (e.keyCode == '9' || e.keyCode == '16') {
            return;
        }
        var code;
        var oldValue = $(this).val();

        if (e.keyCode) code = e.keyCode;
        else if (e.which) code = e.which;
        //alert(e.which);
        if (code == 45) {
            if (oldValue == "") {
                $(this).val("-");
            }
            else if (parseFloat(oldValue) > 0) {
                $(this).val("-" + oldValue);
            }
            return false;
        }
        if (oldValue.indexOf('.') > 0 && e.which == 46) {
            return false;
        }
        if (code == 8 || code == 46)
            return true;
        //if (code < 48 || code > 57)
        //   return false;
        if (code > 31 && (code < 45 || code > 57)) {
            return false;
        }

    });

    $(document).delegate(".two-digits-negative", 'focusin', function (e) {

        $(this).trigger('click');
    });

    $(document).delegate(".two-digits-negative", "paste", function (e) {
        e.preventDefault();
    });

    $(function () {
        $('.two-digits-negative').keyup(function () {
            if ($(this).val().indexOf('.') != -1) {
                if ($(this).val().split(".")[1].length > 2) {
                    if (isNaN(parseFloat(this.value))) return this;
                    this.value = parseFloat(this.value).toFixed(2);
                }
            }
            return this; //for chaining
        });
    });

    $(document).delegate(".two-digits-negative", 'click', function (e) {
        var val = $(this).val();
        if (val != '0') {
            val = val.replace(/[^-0-9.]+/g, "")
            $(this).val(val);
        }
    });

    $(document).delegate(".two-digits-negative", 'focusout', function (e) {
        var val = $(this).val();
        $(this).val(formatIndianFloat(val));
    });

    /*
        Numeric Only Methods
    */
    $(".numericOnly").each(function () {
        var val = $(this).val()
        $(this).val(formatIndianNumber(val));
    });
    function setMenuInSession(parentmenuid, childmenuid) {
        $.ajax({
            url: $("#SetSelectedParentMenuURL").val(),
            type: 'post',
            headers: getRVToken(),
            data: { "SelectedParentId": parentmenuid },
            success: function (response) {
                $.ajax({
                    url: $("#SetSelectedChildMenuURL").val(),
                    type: 'post',
                    headers: getRVToken(),
                    data: { "SelectedChildId": childmenuid },
                    success: function (response) {
                    },
                    error: function () {
                        //  alert("Error occured!");
                    }
                });
            },
            error: function () {
                //  alert("Error occured!");
            }
        });

    }

    $(document).delegate(".showSelectedMenus", 'click', function (e) {
        var parentMenuId = $(this).attr("parentmenuid");
        var childMenuId = $(this).attr("childmenuid");
        setMenuInSession(parentMenuId, childMenuId);
    });

    $(document).delegate(".numericOnly", 'keypress', function (e) {
        if (e.keyCode == '9' || e.keyCode == '16') {
            return;
        }
        var code;
        if (e.keyCode) code = e.keyCode;
        else if (e.which) code = e.which;
        if (e.which == 46)
            return false;
        if (code == 8 || code == 46)
            return true;
        if (code < 48 || code > 57)
            return false;
    });

    $(document).delegate(".signedNumericOnly", 'keypress', function (e) {
        if (e.keyCode == '9' || e.keyCode == '16') {
            return;
        }
        var code;
        var oldValue = $(this).val();
        if (e.keyCode) code = e.keyCode;
        else if (e.which) code = e.which;

        if (code == 45) {
            if (oldValue == "")
            {
                $(this).val("-");
            }
            else if (parseInt(oldValue) > 0) {
                $(this).val("-" + oldValue);
            }
            return false;
        }
        if (e.which == 46)
            return false;
        
        if (code == 8 || code == 46 || code == 45 || e.keyCode == 8) {            
            return true;
        }
        if (code < 48 || code > 57)
            return false;
        
    });
    $(document).delegate(".signedNumericOnly", 'keyup', function (e) {
        var oldValue = $(this).val();
        if (oldValue == "-0") {
            $(this).val("0");
        }
        if (oldValue.indexOf('-') != 0 && oldValue.indexOf('-') >= 0) {
            oldValue = oldValue.replace("-", "");
           
            if (parseInt(oldValue) != 0)
            {
                $(this).val("-" + oldValue);
            }
        }
    });
    $(document).delegate(".integer-digits", 'keypress', function (e) {
        if (e.keyCode == '9' || e.keyCode == '16') {
            return;
        }
        var code;
        var allowedDigitNumber = $(this).attr("maxallowednoofdigits");
        if (allowedDigitNumber == undefined || allowedDigitNumber == "")
        {
            allowedDigitNumber = 2;
        }
        var oldValue = $(this).val();
        if (e.keyCode) code = e.keyCode;
        else if (e.which) code = e.which;
        if (e.which == 46)
            return false;
        if (code == 8 || code == 46 || code == 45 || e.keyCode == 8 ) {
            return true;
        }
        if (code < 48 || code > 57)
            return false;
        if ((parseInt(oldValue) < 0 && oldValue.length > allowedDigitNumber) ||( parseInt(oldValue) >= 0 && oldValue.length >= allowedDigitNumber))
        {
            return false;
        }
    });

    //Disable paste
    $(document).delegate(".numericOnly", "paste", function (e) {
        e.preventDefault();
    });

    $(document).delegate(".numericOnly", 'click', function (e) {
        var val = $(this).val();
        if (val != '0') {
            val = val.replace(/[^0-9]+/g, "")
            $(this).val(val);
        }
    });

    $(document).delegate(".numericOnly", 'focusout', function (e) {
        var val = $(this).val();
        $(this).val(formatIndianNumber(val));
    });
  
    /*
        Cureency format method
    */
    $(document).delegate(".currency", "focusout", function () {
        //$(this).toNumber().formatCurrency({ roundToDecimalPlace: 0, symbol: '' });
    });


    $(document).submit(function () {
      //  $(".currency").toNumber();
        return true;
    });
    
    $(document).bind("ajaxSend", function () {
      //  $(".currency").toNumber();
        return true;
    }).bind("ajaxSuccess", function () {
      //  $(".currency").toNumber().formatCurrency({ roundToDecimalPlace: 0, symbol: '' });
        return true;
    });

    $("#filter-panel").on("hide.bs.collapse", function () {
        $(".filtercollapse").html('<span class="glyphicon glyphicon-collapse-down"></span> ');
    });
    $("#filter-panel").on("show.bs.collapse", function () {
        $(".filtercollapse").html('<span class="glyphicon glyphicon-collapse-up"></span> ');
    });

});

$(window).load(function () {
   // $(".currency").toNumber().formatCurrency({ roundToDecimalPlace: 0, symbol: '' });
});

function confirmDialog(message) {
    try {
        message = htmlEncode(message);
        message = eval('"' + message + '"');
        message = htmlDecode(message);
    } catch (e) { }
    var confirmResponse = confirm(message);
    if (confirmResponse)
        return true;
    else
        return false;
}

function htmlEncode(value) {
    return value.replace(/\"/g, "&quot;");
}

function htmlDecode(value) {
    return value.replace(/\&quot;/g, '"');
}
function showDataSavedMessage() {
    $('#successMessageFlyover').show();
    $('#successMessageFlyover').addClass('in');


    setTimeout(
            function () {
                $('#successMessageFlyover').removeClass('in');
                $('#successMessageFlyover').hide();
                //console.log('Test');
            }, 2000);
}
function showMessage(message, status) {
    $('#MessageFlyover').show();
    $('#MessageFlyover').addClass('in');
    $('#MessageFlyover').removeClass("alert-success success");
    if (status) {
        $('#MessageFlyover').addClass('alert-success success');
    }else{
        $('#MessageFlyover').addClass('alert-error error');
    }
    $('#MessageFlyoverContent').html('');
    $('#MessageFlyoverContent').append(message);

    setTimeout(
            function () {
                $('#MessageFlyover').removeClass('in');
                $('#MessageFlyoverContent').html('');
                if (status) {
                    $('#MessageFlyover').addClass('alert-success success');
                } else {
                    $('#MessageFlyover').addClass('alert-error error');
                }
                $('#MessageFlyover').hide();

            }, 8000);
}
//This method is used for the formatting the Number(Integer) by Indian Standards Comma
function formatIndianNumber(val) {
    val = val.toString();
    val = val.replace(/,/g, "");
    if (val == '-')
        return val;
    var lastThree = val.substring(val.length - 3);
    var otherNumbers = val.substring(0, val.length - 3);
    if (otherNumbers != '' && otherNumbers != "-")
        lastThree = ',' + lastThree;
    var res = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree;
    return res;
}
//This method is used for the formatting the Number(Float) by Indian Standards Comma
function formatIndianFloat(val) {
    val = val.toString();
    val = val.replace(/,/g, "");
    if (val == '-')
        return val;
    if (val != null && val != "") {
        var afterPoint = '';
        if (val.indexOf('.') > 0) {
            //if (afterPoint.length > 3)
            //    afterPoint = afterPoint.substring(0, 3);
            val = parseFloat(Math.round(val * 100) / 100).toFixed(2);
            afterPoint = val.substring(val.indexOf('.'), val.length);
        }
        val = Math.floor(val);
        val = val.toString();
        
        var lastThree = val.substring(val.length - 3);
        var otherNumbers = val.substring(0, val.length - 3);
        if (otherNumbers != '' && otherNumbers != "-")
            lastThree = ',' + lastThree;
        //alert(afterPoint);
        var res = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree + afterPoint;
    } else {
        res = "";
    }
    return res;
}



function ShowDeleteConfirm(Title, Message, DeleteObj) {
    $.confirm({
        title: Title,
        text: Message,//"Are you sure want to delete?",
        confirm: function (button) {
            DeleteObj.trigger("click");
        },
        cancel: function (button) {
        },
        confirmButton: "Yes I Confirm",
        cancelButton: "No",
        post: true,
        confirmButtonClass: "btn btn-success",
        cancelButtonClass: "btn-danger",
        dialogClass: "modal-dialog modal-lg"
    });
}

/*This function can be used for giving a confirmation call for any action*/
function AskConfirmation(Title, Message, YesCallbackFunction, NoCallBackFunction) {
    $.confirm({
        title: Title,
        text: Message,//"Are you sure want to delete?",
        confirm: function (button) {
            if (YesCallbackFunction != undefined && typeof YesCallbackFunction == "function")
                YesCallbackFunction.call();
        },
        cancel: function (button) {
            if (NoCallBackFunction != undefined && typeof NoCallBackFunction == "function")
                NoCallBackFunction.call();
        },
        confirmButton: "Yes I Confirm",
        cancelButton: "No",
        post: true,
        confirmButtonClass: "btn btn-success",
        cancelButtonClass: "btn-danger",
        dialogClass: "modal-dialog modal-lg"
    });
}

/*This function will be used for merging the rows for the given column number. The rows having same values will get merged to only one cell in the column.*/
function mergeRowsForColumnNo(element,columnCount) {
        var valueTD = "";
        var blankTdCounter = 1;
        var oldFirstTDValue = "";
        
    
        $(element).find("tr").each(function () {
            var firstTdVal = $(this).find("td:eq(" + columnCount + ")").text();
            if (firstTdVal != "" && firstTdVal != oldFirstTDValue) {
                if (blankTdCounter != 1) {
                    $(valueTD).attr("rowspan", blankTdCounter);
                }
                valueTD = $(this).find("td:eq(" + columnCount + ")");
                blankTdCounter = 1;
            }
            else {
                $(this).find("td:eq(" + columnCount + ")").remove();
                blankTdCounter++;
            }
            oldFirstTDValue = firstTdVal;
        });
        if (blankTdCounter != 1) {
            $(valueTD).attr("rowspan", blankTdCounter);
        }
}
function removeCommafromNumber(val)
{
    if (val != undefined && val != "" && val != null)
    {
        val = val.replace(/[,]+/g, "");
    }
    return val;
}