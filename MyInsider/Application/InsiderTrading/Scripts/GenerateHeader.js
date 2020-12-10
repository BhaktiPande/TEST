/**********************************************************************************************************
* Main functions are the createObject and generateHeaderInTable.
*
*Input : arr            =  header data object sent to GenerateHeader containing info about display name, 
*                           header column width, sequence no. with info about parent headers.
*         element        =  Selector object for table head.
*         objDatatable   =  DatatableGrid object to add aoColumns data according to condition.
*output : 1) Renders the columns at the given element selector of the table. 
*          2) Fills up the datatable js aoColumn object, which is sent to the datatable function as a parameter.
*
***************************************************************************************************************/

var GenerateHeader = {

    obj: [],
    totalWidth : 0,
    bWidthFlag: true,

    /*Initialize function*/
    init: function (arr, element, objDatatable) {
        this.obj = [];
        this.totalWidth = 0;
        this.bWidthFlag = true;
        this.str = arr;
        this.tblElement = element;
        this.objThis = objDatatable;
        this.createObject();

        this.generateHeaderInTable();
        
    },

    /*Find the number of parents for the given sequence number*/
    findParents: function (val) {
        s = $.grep(this.str, function (i, n) { return i["SequenceNumber"].match("^" + ("0" + parseInt(parseInt(val) % 1000)).slice(-2)); }, false);
        a = s;
        while (!s[0]["SequenceNumber"].match("00$")) {
            s = $.grep(this.str, function (i, n) { return i["SequenceNumber"].match("^" + ("0" + parseInt(parseInt(s[0]["SequenceNumber"]) % 1000)).slice(-2)); }, false);
            if (s.length != 0) {
                a.push(s[0]);
            }
            else
                break;
        }
        return a;
    },

    /*Generates the object according to the parent child view*/
    createObject: function () {
        var objThis = this;
        $.each(this.str, function (key, val) {
            if (val["SequenceNumber"].length == 5)
                val["SequenceNumber"] = "0" + val["SequenceNumber"];
            if (val["SequenceNumber"].match("00$")) {
                val["child"] = [];
                objThis.obj.push(val);
            }
            else {
                s = objThis.findParents(val["SequenceNumber"]);
                val["child"] = [];

                /**Improvement needed**/
                /*This part can be made dynamic. Currently only 4 level of parent child condition is been handled*/
                if (s.length == 1) {
                    objThis.obj[$.inArray(s[0], objThis.obj)]["child"].push(val);
                }
                else if (s.length == 2) {
                    objThis.obj[$.inArray(s[1], objThis.obj)]["child"][$.inArray(s[0], objThis.obj[$.inArray(s[1], objThis.obj)]["child"])]["child"].push(val);
                }
                else if (s.length == 3) {
                    var ind = $.inArray(s[2], objThis.obj);
                    var ind2 = $.inArray(s[1], objThis.obj[ind]["child"]);
                    objThis.obj[ind]["child"][ind2]["child"][$.inArray(s[0], objThis.obj[ind]["child"][ind2]["child"])]["child"].push(val);
                }
                /**Improvement needed**/
            }
        });

    },

    /*Iterate through the object and add all the parent child headers with rowspan and colspan set according to conditions*/
    addChildHeaders: function (objData, i) {
        i++;
        var objThis = this;
        $.each(objData, function (val, key) {
            var noOfColumns = objThis.numberOfColumns(key["child"]);
            if (key["child"].length > 0) {
                if (parseInt(key["Width"]) > 0) {
                    var width = parseInt(key["Width"]) * 7 + 17 * key["child"].length;
                    objThis.tblElement.find("tr:nth-child(" + i + ")").append("<th class='group-col'  colspan='" + noOfColumns + "' style='text-align:center;width:" + width + "px;'>" + key["Value"] + "</th>");
                }
                else {
                    objThis.tblElement.find("tr:nth-child(" + i + ")").append("<th class='group-col'  colspan='" + noOfColumns + "' style='text-align:center;'>" + key["Value"] + "</th>");
                }
                objThis.addChildHeaders(key["child"], i);
            }
            else {
                objThis.tblElement.find("tr:nth-child(" + i + ")").append("<th rowspan='" + eval(objThis.tblElement.find("tr").length - i + 1) + "' colspan='" + noOfColumns + "'>" + key["Value"] + "</th>");
                objThis.addToAOColumns(key);
            }
        });
    },

    /*calculate the highest depth of the object containing child. This determines the number of rows to be added to header.
    And as well used to calculate the rowspan according to the level at which the column info is to be added.
    */
    numberOfRows: function (obj) {
        var level = 1;
        var objThis = this;
        $.each(obj, function (val, key) {
            if (key["child"].length > 0) {
                var depth = objThis.numberOfRows(key["child"]) + 1;
                level = Math.max(depth, level);
            }
        });
        return level;
    },

    /*Find the count of the leaf node for the selected header so as to apply the colspan according to the count*/
    numberOfColumns: function (obj) {
        var level = 0;
        var objThis = this;
        $.each(obj, function (val, key) {
            if (key["child"].length > 0) {
                var depth = objThis.numberOfColumns(key["child"]);
                //alert(depth);
                //level = Math.max(depth, level);
                level = level + depth;
            }
            else {
                level = level + 1;
            }
        });
        return level;
    },

    /* Generation of the header columns for the gird*/
    generateHeaderInTable: function () {
        var rowCount = this.numberOfRows(this.obj);
        var tblElement = this.tblElement;
        tblElement.html("");
        for (i = 0; i < rowCount; i++)
            tblElement.append("<tr></tr>");
        var objThis = this;
        var i = 1;
        $.each(this.obj, function (key, val) {
            i = 1;
            if (val["child"].length == 0) {
                tblElement.find("tr:nth-child(" + i + ")").append("<th rowspan='" + rowCount + "' >" + val["Value"] + "</th>");
                objThis.addToAOColumns(val);
            }
            else {
                var noOfColumns = objThis.numberOfColumns(val["child"]);
                if (parseInt(val["Width"]) > 0) {
                    var width = parseInt(val["Width"]) * 7 + 17 * val["child"].length;
                    tblElement.find("tr:nth-child(" + i + ")").append("<th class='group-col' colspan='" + noOfColumns + "' style='text-align:center;width:" + width + "px;'>" + val["Value"] + "</th>");
                }
                else
                {
                    tblElement.find("tr:nth-child(" + i + ")").append("<th class='group-col' colspan='" + noOfColumns + "' style='text-align:center;'>" + val["Value"] + "</th>");
                }
                objThis.addChildHeaders(val["child"], i);
            }
        });
    },

    /* Add data to aoColumn of the object from where its been called*/
    addToAOColumns: function (objData) {
        this.nTotalWidth = this.nTotalWidth + (parseInt(objData.Width) * 7) + 17;
        if (this.bWidthFlag == true && objData.Width == "0") {
            this.bWidthFlag = false;
        }
        this.objThis.arrColumns.push({
            'mDataProp': objData.Key,
            'sDefaultContent': '',
            'bSortable': false,
            "bStateSave": true,
            "sWidth": (objData.Width * 7) + "px",
            "sClass": "text-" + objData.Align,
            'fnRender': this.objThis.format["GridType_" + this.objThis.GridType][objData.Key]
        });

    }


}