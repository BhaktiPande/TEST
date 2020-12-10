var searchResult = $('#SearchResult').val();
var reportSearchResult = $('#ReportSearchArray').val();
if (searchResult != undefined) {
    var searchArray = $.parseJSON(searchResult);
}
if (reportSearchResult != undefined) {
    var reportSearchArray = $.parseJSON(reportSearchResult);
}
if (searchArray != null) {
    var otherThanNull = searchArray.some(function (el) {
        return el !== null;
    });
}
if (reportSearchResult != null) {
    var otherThanNull = reportSearchArray.some(function (el) {
        return el !== null;
    });
}
if (otherThanNull == true) {
    if (searchResult != null || searchResult != undefined) {
        BindSearchData("searchBtn", searchArray)
    }
    else {
        BindSearchData("searchBtn", reportSearchArray)
    }
}


function BindSearchData(buttonName, searchArray) {
    var flag = false;
    var otherThanNull = searchArray.some(function (ele,index) {
        if(ele!=null){
            var index = index + 1;
            if ($('#' + index + '')[0].type != "hidden") {
                flag = true;
            }
            if($('#' + index + '')[0].type == "select-multiple"){
                var array = ele.split(',');
                var isNull = array.some(function (ele1) {
                    $('#' + index + ' option[value=' + ele1 + ']').prop("selected", true);
                });
            }
            else {
                $('#' + index + '').val(ele);
            }
        }
    });
    if (flag == true) {
        $('#' + buttonName + '').trigger("click");
    }
}