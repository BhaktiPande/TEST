$.validator.addMethod("datecompare", function (value, element, params) {
    // debugger;
    var propelename = params.split(",")[0];
    var operName = params.split(",")[1];
    var type = params.split(",")[2];
    var dformat = params.split(",")[3];

    if (params == undefined || params == null || params.length == 0 ||
    value == undefined || value == null || value.length == 0 ||
    propelename == undefined || propelename == null || propelename.length == 0 ||
    operName == undefined || operName == null || operName.length == 0 ||
    type == undefined || type == null || type.length == 0 ||
    dformat == undefined || dformat == null || dformat.length == 0)
        return true;
    var valueOther = $(propelename).val();

    var val1 = null;
    var val2 = null;

    //new Date(year, month, day, hours, minutes, seconds, milliseconds);
    if (type == "Date") {
        var dt1_part = value.split("/");
        var dt2_part = valueOther.split("/");
        var dt1 = null;
        var dt2 = null;

        if (dformat == "DDMMYYYY") {
            var dt1 = new Date(parseInt(dt1_part[2], 10), parseInt(dt1_part[1], 10) - 1, parseInt(dt1_part[0], 10));
            val1 = dt1.getTime();

            var dt2 = new Date(parseInt(dt2_part[2], 10), parseInt(dt2_part[1], 10) - 1, parseInt(dt2_part[0], 10));
            var val2 = dt2.getTime();
        } 
    } else if (type == "DateTime") {
        var dt1_datetime_part = value.split(" ");
        var dt1_date_part = value.split("/");
        var dt1_time_part = value.split(":");

        var dt2_datetime_part = valueOther.split(" ");        
        var dt2_date_part = valueOther.split("/");
        var dt2_time_part = valueOther.split(":");

        var dt1 = null;
        var dt2 = null;

        if (dformat == "DDMMYYYY") {
            var dt1 = new Date(parseInt(dt1_date_part[2], 10), parseInt(dt1_date_part[1], 10) - 1, parseInt(dt1_date_part[0], 10),
                                parseInt(dt1_time_part[0]), parseInt(dt1_time_part[1]), parseInt(dt1_time_part[2]));
            val1 = dt1.getTime();

            var dt2 = new Date(parseInt(dt2_date_part[2], 10), parseInt(dt2_date_part[1], 10) - 1, parseInt(dt2_date_part[0], 10),
                                parseInt(dt2_time_part[0]), parseInt(dt2_time_part[1]), parseInt(dt2_time_part[2]));
            var val2 = dt2.getTime();
        }
    }

    //var val1 = (isNaN(value) ? Date.parse(value) : eval(value));
    //var val2 = (isNaN(valueOther) ? Date.parse(valueOther) : eval(valueOther));
    if (isNaN(val1) || isNaN(val2)) {
        return true;
    }

    if (operName == "GreaterThan")
        return val1 > val2;
    if (operName == "LessThan")
        return val1 < val2;
    if (operName == "GreaterThanOrEqual")
        return val1 >= val2;
    if (operName == "LessThanOrEqual")
        return val1 <= val2;
});

$.validator.unobtrusive.adapters.add("datecompare",
["comparetopropertyname", "operatorname", "comparetype", "comparedateformat"], function (options) {
    options.rules["datecompare"] = "#" +
    options.params.comparetopropertyname + "," + options.params.operatorname + "," + options.params.comparetype + "," + options.params.comparedateformat;
    options.messages["datecompare"] = options.message;
});