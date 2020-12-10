
//$(document).ready(function () {


    $.validator.methods.range = function (value, element, param) {
      
        var val = value.replace(/,/g, "");
      
        return this.optional(element) || (val >= param[0] && val <= param[1]);
    }

    $.validator.methods.min = function (value, element, param) {
        var val = value.replace(/,/g, "");
        return this.optional(element) || (val >= param);
    }

    $.validator.methods.max = function (value, element, param) {
        var val = value.replace(/,/g, "");
        return this.optional(element) || (val <= param);
    }

    $.validator.methods.number = function (value, element) {
       // alert(value.replace(",", ""));
        return this.optional(element) || /^-?(?:\d+|\d{1,3}(?:[\s\.,]\d{3})+)(?:[\.,]\d+)?$/.test(value.replace(/,/g, ""))
            || /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:[\.,]\d+)?$/.test(value.replace(/,/g, ""));
    }

    $.validator.unobtrusive.adapters.add("regexwithoptions", ["pattern", "flags"], function (options) {
        options.messages['regexwithoptions'] = options.message;
        options.rules['regexwithoptions'] = options.params;
    });

    $.validator.addMethod("regexwithoptions", function (value, element, params) {
        var match;
        if (this.optional(element)) {
            return true;
        }
        var reg = new RegExp(params.pattern, params.flags);
        match = reg.exec(value);
        return (match && (match.index === 0) && (match[0].length === value.length));
    });
  
    
   