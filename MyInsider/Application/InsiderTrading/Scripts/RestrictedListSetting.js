$(document).ready(function () {
    ShowHideOption($('input:radio[name="Preclearance_Required"]:checked').val());
    ShowLimitedSearchOption($('input:radio[name="Allow_Restricted_List_Search"]:checked').val());

    $(document).delegate('input:radio[name="Preclearance_Required"]', 'click', function (event) {
        ShowHideOption(this.value);
    });

    $(document).delegate('input:radio[name="Allow_Restricted_List_Search"]', 'click', function (event) {
        ShowLimitedSearchOption(this.value);
    });
});

function ShowHideOption(opt_val) {
    if (opt_val == 'Config_No') {
        $('div[id=pcl_required]').fadeOut('fast');
    } else if (opt_val == 'Config_Yes') {
        $('div[id=pcl_required]').fadeIn('fast');
    }
}

function ShowLimitedSearchOption(opt_val)
{
    if (opt_val == 'Perpetual') {
        $('#noOfHits').fadeOut('fast');
        
    } else if (opt_val == 'Limited') {
        $('#noOfHits').fadeIn('fast');
    }
}