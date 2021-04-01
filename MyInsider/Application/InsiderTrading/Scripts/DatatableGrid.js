////
//Datatable grid functionality
////
var rowCount = 0;
var Level0 = {};
var Level1 = {};
var Level2 = {};
var OldLevel0Key = '', OldLevel1Key = '';
var GridsToMaintainSearchAndPaging = ["114001", "114002", "114007", "114009", "114015", "114020", "114024", "114025", "114050", "114052", "114053", "114054", "114058", "114059", "114060", "114061", "114062", "114122", "114123", "114125", "114126"];
var GridsToNotMaintainPagingOnly = ["114005", "114010", "114011", "114012", "114013", "114014", "114016", "114022", "114031", "114033", "114034", "114035", "114036", "114037", "114038", "114039", "114040", "114043", "114045", "114048", "114049", "114066", "114067", "114068", "114069", "114070", "114071", "114093", "114094", "114098", "508008", "508005", "122098", "122100", "114101", "114102", "114103", "114104", "114109", "114110", "114117", "114107", "114108", "114115", "114116", "114127", "114128","114129"];

var isDefaultNoSort = false;

var DatatableGrid = function (element, type, column, sortCol, bIsPagination, bIsServerSide, sDom, sNoRecordsfoundMessage, sCallBackFunction, sDisplayLength, sPagingLengthMenu, sShowProcessing) {

    this.tableElement = null;
    this.element = element;
    this.GridType = type;
    this.column = column;
    this.arrColumns = [];
    this.sortCol = sortCol;
    this.bIsPagination = bIsPagination.toLowerCase() == "true" ? true : false;
    this.bIsServerSide = bIsServerSide.toLowerCase() == "true" ? true : false;
    this.sDom = sDom;
    this.bWidthFlag = true;
    this.NoRecordsfoundMessage = sNoRecordsfoundMessage;
    if (sCallBackFunction != "" && sCallBackFunction != undefined)
        this.CallBackFunction = eval('(' + sCallBackFunction + ')');
    //this.sDisplayLength = sDisplayLength;
    if (sDisplayLength == undefined || sDisplayLength == "")
        this.sDisplayLength = 10;
    else
        this.sDisplayLength = parseInt(sDisplayLength);


    isDefaultNoSort = sortCol == "" ? true : false;


    //this.sPagingLengthMenu = sPagingLengthMenu;
    if (sPagingLengthMenu == undefined || sPagingLengthMenu == "")
        this.sPagingLengthMenu = [10, 25, 50, 100];
    else
        this.sPagingLengthMenu = eval('(' + sPagingLengthMenu + ')');
    if (sShowProcessing == undefined || sShowProcessing == "" || sShowProcessing == true || sShowProcessing == "true")
        this.ShowProcessing = true;
    else if (sShowProcessing == false || sShowProcessing == "false")
        this.ShowProcessing = false;
    this.init();
};

/////
//  Initialization of grid : 
//      1) Generating the grid columns headers.
//      2) Adding the column name to be fetched when received the grid data and as well apply formatting for each column.
/////
DatatableGrid.prototype.init = function () {
    var sortOffList = ["dis_grd_17261", "usr_grd_11085", "usr_grd_11073", "usr_grd_11228", "rul_grd_15001", "rul_grd_15002", "rul_grd_15003", "rul_grd_15004", "rul_grd_15005", "rul_grd_15006", "rul_grd_15007", "dis_grd_17015", "dis_grd_17016", "dis_grd_17017", "dis_grd_17019", "dis_grd_17018", "dis_grd_17021", "dis_grd_17022", "dis_grd_17270", "dis_grd_17257", "dis_grd_17258", "dis_grd_17260", "dis_grd_17259", "dis_grd_17262", "dis_grd_17263", "dis_grd_17264", "dis_grd_17254", "dis_grd_17255", "dis_grd_17256", "dis_grd_17014", "dis_grd_17350", "dis_grd_17351", "dis_grd_17354", "dis_grd_17355", "dis_grd_17448", "dis_grd_50597", "dis_grd_50605", "dis_grd_50608", "dis_grd_50610", "dis_grd_50617", "dis_grd_50619", "dis_grd_50646", "dis_grd_50647", "dis_grd_54060", "dis_grd_54062", "dis_grd_54063", "dis_grd_52123", "dis_grd_52124"];

    var GridType_114037_sortOffList = ["dis_grd_17010", "dis_grd_17011", "dis_grd_17012", "dis_grd_17030", "dis_grd_17031", "dis_grd_17032"];
    sortOffList = sortOffList.concat(GridType_114037_sortOffList);

    var GridType_114039_sortOffList = ["dis_grd_17034", "dis_grd_17035", "dis_grd_17036", "dis_grd_17037", "dis_grd_17038", "dis_grd_17039", "dis_grd_17040"];
    sortOffList = sortOffList.concat(GridType_114039_sortOffList);

    var GridType_114045_sortOffList = ["dis_grd_17165", "dis_grd_17166", "dis_grd_17167", "dis_grd_17168", "dis_grd_17169", "dis_grd_17394", "dis_grd_54061"];
    sortOffList = sortOffList.concat(GridType_114045_sortOffList);

    var GridType_114057_sortOffList = ["cmu_grd_18003", "cmu_grd_18004", "cmu_grd_18049", "cmu_grd_18050"];
    sortOffList = sortOffList.concat(GridType_114057_sortOffList);
    //Shubhangi ID
    var GridType_114031_sortOffList = ["tra_grd_16001", "tra_grd_16002", "tra_grd_16003", "tra_grd_16004", "tra_grd_16005", "tra_grd_16006", "tra_grd_16007", "tra_grd_16008", "tra_grd_16009", "tra_grd_16010", "tra_grd_16011", "tra_grd_16012", "tra_grd_16013", "tra_grd_16014", "tra_grd_16015", "tra_grd_16429", "tra_grd_16338", "tra_grd_16354", "tra_grd_16370", "tra_grd_16386", "tra_grd_16402", "tra_grd_16418"];
    sortOffList = sortOffList.concat(GridType_114031_sortOffList);

    var GridType_114076_sortOffList = ["dis_grd_17360", "dis_grd_17361", "dis_grd_17387", "dis_grd_17362", "dis_grd_17363", "dis_grd_17364", "dis_grd_17365", "dis_grd_17366", "dis_grd_17367", "dis_grd_17368"];
    sortOffList = sortOffList.concat(GridType_114076_sortOffList);

    var GridType_114077_sortOffList = ["dis_grd_17369", "dis_grd_17370", "dis_grd_17388", "dis_grd_17371", "dis_grd_17372", "dis_grd_17373", "dis_grd_17374", "dis_grd_17375", "dis_grd_17376", "dis_grd_17377"];
    sortOffList = sortOffList.concat(GridType_114077_sortOffList);

    var GridType_114079_sortOffList = ["usr_grd_50005", "usr_grd_50007", "usr_grd_50009", "usr_grd_50010", "usr_grd_50011", "usr_grd_50012"];
    sortOffList = sortOffList.concat(GridType_114079_sortOffList);

    var GridType_114044_sortOffList = ["cmu_grd_18007", "cmu_grd_18008", "cmu_grd_18009", "cmu_grd_18010", "cmu_grd_18011"];
    sortOffList = sortOffList.concat(GridType_114044_sortOffList);

    var GridType_114041_sortOffList = ["rul_grd_15361", "rul_grd_15362", "rul_grd_15363", "rul_grd_15364"];
    sortOffList = sortOffList.concat(GridType_114041_sortOffList);

    var GridType_114093_sortOffList = ["tra_grd_16448", "tra_grd_16449", "tra_grd_16450"];
    sortOffList = sortOffList.concat(GridType_114093_sortOffList);

    var GridType_114094_sortOffList = ["dis_grd_17485", "dis_grd_17486", "dis_grd_17487", "dis_grd_17488", "dis_grd_17489", "dis_grd_17490", "dis_grd_17491", "dis_grd_17492", "dis_grd_17493", "dis_grd_17494", "dis_grd_17495", "dis_grd_17496"];
    sortOffList = sortOffList.concat(GridType_114094_sortOffList);

    var GridType_114095_sortOffList = ["dis_grd_17514", "dis_grd_17515", "dis_grd_17516", "dis_grd_17517", "dis_grd_17518", "dis_grd_17519", "dis_grd_17520", "dis_grd_17521", "dis_grd_17522", "dis_grd_17523", "dis_grd_17524", "dis_grd_17525", "dis_grd_17526", "dis_grd_17527"];
    sortOffList = sortOffList.concat(GridType_114095_sortOffList);

    var GridType_114096_sortOffList = ["rl_grd_50301", "rl_grd_50302", "rl_grd_50303", "rl_grd_50304", "rl_grd_50305", "rl_grd_50306", "rl_grd_50307", "rl_grd_50308", "rl_grd_50309", "rl_grd_50310", "rl_grd_50311", "rl_grd_50312", "rl_grd_50313", "rl_grd_50314", "rl_grd_50315", "rl_grd_50316", "rl_grd_50317", "rl_grd_50318", "rl_grd_50319", "rl_grd_50320"];
    sortOffList = sortOffList.concat(GridType_114096_sortOffList);

    var GridType_114098_sortOffList = ["usr_grd_11474", "usr_grd_11475", "usr_grd_11476", "usr_grd_11477", "usr_grd_11478", "usr_grd_11479", "usr_grd_11480", "usr_grd_11481", "usr_grd_11482"];
    sortOffList = sortOffList.concat(GridType_114098_sortOffList);

    var GridType_114099_sortOffList = ["rpt_grd_19341", "rpt_grd_19342", "rpt_grd_19343", "rpt_grd_19344", "rpt_grd_19345", "rpt_grd_19346", "rpt_grd_19347", "rpt_grd_19348", "rpt_grd_19349", "rpt_grd_19339", "rpt_grd_19328", "rpt_grd_19329", "rpt_grd_19330", "rpt_grd_19331", "rpt_grd_19332", "rpt_grd_19333", "rpt_grd_19334", "rpt_grd_19335", "rpt_grd_19336", "rpt_grd_19337", "rpt_grd_19338", "rpt_grd_19340"];
    sortOffList = sortOffList.concat(GridType_114099_sortOffList);

    var GridType_508005_sortOffList = ["nse_grd_50430", "nse_grd_50431", "nse_grd_50432", "nse_grd_50433", "usr_grd_11073"];
    sortOffList = sortOffList.concat(GridType_508005_sortOffList);

    var GridType_508008_sortOffList = ["usr_grd_11228", "del_grd_50446", "del_grd_50447", "del_grd_50451", "del_grd_50452", "del_grd_50456", "del_grd_50448", "del_grd_50457", "del_grd_50453", "del_grd_50454", "del_grd_50455", "del_grd_50444", "del_grd_50445", "del_grd_50449", "del_grd_50450"];
    sortOffList = sortOffList.concat(GridType_508008_sortOffList);

    var GridType_507005_sortOffList = ["rl_grd_50576", "rl_grd_50577", "rl_grd_50578", "rl_grd_50579", "rl_grd_50580", "rl_grd_50581", "rl_grd_50582", "rl_grd_50583", "rl_grd_50584"];
    sortOffList = sortOffList.concat(GridType_507005_sortOffList);

    var GridType_122098_sortOffList = ["rpt_grd_50656", "rpt_grd_50657", "rpt_grd_50658", "rpt_grd_50659", "rpt_grd_50660", "rpt_grd_50661", "rpt_grd_50662", "rpt_grd_50663", "rpt_grd_50664", "rpt_grd_50665", "rpt_grd_50666", "rpt_grd_50667", "rpt_grd_50668", "rpt_grd_50669", "rpt_grd_50670", "rpt_grd_50671", "rpt_grd_50672", "rpt_grd_50673", "rpt_grd_50674", "rpt_grd_50675", "rpt_grd_50676", "rpt_grd_50677", "rpt_grd_50678", "rpt_grd_50679", "rpt_grd_50680", "rpt_grd_50681", "rpt_grd_50682", "rpt_grd_50683", "rpt_grd_50684"];
    sortOffList = sortOffList.concat(GridType_122098_sortOffList);

    var GridType_122100_sortOffList = ["rpt_grd_50692", "rpt_grd_50693", "rpt_grd_50694", "rpt_grd_50695", "rpt_grd_50696", "rpt_grd_50697", "rpt_grd_50698", "rpt_grd_50699", "rpt_grd_50700"];
    sortOffList = sortOffList.concat(GridType_122100_sortOffList);

    var GridType_114010_sortOffList = ["usr_grd_50739", "usr_grd_11086", "usr_grd_11087", "usr_grd_11088", "usr_grd_11089", "usr_grd_11090", "usr_grd_11091", ];
    sortOffList = sortOffList.concat(GridType_114010_sortOffList);

    var GridType_114010_sortOffList = ["usr_grd_50740"];
    sortOffList = sortOffList.concat(GridType_114010_sortOffList);

    var GridType_114005_sortOffList = ["usr_grd_50755", "usr_grd_11094", "usr_grd_11095", "usr_grd_11096", "usr_grd_11097", "usr_grd_11098", "usr_grd_50752"];
    sortOffList = sortOffList.concat(GridType_114005_sortOffList);

    var GridType_114071_sortOffList = ["tra_grd_16190", "tra_grd_16191", "tra_grd_16192", "tra_grd_16193", "tra_grd_16194", "tra_grd_16195", "tra_grd_16196", "tra_grd_16197", "tra_grd_16198", "tra_grd_16199", "tra_grd_16200"];
    sortOffList = sortOffList.concat(GridType_114071_sortOffList);

    //BYSA
    var GridType_114101_sortOffList = ["tra_grd_50651", "tra_grd_50652", "tra_grd_50653", "tra_grd_50654", "tra_grd_50655", "tra_grd_50656", "tra_grd_50657", "tra_grd_50658", "tra_grd_50659", "tra_grd_50660", "tra_grd_50661"];
    sortOffList = sortOffList.concat(GridType_114101_sortOffList);
    //BYSA
    var GridType_114102_sortOffList = ["tra_grd_50741", "tra_grd_50742", "tra_grd_50743", "tra_grd_50744", "tra_grd_50745", "tra_grd_50746", "tra_grd_50747", "tra_grd_50748", "tra_grd_50749", "tra_grd_50750", "tra_grd_50783", "tra_grd_50784"];
    sortOffList = sortOffList.concat(GridType_114102_sortOffList);

    var GridType_114103_sortOffList = ["dis_grd_50754", "dis_grd_50755", "dis_grd_50756", "dis_grd_50757", "dis_grd_50758"];
    sortOffList = sortOffList.concat(GridType_114103_sortOffList);

    var GridType_114104_sortOffList = ["dis_grd_50759", "dis_grd_50760", "dis_grd_50761", "dis_grd_50762", "dis_grd_50763"];
    sortOffList = sortOffList.concat(GridType_114104_sortOffList);

    var GridType_114109_sortOffList = ["dis_grd_52011", "dis_grd_52012", "dis_grd_52013", "dis_grd_52014", "dis_grd_52015", "dis_grd_52016", "dis_grd_52017", "dis_grd_52018", "dis_grd_52019", "dis_grd_52042", "dis_grd_52043"];
    sortOffList = sortOffList.concat(GridType_114109_sortOffList);

    var GridType_114110_sortOffList = ["dis_grd_52020", "dis_grd_52021", "dis_grd_52022", "dis_grd_52023", "dis_grd_52024", "dis_grd_52025", "dis_grd_52026", "dis_grd_52027", "dis_grd_52028", "dis_grd_52029", "dis_grd_52030", "dis_grd_52031", "dis_grd_52044", "dis_grd_52045"];
    sortOffList = sortOffList.concat(GridType_114110_sortOffList);

    var GridType_114115_sortOffList = ["usr_grd_54015", "usr_grd_54016", "usr_grd_54017", "usr_grd_54018"];
    sortOffList = sortOffList.concat(GridType_114115_sortOffList);

    var GridType_114116_sortOffList = ["usr_grd_54030", "usr_grd_54023", "usr_grd_54019", "usr_grd_54020", "usr_grd_54021", "usr_grd_54022"];
    sortOffList = sortOffList.concat(GridType_114116_sortOffList);
    var GridType_114117_sortOffList = ["dis_grd_52032", "dis_grd_52033", "dis_grd_52034", "dis_grd_52035", "dis_grd_52036", "dis_grd_52037", "dis_grd_52038", "dis_grd_52039", "dis_grd_52040", "dis_grd_52041"];
    sortOffList = sortOffList.concat(GridType_114117_sortOffList);

    var GridType_114107_sortOffList = ["dis_grd_52001", "dis_grd_52002", "dis_grd_52003", "dis_grd_52004", "dis_grd_52005"];
    sortOffList = sortOffList.concat(GridType_114107_sortOffList);

    var GridType_114108_sortOffList = ["dis_grd_52006", "dis_grd_52007", "dis_grd_52008", "dis_grd_52009", "dis_grd_52010"];
    sortOffList = sortOffList.concat(GridType_114108_sortOffList);

    var GridType_114118_sortOffList = ["dis_grd_53013", "dis_grd_53014", "dis_grd_53015", "dis_grd_53016", "dis_grd_53017", "dis_grd_53018", "dis_grd_53019", "dis_grd_53020", "dis_grd_53021", "dis_grd_53022", "dis_grd_53023", "dis_grd_53024", "dis_grd_53007", "dis_grd_53008", "dis_grd_53009", "dis_grd_53010", "dis_grd_53011", "dis_grd_53012"];
    sortOffList = sortOffList.concat(GridType_114118_sortOffList);

    var GridType_114119_sortOffList = ["dis_grd_53040", "dis_grd_53041", "dis_grd_53042", "dis_grd_53043", "dis_grd_53044", "dis_grd_53045", "dis_grd_53046", "dis_grd_53047", "dis_grd_53048", "dis_grd_53049", "dis_grd_53051", "dis_grd_53034", "dis_grd_53035", "dis_grd_53036", "dis_grd_53037", "dis_grd_53038", "dis_grd_53039", "dis_grd_53050"];
    sortOffList = sortOffList.concat(GridType_114119_sortOffList);

    var GridType_114120_sortOffList = ["tra_grd_53057", "tra_grd_53058", "tra_grd_53059", "tra_grd_53060", "tra_grd_53061", "tra_grd_53064", "tra_grd_53065", "tra_grd_53066", "tra_grd_53067", "tra_grd_53068", "tra_grd_53069", "tra_grd_53070",
                                        "tra_grd_53071", "tra_grd_53072"];
    sortOffList = sortOffList.concat(GridType_114120_sortOffList);

    var GridType_114121_sortOffList = ["tra_grd_53073", "tra_grd_53074", "tra_grd_53075", "tra_grd_53076", "tra_grd_53077", "tra_grd_53080", "tra_grd_53081", "tra_grd_53082", "tra_grd_53083", "tra_grd_53084", "tra_grd_53085", "tra_grd_53086", "tra_grd_53087", "tra_grd_53088", "tra_grd_53089", "tra_grd_53090"];
    sortOffList = sortOffList.concat(GridType_114121_sortOffList);

    var GridType_114122_sortOffList = ["dis_grd_55001", "dis_grd_55002", "dis_grd_55003", "dis_grd_55004", "dis_grd_55005", "dis_grd_55006", "dis_grd_55007", "dis_grd_55008", "dis_grd_55009", "dis_grd_55010", "dis_grd_55011"];
    sortOffList = sortOffList.concat(GridType_114122_sortOffList);

    var GridType_114123_sortOffList = ["dis_grd_55015", "dis_grd_55016", "dis_grd_55017", "dis_grd_55018", "dis_grd_55019", "dis_grd_55020", "dis_grd_55021", "dis_grd_55022", "dis_grd_55023", "dis_grd_55024"];
    sortOffList = sortOffList.concat(GridType_114123_sortOffList);
    var GridType_114124_sortOffList = ["usr_grd_54101", "usr_grd_54102", "usr_grd_54103", "usr_grd_54104"];
    sortOffList = sortOffList.concat(GridType_114124_sortOffList);
    var GridType_114125_sortOffList = ["rpt_grd_53110", "rpt_grd_53111", "rpt_grd_53112", "rpt_grd_53113"];
    sortOffList = sortOffList.concat(GridType_114125_sortOffList);

    var GridType_114127_sortOffList = ["dis_grd_54162", "dis_grd_54163", "dis_grd_54164", "dis_grd_54165", "dis_grd_54166", "dis_grd_54160", "dis_grd_54161", "usr_grd_11073"];
    sortOffList = sortOffList.concat(GridType_114127_sortOffList);
    this.element.find('thead').remove('th');

    var GridType_114128_sortOffList = ["dis_grd_51019", "dis_grd_51020", "dis_grd_51021", "dis_grd_51022", "dis_grd_51025"];
    sortOffList = sortOffList.concat(GridType_114128_sortOffList);

    var GridType_114129_sortOffList = ["rul_grd_55089", "rul_grd_55090", "rul_grd_55091", "rul_grd_55092", "rul_grd_55093"];
    sortOffList = sortOffList.concat(GridType_114129_sortOffList);

    var GridType_114131_sortOffList = ["rul_grd_55324", "rul_grd_55325", "rul_grd_55326", "rul_grd_55327"];
    sortOffList = sortOffList.concat(GridType_114131_sortOffList);

    objThis = this;
    var nTotalWidth = 0;



    if (this.column[0].SequenceNumber.length > 3) {
        GenerateHeader.init(this.column, this.element.find("thead"), this);
        nTotalWidth = GenerateHeader.totalWidth;
        objThis.bWidthFlag = GenerateHeader.bWidthFlag;
    }
    else {
        $.each(this.column, function (index) {
            var sortFlag = true;
            if ($.inArray(this.Key, sortOffList) > -1)
                sortFlag = false;
            objThis.element.find('thead>tr').append('<th>' + this.Value + '</th>');
            objThis.arrColumns.push({
                'mDataProp': this.Key,
                'sDefaultContent': '',
                'bSortable': sortFlag,
                "bStateSave": true,
                "sWidth": (this.Width * 7) + "px",
                "sClass": "text-" + this.Align,
                'fnRender': objThis.format["GridType_" + objThis.GridType][this.Key]
            });

            nTotalWidth = nTotalWidth + (parseInt(this.Width) * 7) + 17;
            if (objThis.bWidthFlag == true && this.Width == "0") {
                objThis.bWidthFlag = false;
            }
        });
    }

    if (objThis.bWidthFlag) {
        this.element.css({ 'table-layout': 'fixed', 'width': nTotalWidth + 'px' });
    }

    if (!FetchCookie(objThis.GridType)) {
        var dataTableState = {};
        dataTableState["iDisplayStart"] = 0;
        dataTableState["iDisplayLength"] = 10;
        dataTableState["Search"] = "";
        dataTableState["aaSorting"] = [];
        WriteCookie(objThis.GridType, JSON.stringify(dataTableState));
    }

}

/////
// Generating the datatable grid instance as per the initialization
/////
DatatableGrid.prototype.renderGrid = function () {
    var objThis = this;
    var paramDatatable = {
        bServerSide: true,
        sAjaxSource: $('[gridtype=' + objThis.GridType + '][name=AjaxHandler]').val(),
        fnServerData: function (sSource, aoData, fnCallback, oSettings) {
            oSettings.jqXHR = $.ajax({
                "dataType": 'json',
                "type": "POST",
                headers: getRVToken(),
                "url": sSource,
                "data": aoData,
                "success": fnCallback
            });
        },
        bProcessing: objThis.ShowProcessing,
        sServerMethod: "POST",
        bFilter: false,
        cache: false,
        bLengthChange: true,
        scrollX: true,
        iDisplayLength: objThis.sDisplayLength,
        aLengthMenu: objThis.sPagingLengthMenu,
        //sPaginationType: "full_numbers",
        oLanguage: {
            "sSearch": "Search all columns:",
            "sZeroRecords": objThis.NoRecordsfoundMessage,
            "sEmptyTable": objThis.NoRecordsfoundMessage,
            "sInfoEmpty": ""
        },
        aoColumns: this.arrColumns,
        aaSorting: isDefaultNoSort ? [] : [[this.sortCol, "asc"]],
        fnInfoCallback: function (oSettings, iStart, iEnd, iMax, iTotal, sPre) {
            var dataTableState = [];
            if (FetchCookie(objThis.GridType)) {
                dataTableState = jQuery.parseJSON(FetchCookie(objThis.GridType));
            }
            dataTableState["iDisplayStart"] = iStart - 1;
            dataTableState["iDisplayLength"] = oSettings._iDisplayLength;
            var tmpArr = oSettings.aaSorting;
            dataTableState["aaSorting"] = tmpArr;
            WriteCookie(objThis.GridType, JSON.stringify(dataTableState));
            return "Showing " + iStart + " to " + iEnd + " of " + iTotal + " entries";
        },
        fnDrawCallback: function (oSettings) {

            if (objThis.GridType == 114048 || objThis.GridType == 114117 || objThis.GridType == 114049 || objThis.GridType == 114045 || objThis.GridType == 114050 || objThis.GridType == 114059 || objThis.GridType == 114053 || objThis.GridType == 114061 || objThis.GridType == 114078 || objThis.GridType == 114038 || objThis.GridType == 114122 || objThis.GridType == 114123) {
                $("body").removeClass("loading");
            }
            $(oSettings.nTableWrapper).find('.dataTables_paginate, .dataTables_length, .dataTables_info').hide();
            if (oSettings._iDisplayLength < oSettings.fnRecordsDisplay()) {
                $(oSettings.nTableWrapper).find('.dataTables_paginate, .dataTables_info').show();
            }
            if (objThis.CallBackFunction != undefined && typeof objThis.CallBackFunction === 'function') {
                objThis.CallBackFunction.call();
            }
            // If you use the iDisplayLength ([10,25,50,100] ) then below is the issue you face so, the length is hardcoded to 10
            // Total records 20 then page per record will be displayed. 
            // If you select 25 from page per record dropdown then it will hide the page per record div(As there are only 20 total records and your iDisplaylength is 25).
            // And now there will be no way to get back to 10 records.
            if (oSettings.fnRecordsDisplay() > 10) {
                $(oSettings.nTableWrapper).find('.dataTables_length').show();
            }
            if ($(oSettings.nTableWrapper).find('div>table.data-table').css('table-layout') != "fixed") {
                //if (objThis.arrColumns.length <= 6) {
                //    $(oSettings.nTableWrapper).find('div.row:last').css({ 'width': $(oSettings.nTableWrapper).find('div>table.data-table').css('width') });
                //}
            }
            else {
                $(oSettings.nTableWrapper).find('div>table.data-table>tbody>tr>td').css({ 'word-wrap': 'break-word' });
            }
            removeLinkInGrid(oSettings.nTableWrapper);
            //$(oSettings.nTableWrapper).find("div>table.data-table tbody tr td.tblCurrency").toNumber().formatCurrency({ roundToDecimalPlace: 0, symbol: '' });

        },
        fnServerParams: function (aoData) {
            if (objThis.GridType == 114048 || objThis.GridType == 114117 || objThis.GridType == 114049 || objThis.GridType == 114045 || objThis.GridType == 114050 || objThis.GridType == 114059 || objThis.GridType == 114053 || objThis.GridType == 114061 || objThis.GridType == 114078 || objThis.GridType == 114038 || objThis.GridType == 114122 || objThis.GridType == 114123) {
                $("body").addClass("loading");
            }

            objThis.element.parent().find('.dataTables_paginate, .dataTables_length, .dataTables_info').hide();
            var searchString = "";
            var dataTableState = {};
            if (FetchCookie(objThis.GridType)) {
                dataTableState = jQuery.parseJSON(FetchCookie(objThis.GridType));
                if (dataTableState["Search"] != undefined && dataTableState["Search"] != "") {
                    searchString = dataTableState["Search"];
                }
            }
            if (searchString != "") {
                var searchParams = searchString.split("|#|");
                var counter = 1;
                var bSearchPresent = false;
                var DependentCookieValue = "";
                $.each(searchParams, function (index, val) {
                    if (objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("#" + counter).prop('nodeName') == "SELECT") {
                        if (val != 0 && val != "") {
                            objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("select#" + counter).val(val);
                            if (objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("select#" + counter).hasClass("selectpicker")) {
                                objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("select#" + counter).selectpicker();
                                var optionArr = val.split(",");
                                var optionString = "[";
                                $.each(optionArr, function (key, value) {
                                    if (optionString != "[")
                                        optionString = optionString + ",";
                                    optionString = optionString + value;
                                });
                                optionString = optionString + "]";
                                objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("select#" + counter).selectpicker('val', JSON.parse(optionString));
                            }

                            //This to set values for the dependent dropdown calls which are filled based on the selected value...
                            if (objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("select#" + counter).hasClass("hasDependent")) {
                                objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("select#" + counter).attr("SelectedChild", "" + searchParams[counter + 1]);
                                objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("select#" + counter).trigger('change');
                            }
                            bSearchPresent = true;
                        }
                    } else if (objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("#" + counter).prop('nodeName') == "INPUT") {
                        if (objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("#" + counter).attr("type") == "checkbox") {
                            if (val == "0") {
                                objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("#" + counter).prop("checked", false);
                                bSearchPresent = true;
                            } else if (val == "1") {
                                objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("#" + counter).prop("checked", true);
                                bSearchPresent = true;
                            }
                        } else {
                            if (val != "") {
                                objThis.element.parents('.search[gridtype=' + objThis.GridType + ']').find("#" + counter).val(val);
                                bSearchPresent = true;
                            }
                        }
                    }
                    counter++;
                });
                //If want to show the search panel open when showing saved search
                //if (bSearchPresent) {
                //    objThis.element.closest("section.content.search").find("button[data-target='#filter-panel']").click();
                //}
            }

            searchString = fetchSearch(objThis.element, objThis.GridType).join('|#|');
            aoData.push({ name: "Search", value: searchString });
            if ($.inArray(objThis.GridType, GridsToNotMaintainPagingOnly) == -1 && $.inArray(objThis.GridType, GridsToMaintainSearchAndPaging) != -1) {
                //$("body").removeClass("loading");
                dataTableState["Search"] = searchString;
                WriteCookie(objThis.GridType, JSON.stringify(dataTableState));
            }
        }

    };
    if (this.element.css('table-layout') == 'fixed') {
        paramDatatable['bAutoWidth'] = false;
    }
    paramDatatable["bPaginate"] = this.bIsPagination;
    paramDatatable["bServerSide"] = this.bIsServerSide;
    if (this.sDom) {
        paramDatatable["sDom"] = this.sDom;
    }
    if (!this.bIsServerSide) {
        paramDatatable["bFilter"] = true;
    }

    if (FetchCookie(objThis.GridType)) {
        var dataTableState = jQuery.parseJSON(FetchCookie(objThis.GridType));
        paramDatatable["iDisplayStart"] = dataTableState["iDisplayStart"];
        paramDatatable["iDisplayLength"] = dataTableState["iDisplayLength"];
        if (dataTableState["aaSorting"] != null && dataTableState["aaSorting"] != "" && dataTableState["aaSorting"].length > 0) {
            paramDatatable["aaSorting"] = dataTableState["aaSorting"];
        }
    }

    this.tableElement = this.element.dataTable(paramDatatable);
    if (isIE() == 9) {
        this.tableElement.wrapAll('<div class="row" style="overflow-x:scroll"></div>');
    } else {

        this.tableElement.wrapAll('<div class="row" style="overflow-x:auto"></div>');
    }
}

////
// Datatable search button event register
////
DatatableGrid.prototype.search = function (btnSearch) {
    var objThis = this;
    if (this.bIsServerSide) {
        $('#' + btnSearch).click(function () {
            if (FetchCookie(objThis.GridType)) {
                dataTableState = jQuery.parseJSON(FetchCookie(objThis.GridType));
                dataTableState["Search"] = "";
                WriteCookie(objThis.GridType, JSON.stringify(dataTableState));
            }
            objThis.tableElement.fnDraw();
        });
    }
    else {
        $('#' + btnSearch).click(function () {
            $('.clientSearch[gridtype ="' + objThis.GridType + '"] select option:selected').each(function () {
                var data = $(this).text();
                if (data.toLowerCase() != "select")
                    objThis.tableElement.fnFilter("^" + data + "$", $(this).parents('select').attr('id'), true, false);
                else
                    objThis.tableElement.fnFilter("", $(this).parents('select').attr('id'));
            });

            $('.clientSearch[gridtype ="' + objThis.GridType + '"]  input').each(function () {
                var data = $(this).val();
                objThis.tableElement.fnFilter(data, $(this).attr('id'), true, false);
            });

            $('.clientSearch[gridtype ="' + objThis.GridType + '"] ').next().find('input[type=button].extra-handler').trigger('click');
        });
    }
}

function WriteCookie(GridType, GridStateString) {
    if ($.inArray("" + GridType, GridsToMaintainSearchAndPaging) != -1) {
        var val = "";
        val = encrypt(GridStateString);
        GridStateString = val;
        $.cookie("G" + GridType, GridStateString, { 'path': '/' });
    }
}

function FetchCookie(GridType) {
    if ($.inArray("" + GridType, GridsToMaintainSearchAndPaging) != -1) {
        if ($.cookie("G" + GridType)) {
            var val = "";
            val = decrypt($.cookie("G" + GridType));
            return val;
        } else {
            return $.cookie("G" + GridType);
        }
    } else {
        return null;
    }
}

////
// Added ajax delete record and refresh the list
////
DatatableGrid.prototype.deleteRow = function () {
    var objThis = this;
    // if (this.element.find('*[name=deleteRow]').length > 0) {
    this.element.delegate('*[name=deleteRow]', 'click', function () {
        sTitle = "Confirmation";
        sMessage = "Are you sure you want to delete the record?";
        var objThisButton = this;
        $.confirm({
            title: sTitle,
            text: sMessage,
            confirm: function () {
                if (objThis.GridType != 507005) {
                    data = {};
                    if ($(objThisButton).attr('queryString') != undefined) {
                        var obj = eval('{ queryParam: ' + $(objThisButton).attr("queryString") + ' }');
                        $.each(obj, function (key, value) {
                            data[value.ID] = value.key;
                        });
                    }
                    else {
                        var key = $(objThisButton).attr('ID');
                        data[key] = $(objThisButton).attr('key');
                    }
                    var RvToken = getRVToken();
                    data['__RequestVerificationToken'] = RvToken.version;
                    $.ajax({
                        "url": $('*[name=deleteRowURL][gridtype=' + objThis.GridType + ']').val(),
                        "type": 'post',
                        headers: getRVToken(),
                        "data": data,
                        "success": function (data) {
                            $("#btntblGrid").show();
                            $("#Wrn_Msg").hide();
                            if (data.status == undefined) {
                                data = JSON.parse(data);
                            }
                            if (data.status || data.status == true) {
                                showMessage(data.Message['success'], true);
                                objThis.tableElement.fnDraw();
                                if (objThis.GridType == 114010) {
                                    location.reload();
                                }
                                if (objThis.GridType == 114005) {
                                    location.reload();
                                }
                                if (objThis.GridType == 114115 || objThis.GridType == 114116) {
                                    location.reload();
                                }
                            }
                            else {
                                showMessage(data.Message['error'], false);
                            }
                        },
                        "error": function (jqXHR, textStatus, errorThrown) {
                            //alert(errorThrown);
                        }
                    });
                }
                else {
                    var data = {};
                    if ($(objThisButton).attr('queryString') != undefined) {
                        var obj = eval('{ queryParam: ' + $(objThisButton).attr("queryString") + ' }');
                        $.each(obj, function (key, value) {
                            data[value.ID] = value.key;
                        });
                    }
                    $.ajax({
                        "url": $('[name=deleteRowURL]')[0].value,
                        "type": 'post',
                        "data": data,
                        "async": false,
                        "success": function (result) {
                            if (result.status === "success") {
                                window.location.href = result.redirectUrl;
                            }
                        },
                        "error": function (jqXHR, textStatus, errorThrown) {
                            //alert(errorThrown);
                        }
                    });
                }
            },
            cancel: function () {
            },
            confirmButton: "Yes I Confirm",
            cancelButton: "No",
            post: true,
            confirmButtonClass: "btn btn-success",
            cancelButtonClass: "btn-danger",
            dialogClass: "modal-dialog modal-md"
        });

    });

}

////
// Reset the search fields like input and select.
////
DatatableGrid.prototype.reset = function () {
    var objThis = this;
    var btnReset = "btnReset";
    var GridType = this.GridType;
    var acid;
    $('[dt_name=' + btnReset + '][dt_gridType=' + GridType + ']').click(function () {
        $.each(($(".search[gridtype=" + GridType + "] input[GridType=" + GridType + "][type=text]:not('[type=hidden]'):not('[type=button]')")), function () {
            $(this).val("");
        });
        $.each(($('.search[gridtype=' + GridType + ']').find("select[GridType=" + GridType + "]:not('[type=hidden]')")), function () {
            $(this).val("0");
        });
        $.each(($('.search[gridtype=' + GridType + ']').find("input[GridType=" + GridType + "][type=checkbox]:not('[type=hidden]')")), function () {
            $(this).attr("checked", false);
        });
        if (GridType == "114079") {
            ($('.search[gridtype=' + GridType + ']').find("select[GridType=" + GridType + "]:not('[type=hidden]')")[2])[0].selected = true;
        }
        $('.selectpicker').selectpicker('deselectAll');

        if (FetchCookie(objThis.GridType)) {
            dataTableState = jQuery.parseJSON(FetchCookie(objThis.GridType));
            dataTableState["Search"] = "";
            WriteCookie(objThis.GridType, JSON.stringify(dataTableState));
        }
        acid = (GridType == "114048") ? 165 : (GridType == "114049") ? 167 : (GridType == "114050") ? 186 :
            (GridType == "114059") ? 187 : (GridType == "114001") ? 1 : (GridType == "114002") ? 5 :
            (GridType == "114052") ? 186 : (GridType == "114023") ? 197 : (GridType == "114132") ? 197 : 0;

        if (GridType == "114048" || GridType == "114049" || GridType == "114050" || GridType == "114059") {
            $.ajax({
                method: "POST",
                url: "../DatatableGrid/AjaxHandler",
                datatype: 'json',
                async: false,
                data: { "gridtype": GridType, "acid": acid, "ClearSearchFilter": "True" },
                success: function (data) {
                    if (data.status == false) {
                        objThis.tableElement.fnDraw();
                    }
                },
                error: function (data) { }
            });
        }
        else {
            objThis.tableElement.fnDraw();
        }
    });
}

var CHECKBOX = 'checkbox', LINK = 'link', DROPDOWN = 'dropdown';

function createActionControlArray(obj, gridcolumntype) {
    var data = [];

    $("input[type='hidden'].gridtypecontrol[gridcolumntype='" + gridcolumntype + "']").each(function () {

        var url = $(this).val();
        var strParams = $(this).attr("param");
        var type = $(this).attr("ctrtype");
        var arrProperties = strParams.match(/<([^>]+)>/g);
        $(arrProperties).each(function () {
            var columnsName = this.replace('<', '');
            columnsName = columnsName.replace('>', '');
            strParams = strParams.replace(this, ("" + obj.aData[columnsName]).replace(/'/g, '&#39;'));
        });

        var parameters = '{ param:' + strParams + '}';
        data.push(
            {
                url: url,
                type: type,
                param: eval('(' + parameters + ')').param
            }
        );
    });
    return GenerateComponent(data);
}

function createActionControlArray_For_NSE_DOWNLOAD(obj, gridcolumntype) {
    var data = [];
    $("input[type='hidden'].gridtypecontrol[gridcolumntype='" + gridcolumntype + "']").each(function () {

        var url = $(this).val();
        var strParams = $(this).attr("param");
        var type = $(this).attr("ctrtype");
        var arrProperties = strParams.match(/<([^>]+)>/g);
        $(arrProperties).each(function () {
            var columnsName = this.replace('<', '');
            columnsName = columnsName.replace('>', '');
            strParams = strParams.replace(this, ("" + obj.aData[columnsName]).replace(/'/g, '&#39;'));
        });

        if (obj.aData['nse_grd_50431'] != null) {
            var No_Of_Employees = obj.aData['nse_grd_50431'];
            if (No_Of_Employees == 0) {
                strParams = strParams.replace('NSE_View_Delete', 'NSE_View_Delete_For_Zero_Employee');
                strParams = strParams.replace('Download_Pdf', 'Download_Pdf_For_Zero_Employee');
                strParams = strParams.replace('Download_Excel', 'Download_Excel_For_Zero_Employee');
                strParams = strParams.replace('Download_Doc', 'Download_Doc_For_Zero_Employee');
            }
        }
        if (obj.aData['Groupsubmissionflag'] == 1) {
            //strParams = strParams.replace('View/Delete', 'View');
            //strParams = strParams.replace('Download_Pdf', 'Download_Pdf_For_View_Only');
            strParams = strParams.replace('NSE_View_Delete', 'NSE_View_Delete_For_View_Employee');
            strParams = strParams.replace('Download_Pdf', 'Download_Pdf_For_View_Only');
        }
        var parameters = '{ param:' + strParams + '}';
        data.push(
            {
                url: url,
                type: type,
                param: eval('(' + parameters + ')').param
            }
        );
    });
    return GenerateComponent(data);
}


/////
// Datatable grid column formatting according to grid number
/////
DatatableGrid.prototype.format = {

    //CO User List
    'GridType_114001': {
        'usr_grd_11072': function (obj, type) {
            var status = '';
            switch (obj.aData['usr_grd_11072']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //EmployeeUserList
    'GridType_114002': {
        'usr_grd_11085': function (obj, type) {
            sUrlView = "";
            sUrlEdit = "";
            if (obj.aData['UserTypeCodeId'] == $('#EmployeeEdit').attr('datatype')) {
                sUrlEdit = "" + $('#EmployeeEdit').val();
            }
            else if (obj.aData['UserTypeCodeId'] == $('#CorporateInsiderEdit').attr('datatype')) {
                sUrlEdit = "" + $('#CorporateInsiderEdit').val();
            }
            else if (obj.aData['UserTypeCodeId'] == $('#EmployeeInsiderEdit').attr('datatype')) {
                sUrlEdit = "" + $('#EmployeeInsiderEdit').val();
            }
            else {
                sUrlEdit = "" + $('#NonEmployeeInsiderEdit').val();
            }
            var data = [{
                url: sUrlEdit,
                type: LINK,
                param: {
                    // text: $("#DisplayEdit").val(),
                    href: sUrlEdit + '?nUserInfoID=' + obj.aData['UserInfoID'] + "&acid=" + $('#EmployeeEdit').attr("acid"),
                    //    href: sUrlEdit + '&nUserInfoID=' + obj.aData['UserInfoID'],
                    "class": "display-icon icon icon-edit"
                }
            },
            {

                url: $('*[name=deleteRowURL][gridtype=' + objThis.GridType + ']').val(),
                type: LINK,
                param: {
                    href: "javascript:void(0);",
                    name: "deleteRow",
                    queryString: "[ { ID: 'nDeleteUserId', key: " + obj.aData['UserInfoID'] + " },{ID: 'formId', key:73}]",
                    "class": "display-icon icon icon-delete"
                }
            }, {

                url: sUrlEdit,
                type: LINK,
                param: {

                    href: "javascript:ShowUnlockWindow(" + obj.aData['UserInfoID'] + "," + obj.aData['IsBlocked'] + ");",
                    "class": (obj.aData['IsBlocked'] && $("#ISMCQRequired").val() == "true") ? "fa fa-lock fa-2x" : (obj.aData['UserTypeCodeId'] == 101003 && $("#ISMCQRequired").val() == "true") ? "fa fa-unlock fa-2x" : "#",
                    "style": (obj.aData['IsBlocked']) ? "color:Red" : "color:Green"

                }
            }];
            return GenerateComponent(data);
        },
        'usr_grd_11079': function (obj, type) {
            var status = '';
            switch (obj.aData['usr_grd_11079']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
    },
    //DMATList
    'GridType_114005': {
        'usr_grd_11073': function (obj, type) {
            var isEdit = $('#canEdit').val();
            var isDel = $('#canDel').val();
            var data = [];

            if (obj.aData['DMATDetailsID'] != '') {
                $("#btnUserDemat").hide();
                $("#btn_User_Demat").show();
            }

            if (isEdit == 'True') {
                $("#RelGrid").hide();
                $('#RelCreateGrid').show();
                $('#EmpInfo').show();
                $("#SaveNProced").hide();
                var edit_link = {
                    url: $("#DisplayEdit").val(),
                    type: LINK,
                    param: {
                        href: "javascript:void(0);",
                        "class": "btnEditDMATDetails display-icon icon icon-edit",
                        "data-details": obj.aData['DMATDetailsID']
                    }

                };

                data.push(edit_link);
            }

            if (isDel == 'True') {
                var del_link = {
                    url: $('*[name=deleteRowURL][gridtype=' + objThis.GridType + ']').val(),
                    type: LINK,
                    param: {
                        href: "javascript:void(0);",
                        name: "deleteRow",
                        queryString: "[ { ID: 'nDMATDetailsID', key: " + obj.aData['DMATDetailsID'] + " },{ID: 'formId', key:74}]",
                        "class": "display-icon icon icon-delete"
                    }
                };
                data.push(del_link);
            }
            return GenerateComponent(data);
        },

        //Relative Demat Status
        'usr_grd_50755': function (obj, type) {
            var status = '';
            switch (obj.aData['usr_grd_50752']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        //Employee Demat Status
        'usr_grd_50752': function (obj, type) {
            if (obj.aData['DMATDetailsID'] != "") {
                $("#btnUserDemat").hide();
                $("#btn_User_Demat").show();
                //alert(obj.aData['DMATDetailsID']);
            }
            var status = '';
            switch (obj.aData['usr_grd_50752']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
    },
    //DocumentList
    'GridType_114006': {
        //DocumentName
        'usr_grd_11099': function (obj, type) {
            var data = [
            {
                url: $("#DownloadDocument_View").val(),
                type: LINK,
                param: {
                    text: obj.aData['usr_grd_11099'],
                    href: $("#DownloadDocument_View").val() + "&nDocumentDetailsID=" + obj.aData['DocumentId'],
                }
            },
            ];
            return GenerateComponent(data);
        },
        //Action
        'usr_grd_11073': function (obj, type) {
            var isEdit = $('#canEdit_doc').val();
            var isDel = $('#canDel_doc').val();
            var data = [];

            if (isEdit == 'True') {
                var edit_link = {
                    url: $("#EditDocument").val(),
                    type: LINK,
                    param: {
                        "class": "btnEditDocumentDetails display-icon icon icon-edit",
                        href: "javascript:void(0);",
                        url: $("#EditDocument").val(),
                        "data-mapToTypeCodeId": obj.aData['MapToTypeCodeId'],
                        "data-mapToId": obj.aData['MapToId'],
                        "data-documentDetailsID": obj.aData['DocumentId'],
                        "data-purposeCodeId": obj.aData['PurposeCodeId']
                    }
                };

                data.push(edit_link);
            }

            if (isDel == 'True') {
                var del_link = {
                    url: $('*[name=deleteRowURL][gridtype=' + objThis.GridType + ']').val(),
                    type: LINK,
                    param: {
                        href: "javascript:void(0);",
                        name: "deleteRow",
                        "class": "display-icon icon icon-delete",
                        queryString: "[ { ID: 'nDocumentDetailsID', key: " + obj.aData['DocumentId'] + " },{ ID: 'sGUID', key: '" + obj.aData['GUID'] + "' }, { ID: 'nMapToTypeCodeId', key: " + obj.aData['MapToTypeCodeId'] + " }, { ID: 'nMapToId', key: " + obj.aData['MapToId'] + " }, { ID: 'nPurposeCodeId', key: " + obj.aData['PurposeCodeId'] + " },{ ID: 'formId', key: " + 75 + " }  ]"
                    }
                };

                data.push(del_link);
            }
            return GenerateComponent(data);
        }
    },
    //Companyist
    'GridType_114007': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'cmp_grd_13004': function (obj, type) {
            var str = "";
            if (obj.aData['cmp_grd_13004'] == true) {
                str = '<input type="checkbox" checked="checked" disabled = "disabled"/>'
            } else {
                str = '<input type="checkbox"  disabled = "disabled"/>'
            }
            return str;
        }
    },

    'GridType_114122': {
        'dis_grd_55011': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + 'dis_grd_55011');
        },

        //'dis_grd_55009': function (obj, type) {
        //    return dateTimeFormat(obj.aData['dis_grd_55009']);
        //},
        'dis_grd_55011': function (obj, type) {
            return dateTimeFormat(obj.aData['dis_grd_55011']);
        },
        
        //'dis_grd_55001': function (obj, type) {

        //    //    var str = '';
        //    //    var strnull = '';
        //    //    if (obj.aData['dis_grd_55011'] == null)
        //    //    {
        //    //        obj.aData['dis_grd_55011'] = strnull;
        //    //    }

        //    //     str = '<div class="form-group" id="sandbox-container" style="margin-left: 5px; margin-right: 5px;"> \
        //    //                    <div class="input-group date"> \
        //    //                        <input type="text" value="' + dateTimeFormat(obj.aData['dis_grd_55011']) + '" name="" onchange="UpdateUpsi(' + obj.aData['UserInfoId'] + ',' + obj.aData['Upsi_id'] + ')" id="Upsidate" class=" form-control valid" style="width:150px;"/> \
        //    //                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span> \
        //    //                    </div> \
        //    //                </div>';
        //    //var str = '<a onclick="UpdateUpsi(' + obj.aData['UserInfoId'] + ',' + obj.aData['UPSIDocumentId'] + ')" style="color:Blue;cursor:pointer;text-decoration:underline" title="Please click here to update Publish Date">' + obj.aData['dis_grd_55001'] + '</a>'
        //    //return str;
        //},

        'dis_grd_55011': function (obj, type) {
            var str;
            if (obj.aData['dis_grd_55011'] == null) {
                str = '<a onclick="UpdateUpsi(' + obj.aData['UserInfoId'] + ',' + obj.aData['UPSIDocumentId'] + ')" style="color:Blue;cursor:pointer;text-decoration:underline" title="Please click here to update Publish Date">' + 'Add date' + '</a>'
            } else {
                str = '<a onclick="UpdateUpsi(' + obj.aData['UserInfoId'] + ',' + obj.aData['UPSIDocumentId'] + ')" style="color:Blue;cursor:pointer;text-decoration:underline" title="Please click here to update Publish Date">' + dateTimeFormat(obj.aData['dis_grd_55011']) + '</a>'
            }
            return str;
        }

    },


    'GridType_114123': {
        'dis_grd_55024': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + 'dis_grd_55024');
        },

        'dis_grd_55024': function (obj, type) {
            return dateTimeFormat(obj.aData['dis_grd_55024']);
        },

    },




    //ComCodeList
    'GridType_114008': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'mst_grd_10005': function (obj, type) {
            return SetBoolean(obj.aData['mst_grd_10005']);
        }
    },
    //RoleMasterList
    'GridType_114009': {

        'usr_grd_11073': function (obj, type, row) {
            var objControl = createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
            if (obj.aData['RoleActivityCount'] > 0) {
                return objControl;
            }
            else {
                objControl = objControl.replace('clsRoleActivity', 'color-red');
                return objControl
            }
        },
        'usr_grd_12025': function (obj, type) {
            return SetBoolean(obj.aData['usr_grd_12025']);
        }
    },
    //UserRelativeList
    'GridType_114010': {
        'usr_grd_11073': function (obj, type) {
            var isEdit = $('#canEdit').val();
            var isDel = $('#canDel').val();
            if (isEdit == 'True') {
                $("#ConfirmDetails").hide();
                $("#RelGrid").hide();
                $('#RelCreateGrid').show();
                $('#EmpInfo').show();
                $('#emp_rel_detail_save').show();

            }
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },

        //Relative list for CO (Add Demat link)
        'usr_grd_50740': function (obj, type) {
            if (obj.aData['UserInfoId'] != '') {
                $("#ConfirmDetails").show();
                $("#btnProceed").hide();

            }
            var status = "";
            if (obj.aData['usr_grd_50740'] != null) {
                status = status + obj.aData['usr_grd_50740'];
            }
            var userInfoIdforRel = obj.aData['UserInfoId'];
            status = status + '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'
            if (obj.aData['usr_grd_11091'] == "" || obj.aData['usr_grd_11091'] == "-") {
                status = status + '<a class= "btn btn-success disabled "  onclick="NewDMATDetails(' + obj.aData['UserInfoId'] + ')" firstButton=" firstButton" style="color:white;">';
            }
            else {
                status = status + '<a class= "btn btn-success " onclick="NewDMATDetails(' + obj.aData['UserInfoId'] + ')" firstButton=" firstButton" style="color:white;">';
            }

            status = status + "Add demat";
            status = status + '</a> </br>';
            if (obj.aData['usr_grd_11091'] == "" || obj.aData['usr_grd_11091'] == "-") {
                status = status + '<p style="color:red">Cannot add Demat details as PAN number is not available</p>';
            }

            return status;
        },

        //Relative Status
        'usr_grd_50739': function (obj, type) {
            var status = '';
            switch (obj.aData['usr_grd_50739']) {
                case 102001:
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 102002:
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },

        'usr_grd_11085': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + 'usr_grd_11085');
        }

    },
    //CompanyFaceValueList
    'GridType_114011': {
        'cmp_grd_13013': function (obj, type) {
            return dateTimeFormat(obj.aData['cmp_grd_13013']);
        },
        'cmp_grd_13014': function (obj, type) {
            return formatIndianFloat(obj.aData['cmp_grd_13014']);//accounting.formatMoney(obj.aData['cmp_grd_13014'],"",2);//"<div class='currency'>"+obj.aData['cmp_grd_13014']+"</div>";
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //CompanyAuthorisedSharedCapitalList
    'GridType_114012': {
        'cmp_grd_13017': function (obj, type) {
            return dateTimeFormat(obj.aData['cmp_grd_13017']);
        },
        'cmp_grd_13018': function (obj, type) {
            return formatIndianNumber(obj.aData['cmp_grd_13018']); //accounting.formatNumber(obj.aData['cmp_grd_13018']);//$(obj.aData['cmp_grd_13014']).formatCurrency().val();
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //CompanyPaidUpSubscribeShareCapitalList
    'GridType_114013': {
        'cmp_grd_13020': function (obj, type) {
            return dateTimeFormat(obj.aData['cmp_grd_13020']);
        },
        'cmp_grd_13021': function (obj, type) {
            return formatIndianNumber(obj.aData['cmp_grd_13021']);//accounting.formatNumber(obj.aData['cmp_grd_13021']);//$(obj.aData['cmp_grd_13014']).formatCurrency().val();
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //CompanyListingDetailsList
    'GridType_114014': {
        'cmp_grd_13025': function (obj, type) {
            return dateTimeFormat(obj.aData['cmp_grd_13025']);
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //CompanyComplianceOfficerList
    'GridType_114015': {
        'cmp_grd_13033': function (obj, type) {
            return dateTimeFormat(obj.aData['cmp_grd_13033']);
        },
        'cmp_grd_13034': function (obj, type) {
            return dateTimeFormat(obj.aData['cmp_grd_13034']);
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //DelegateMasterList
    'GridType_114016': {
        'usr_grd_12014': function (obj, type) {
            return dateTimeFormat(obj.aData['usr_grd_12014']);
        },
        'usr_grd_12015': function (obj, type) {
            return dateTimeFormat(obj.aData['usr_grd_12015']);
        },
        'usr_grd_11073': function (obj, type) {
            var data = [{
                url: $('#DelegateEdit').val(),
                type: LINK,
                param: {
                    href: $('#DelegateEdit').val() + '&DelegationId=' + obj.aData['DelegationId'],
                    "class": "display-icon icon icon-shuffle"
                }
            },
            {
                url: $('*[name=deleteRowURL][gridtype=' + objThis.GridType + ']').val(),
                type: LINK,
                param: {
                    href: "javascript:void(0);",
                    name: "deleteRow",
                    queryString: "[ { ID: 'id', key: " + obj.aData['DelegationId'] + " },{ID: 'formId', key:76}]",
                    "class": "display-icon icon icon-delete"
                }
            }];
            return GenerateComponent(data);
        }
    },
    //DMATAccountHolderList
    'GridType_114017': {
        'usr_grd_11073': function (obj, type, row) {
            var data = [
            {
                url: $("#DisplayEdit").val(),
                type: LINK,
                param: {
                    href: "javascript:void(0);",
                    "class": "btnEditDMATHolderDetails display-icon icon icon-edit",
                    "data-details": obj.aData['DMATAccountHolderId']
                }
            },
            {
                url: $('*[name=deleteRowURL][gridtype=' + objThis.GridType + ']').val(),
                type: LINK,
                param: {
                    href: "javascript:void(0);",
                    name: "deleteRow",
                    queryString: "[ { ID: 'nDMATAccountHolderID', key: " + obj.aData['DMATAccountHolderId'] + " },{ID: 'formId', key:77}]",
                    "class": "display-icon icon icon-delete"
                }
            },
            ];
            return GenerateComponent(data);
        }
    },
    //ResourcesList
    'GridType_114018': {
        'usr_grd_11073': function (obj, type) {

            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //UserSeparationList
    'GridType_114019': {
        'usr_grd_11228': function (obj, type) {
            var str = '<input type="checkbox" class="cr-check chkUserRow" name="UserInfoModel[' + obj.aData['UserInfoID'] + '].UserInfoID" id="chk_' + obj.aData['UserInfoID'] + '" data-details="' + obj.aData['UserInfoID'] + '"/>';
            return str;
        },
        'usr_grd_11229': function (obj, type) {
            //var str = '<div class="form-group" id="sandbox-container" style="margin-left: 5px; margin-right: 5px;"> \
            //                <div class="input-group date"> \
            //                    <input type="text" value="' + dateTimeFormat(obj.aData['usr_grd_11229']) + '" name="UserInfoModel[' + obj.aData['UserInfoID'] + '].DateOfSeparation" id="" class="inpUserSeparation clkUserSeparation form-control valid" style="width:100px;"/> \
            //                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span> \
            //                </div> \
            //            </div>';
            var str = dateTimeFormat(obj.aData['usr_grd_11229']);
            return str;
        },
        'usr_grd_11230': function (obj, type) {
            if (obj.aData['usr_grd_11230'] == null) {
                obj.aData['usr_grd_11230'] = "";
            }
            //var str = '<input type="text" value="' + obj.aData['usr_grd_11230'] + '" class="form-control inpUserRowReason clkUserSeparation" name="UserInfoModel[' + obj.aData['UserInfoID']++ + '].ReasonForSeparation" id="inpRea_' + obj.aData['UserInfoID'] + '" />';

            return obj.aData['usr_grd_11230'];
        },
        'usr_grd_11424': function (obj, type) {
            var str = "";
            str = '<input type="hidden" class="clsUserInfoId" name = "' + obj.aData['UserInfoID'] + '.clsUserInfoId" value="' + obj.aData['UserInfoID'] + '"/>';
            if (obj.aData['usr_grd_11424'] != null) {
                str = str + obj.aData['usr_grd_11424'];
            }
            return str;
        },
        'usr_grd_11425': function (obj, type) {
            var str = "";
            if (obj.aData['usr_grd_11425'] != null) {
                str = dateTimeFormat(obj.aData['usr_grd_11425']);
            }
            return str;
        },
        'usr_grd_11073': function (obj, type) {

            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //FinancialYearList For Trading WindowEvent
    'GridType_114020': {
        'rul_grd_15002': function (obj, type) {
            if (obj.aData['rul_grd_15002'] == null) {
                obj.aData['rul_grd_15002'] = "";
            }
            var str = '<input type="text" value="' + obj.aData['rul_grd_15002'] + '" class="form-control inpRowTradingWindowId " name="TradingWindowEventModel[' + rowCount + '].TradingWindowId_1"   disabled="disabled"  data-val-required="The ' + obj.aData['rul_grd_15001'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" />';
            str = str + '<input type="hidden" value="' + obj.aData['FinancialYearCodeId'] + '" class="form-control inpRowFinancialYearCodeId" name="TradingWindowEventModel[' + rowCount + '].FinancialYearCodeId" id="" />';
            str = str + '<input type="hidden" value="' + obj.aData['FinancialPeriodCodeId'] + '" class="form-control inpRowFinancialPeriodCodeId" name="TradingWindowEventModel[' + rowCount + '].FinancialPeriodCodeId" id="" />';
            str = str + '<input type="hidden" value="' + obj.aData['TradingWindowEventId'] + '" class="form-control inpRowTradingWindowEventId" name="TradingWindowEventModel[' + rowCount + '].TradingWindowEventId" id="" />';
            str = str + '<input type="hidden" value="' + obj.aData['rul_grd_15002'] + '" class="form-control inpRowTradingWindowEventId" name="TradingWindowEventModel[' + rowCount + '].TradingWindowId" id="" />';
            return str;
        },
        'rul_grd_15003': function (obj, type) {
            var str = '<div class=""><div class="f" id="sandbox-container"> \
                            <div class="input-group date" id="" data-date-format="dd/mm/yyyy"> \
                                <input type="text" value="' + dateTimeFormat(obj.aData['rul_grd_15003']) + '" name="TradingWindowEventModel[' + rowCount + '].ResultDeclarationDate"  data-val-required="The ' + obj.aData['rul_grd_15001'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" class="inpRowResultDeclarationDate form-control" />\
                                <span class="input-group-addon"><i class="fa fa-calendar"></i></span> \
                            </div> </div> \
                       </div>';
            return str;
        },
        'rul_grd_15004': function (obj, type) {
            var str = '<div class=""><div class="" id="sandbox-container"> \
                            <div class="input-group date" id="" data-date-format="dd/mm/yyyy"> \
                                <input type="text" value="' + dateTimeFormat(obj.aData['rul_grd_15004']) + '" name="TradingWindowEventModel[' + rowCount + '].WindowCloseDate"   disabled="disabled" data-val-required="The ' + obj.aData['rul_grd_15001'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" class="inpRowWindowCloseDate  form-control" />\
                                </div> \
                            </div> \
                       </div>';
            //var str = '<input type="text" value="' + dateTimeFormat(obj.aData['rul_grd_15004']) + '" name="TradingWindowEventModel[' + rowCount + '].WindowCloseDate"   disabled="disabled" data-val-required="The ' + obj.aData['rul_grd_15001'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" class="inpRowWindowCloseDate  form-control" />';
            return str;
        },
        'rul_grd_15005': function (obj, type) {
            var str = '<div class=""><div class="" id="sandbox-container"> \
                            <div class="input-group date" id="" data-date-format="dd/mm/yyyy"> \
                                <input type="text" value="' + dateTimeFormat(obj.aData['rul_grd_15005']) + '" name="TradingWindowEventModel[' + rowCount + '].WindowOpenDate"  disabled="disabled" data-val-required="The ' + obj.aData['rul_grd_15001'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" class="inpRowWindowOpenDate  form-control" /></span> \
                            </div> </div>\
                       </div>';
            //  var str = '<input type="text" value="' + dateTimeFormat(obj.aData['rul_grd_15005']) + '" name="TradingWindowEventModel[' + rowCount + '].WindowOpenDate"  disabled="disabled" data-val-required="The ' + obj.aData['rul_grd_15001'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" class="inpRowWindowOpenDate  form-control" /></span> ';

            return str;
        },
        'rul_grd_15006': function (obj, type) {
            if (obj.aData['rul_grd_15006'] == null) {
                obj.aData['rul_grd_15006'] = "";
            }
            var str = '<input type="text" value="' + obj.aData['rul_grd_15006'] + '" class="form-control inpRowDaysPriorToResultDeclaration " name="TradingWindowEventModel[' + rowCount + '].DaysPriorToResultDeclaration"  data-val-required="The ' + obj.aData['rul_grd_15001'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id=""  />';
            return str;
        },
        'rul_grd_15007': function (obj, type) {
            if (obj.aData['rul_grd_15007'] == null) {
                obj.aData['rul_grd_15007'] = "";
            }
            var str = '<input type="text" value="' + obj.aData['rul_grd_15007'] + '" class="form-control inpRowDaysPostToResultDeclaration " name="TradingWindowEventModel[' + rowCount++ + '].DaysPostResultDeclaration"  data-val-required="The ' + obj.aData['rul_grd_15001'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" />';
            return str;
        }
    },
    'GridType_114021': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'rul_grd_15011': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15011']);
        },
        'rul_grd_15012': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15012']);
        },
        'rul_grd_15013': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15013']);
        }
    },
    //Policy Document list
    'GridType_114022': {
        'rul_grd_15035': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15035']);
        },
        'rul_grd_15036': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15036']);
        },
        'rul_grd_15037': function (obj, type) {
            var str = '<div class="checkbox cursor_default"> <input type="checkbox" disabled = "disabled" ';
            if (obj.aData['rul_grd_15037'] == true) {
                str += 'checked="checked" ';
                str += 'class="cr-check cursor_default" ';
            } else {
                str += 'class="cursor_default" ';
            }
            str += ' /><label class="cursor_default" ></label> </div>'
            return str;
        },
        'rul_grd_15038': function (obj, type) {
            var str = '<div class="checkbox cursor_default"> <input type="checkbox" disabled = "disabled" ';
            if (obj.aData['rul_grd_15038'] == true) {
                str += 'checked="checked" ';
                str += 'class="cr-check cursor_default" ';
            } else {
                str += 'class="cursor_default" ';
            }
            str += ' /><label class="cursor_default" ></label> </div>'
            return str;
        },
        'rul_grd_15039': function (obj, type) {
            var status = '';
            switch (obj.aData['rul_grd_15039']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                case 'Incomplete':
                    status = 'Incomplete';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //Applicability employee insider.
    'GridType_114023': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114023_usr_grd_11228');
        }
    },
    //Applicability employee insider OS.
    'GridType_114132': {        
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114132_usr_grd_11228');
        }
    },
    //Trading Policy List
     
    'GridType_114024': {
        'rul_grd_15053': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15053']);
        },
        'rul_grd_15054': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15054']);
        },
        'rul_grd_15056': function (obj, type) {
            var status = '';
            switch (obj.aData['rul_grd_15056']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                case 'Incomplete':
                    status = 'Incomplete';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },


    //Trading Policy Other Security List
    'GridType_114129': {
        'rul_grd_55090': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_55090']);
        },
        'rul_grd_55091': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_55091']);
        },
        'rul_grd_55093': function (obj, type) {
            var status = '';
            switch (obj.aData['rul_grd_55093']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                case 'Incomplete':
                    status = 'Incomplete';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        }
        ,
        'usr_grd_11073': function (obj, type) {
            //if (obj.aData['TradingPolicyId'] != null)
            //{
            //   // $("#AddTradingPolicy").hide();
            //}
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },


    //Trading Policy History List
    'GridType_114025': {
        'rul_grd_15222': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15222']);
        },
        'rul_grd_15223': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15223']);
        },
        'rul_grd_15105': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15105']);
        },
        'rul_grd_15225': function (obj, type) {
            var status = '';
            switch (obj.aData['rul_grd_15225']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                case 'Incomplete':
                    status = 'Incomplete';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
     

         //Trading Policy Other Security History List
    'GridType_114130': {
        'rul_grd_55136': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_55136']);
        },
        'rul_grd_55137': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_55137']);
        },
        'rul_grd_55140': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_55140']);
        },
        'rul_grd_55139': function (obj, type) {
            var status = '';
            switch (obj.aData['rul_grd_55139']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                case 'Incomplete':
                    status = 'Incomplete';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },

    //Applicability employee insider.
    'GridType_114026': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114026_usr_grd_11228');
        }
    },
    //Applicability employee insider OS.
    'GridType_114133': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114133_usr_grd_11228');
        }
    },
    //Applicability search corporate.
    'GridType_114027': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114027_usr_grd_11228');
        }
    },
    //Applicability search corporate.
    'GridType_114135': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114135_usr_grd_11228');
        }
    },
    //Applicability association corporate.
    'GridType_114028': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114028_usr_grd_11228');
        }
    },
    //Applicability association corporate OS.
    'GridType_114136': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114136_usr_grd_11228');
        }
    },
    //Applicability search non-employee insider.
    'GridType_114029': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114029_usr_grd_11228');
        }
    },
    //Applicability search non-employee insider OS.
    'GridType_114137': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114137_usr_grd_11228');
        }
    },
    //Applicability association non-employee insider.
    'GridType_114030': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114030_usr_grd_11228');
        }
    },

    //Applicability association non-employee insider OS.
    'GridType_114138': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114138_usr_grd_11228');
        }
    },

    //Demat Initial Disclosure List For share   //BYSA
    'GridType_114071': {

        'tra_grd_16190': function (obj, type) {
            if (obj.aData['UserInfoId'] != '') {
                $("#Grd_User_OwnSecurities").show();
            }
            str = '<input type="hidden" class="clsDmatId" id="DmatId" name = "' + obj.aData['DmatId'] + '.clsDmatId" value="' + obj.aData['DmatId'] + '"/>';
            str = str + '<input type="hidden" class="clsUserInfoId" id="UserInfoId" name = "' + obj.aData['UserInfoId'] + '.clsUserInfoId" value="' + obj.aData['UserInfoId'] + '"/>';
            if (obj.aData['tra_grd_16190'] != null) {
                str = str + obj.aData['tra_grd_16190'];
            }
            //else {
            //    str= '';
            //}
            return str;
        },
        'tra_grd_16191': function (obj, type) {
            if (obj.aData['tra_grd_16191'] != null) {
                return obj.aData['tra_grd_16191']
            }
            else {
                return '';
            }
        },
        'tra_grd_16192': function (obj, type) {
            if (obj.aData['tra_grd_16192'] != null) {
                return obj.aData['tra_grd_16192']
            }
            else {
                return '';
            }
        },
        'tra_grd_16193': function (obj, type) {
            if (obj.aData['tra_grd_16193'] != null) {
                return obj.aData['tra_grd_16193']
            }
            else {
                return '';
            }
        }
        ,
        'tra_grd_16194': function (obj, type) {
            if (obj.aData['tra_grd_16194'] != null) {
                return obj.aData['tra_grd_16194']
            }
            else {
                return '';
            }
        }
        ,
        'tra_grd_16195': function (obj, type) {
            var str = "";
            if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_16195" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16195'] + '"/>'
            }

            else if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_16195" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16195'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_16195" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16195'] + '" readonly="readonly" data-toggle="tooltip" title= "' + DematMsg.value + '"/>'
            }
            return str;
        }
         ,
        'tra_grd_16196': function (obj, type) {
            var str = "";
            if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_16196" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16196'] + '"/>'
            }

            else if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_16196" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16196'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_16196" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16196'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        }
          ,
        'tra_grd_16197': function (obj, type) {
            var str = "";
            if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_16197" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16197'] + '"/>'
            }

            else if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_16197" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16197'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_16197" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16197'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        }
        ,
        'tra_grd_16199': function (obj, type) {
            var str = "";
            if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_16199" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16199'] + '"/>'
            }

            else if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_16199" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16199'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_16199" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16199'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        }
          ,
        'tra_grd_16200': function (obj, type) {
            var str = "";
            if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_16200" class="form-control"  value="' + obj.aData['tra_grd_16200'] + '"/>'
            }

            else if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_16200" class="form-control"  value="' + obj.aData['tra_grd_16200'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_16200" class="form-control"  value="' + obj.aData['tra_grd_16200'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        }
         ,
        'tra_grd_16198': function (obj, type) {
            var str = "";
            if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_16198" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16198'] + '"/>'
            }

            else if (obj.aData['DmatId'] != '' && obj.aData['DmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_16198" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16198'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_16198" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_16198'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        }
    },
    //Relative Initial Disclosure List For share   //BYSA
    'GridType_114102': {

        'tra_grd_50741': function (obj, type) {
            if (obj.aData['RelUserInfoId'] != '') {
                $("#Grd_Relative_OwnSecurities").show();
            }
            str = '<input type="hidden" class="clsRelDmatId" id="relDmatId" name = "' + obj.aData['relDmatId'] + '.clsrelDmatId" value="' + obj.aData['relDmatId'] + '"/>';
            str = str + '<input type="hidden" class="clsRelUserInfoId" id="RelUserInfoId" name = "' + obj.aData['RelUserInfoId'] + '.clsUserInfoId" value="' + obj.aData['RelUserInfoId'] + '"/>';
            if (obj.aData['tra_grd_50741'] != null) {
                str = str + obj.aData['tra_grd_50741'];
            }
            else {
                str = '';
            }
            return str;
        },

        'tra_grd_50742': function (obj, type) {
            if (obj.aData['tra_grd_50742'] != null) {
                return obj.aData['tra_grd_50742']
            }
            else {
                return '';
            }
        },

        'tra_grd_50743': function (obj, type) {
            if (obj.aData['tra_grd_50743'] != null) {
                return obj.aData['tra_grd_50743']
            }
            else {
                return '';
            }
        },

        'tra_grd_50744': function (obj, type) {
            if (obj.aData['tra_grd_50744'] != null) {
                return obj.aData['tra_grd_50744']
            }
            else {
                return '';
            }
        },

        'tra_grd_50745': function (obj, type) {
            if (obj.aData['tra_grd_50745'] != null) {
                return obj.aData['tra_grd_50745']
            }
            else {
                return '';
            }
        },

        'tra_grd_50746': function (obj, type) {
            if (obj.aData['tra_grd_50746'] != null) {
                return obj.aData['tra_grd_50746']
            }
            else {
                return '';
            }
        },

        'tra_grd_50747': function (obj, type) {
            if (obj.aData['tra_grd_50747'] != null) {
                return obj.aData['tra_grd_50747']
            }
            else {
                return '';
            }
        },

        'tra_grd_50748': function (obj, type) {
            if (obj.aData['tra_grd_50748'] != null) {
                return obj.aData['tra_grd_50748']
            }
            else {
                return '';
            }
        },
        'tra_grd_50749': function (obj, type) {
            var str = "";
            if (obj.aData['relDmatId'] != '' && obj.aData['relDmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_50749" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50749'] + '"/>'
            }

            else if (obj.aData['relDmatId'] != '' && obj.aData['relDmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_50749" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50749'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_50749" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50749'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        },
        'tra_grd_50783': function (obj, type) {
            var str = "";
            if (obj.aData['relDmatId'] != '' && obj.aData['relDmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_50783" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50783'] + '"/>'
            }

            else if (obj.aData['relDmatId'] != '' && obj.aData['relDmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_50783" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50783'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_50783" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50783'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        },
        'tra_grd_50784': function (obj, type) {
            var str = "";
            if (obj.aData['relDmatId'] != '' && obj.aData['relDmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_50784" class="form-control" value="' + obj.aData['tra_grd_50784'] + '"/>'
            }

            else if (obj.aData['relDmatId'] != '' && obj.aData['relDmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_50784" class="form-control" value="' + obj.aData['tra_grd_50784'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_50784" class="form-control" value="' + obj.aData['tra_grd_50784'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        },
        'tra_grd_50750': function (obj, type) {
            var str = "";
            if (obj.aData['relDmatId'] != '' && obj.aData['relDmatId'] != null && (obj.aData['TransStatusCodeId'] == 148002 || obj.aData['TransStatusCodeId'] == 148001)) {
                str = '<input type="text" id="txttra_grd_50750" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50750'] + '"/>'
            }

            else if (obj.aData['relDmatId'] != '' && obj.aData['relDmatId'] != null && obj.aData['TransStatusCodeId'] == 148003) {
                str = '<input type="text" id="txttra_grd_50750" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50750'] + '" readonly="readonly"/>'
            }
            else {
                str = '<input type="text" id="txttra_grd_50750" class="form-control" onKeyPress="return onlyNumbers(this)" maxlength="10" value="' + obj.aData['tra_grd_50750'] + '" readonly="readonly" data-toggle="tooltip" title="' + DematMsg.value + '"/>'
            }
            return str;
        }
    },



    //Trading Transaction Details.
    'GridType_114031': {
        'usr_grd_11073': function (obj, type) {
            if (obj.aData['IsAllowEdit'] == 2) {
                return createActionControlArray(obj, '114031_usr_grd_11073');
            }
        },
        'tra_grd_16007': function (obj, type) {
            return dateTimeFormat(obj.aData['tra_grd_16007']);
        },
        'tra_grd_16008': function (obj, type) {
            return dateTimeFormat(obj.aData['tra_grd_16008']);
        },
        'tra_grd_16014': function (obj, type) {
            return formatIndianNumber(obj.aData['tra_grd_16014']);
        },
        'tra_grd_16015': function (obj, type) {
            return formatIndianNumber(obj.aData['tra_grd_16015']);
        }

    },
    //Applicability filter employee insider.
    'GridType_114032': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114032_usr_grd_11228');
        }
    },
    //Applicability filter employee insider OS.
    'GridType_114139': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114139_usr_grd_11228');
        }
    },
    //policy document agreed or viewd by user list
    'GridType_114033': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, '114033_usr_grd_11073');
        },
        'rul_grd_15345': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15345']);
        },
        'rul_grd_15346': function (obj, type) {
            return dateTimeFormat(obj.aData['rul_grd_15346']);
        },
        'rul_grd_15347': function (obj, type) {
            var status = '';
            switch (obj.aData['rul_grd_15347']) {
                case 0:
                    status = 'Pending';
                    break;
                case 1:
                    status = 'Viewed';
                    break;
                case 2:
                    status = 'Agreed';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'rul_grd_15415': function (obj, type) {
            return (obj.aData['rul_grd_15415'] != null) ? dateTimeFormat(obj.aData['rul_grd_15415']) : "";
        },
        'rul_grd_15348': function (obj, type) {
            var status = '';
            switch (obj.aData['rul_grd_15348']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
    },
    //policy docuement applicablity list for coporate
    'GridType_114034': {
        'tra_grd_16042': function (obj, type) {
            var val_return = 'NA';
            if (obj.aData['DocumentViewFlag']) {
                val_return = (obj.aData['DocumentViewedDate'] != null) ? dateTimeFormat(obj.aData['DocumentViewedDate']) : 'Pending';
            }
            return val_return;
        },
        'tra_grd_16043': function (obj, type) {
            var val_return = 'NA';
            if (obj.aData['DocumentViewAgreeFlag']) {
                val_return = (obj.aData['DocumentAgreedDate'] != null) ? dateTimeFormat(obj.aData['DocumentAgreedDate']) : 'Pending';
            }
            return val_return;
        }
    },
    //policy docuement applicablity list for non-employee
    'GridType_114035': {
        'tra_grd_16047': function (obj, type) {
            var val_return = 'NA';
            if (obj.aData['DocumentViewFlag']) {
                val_return = (obj.aData['DocumentViewedDate'] != null) ? dateTimeFormat(obj.aData['DocumentViewedDate']) : 'Pending';
            }
            return val_return;
        },
        'tra_grd_16048': function (obj, type) {
            var val_return = 'NA';
            if (obj.aData['DocumentViewAgreeFlag']) {
                val_return = (obj.aData['DocumentAgreedDate'] != null) ? dateTimeFormat(obj.aData['DocumentAgreedDate']) : 'Pending';
            }
            return val_return;
        }
    },
    //policy docuement applicablity list for employee
    'GridType_114036': {
        'tra_grd_16053': function (obj, type) {
            var val_return = 'NA';
            if (obj.aData['DocumentViewFlag']) {
                val_return = (obj.aData['DocumentViewedDate'] != null) ? dateTimeFormat(obj.aData['DocumentViewedDate']) : 'Pending';
            }
            return val_return;
        },
        'tra_grd_16054': function (obj, type) {
            var val_return = 'NA';
            if (obj.aData['DocumentViewAgreeFlag']) {
                val_return = (obj.aData['DocumentAgreedDate'] != null) ? dateTimeFormat(obj.aData['DocumentAgreedDate']) : 'Pending';
            }
            return val_return;
        }
    },
    //PreClearance Request list for Insider
    'GridType_114038': {
        'dis_grd_17014': function (obj, type) {
            if (obj.aData['PreclearanceRequestId'] != null && obj.aData['PreclearanceRequestId'] > 0) {
                var status = "";
                status = '<a href="' + $('#View').val() + '&CalledFrom=View&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" style="color:blue;">';
                status = status + obj.aData['dis_grd_17014'];
                status = status + '</a>';
                if (obj.aData["dis_grd_17014"] != "" && obj.aData['dis_grd_17017'] == 153016 && obj.aData['IsPreclearanceFormForImplementingCompany'] == 1) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=157&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&DisplayCode=' + obj.aData['dis_grd_17014'] + '" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    }

                }
                return status;
                // return createActionControlArray(obj, '114038_dis_grd_17014');
            } else {
                return obj.aData['dis_grd_17014'];
            }
        },
        'dis_grd_17016': function (obj, type) {
            if (obj.aData['dis_grd_17016'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17016']);
            } else {
                return '';
            }

        },
        'dis_grd_17350': function (obj, type) {
            if (obj.aData['dis_grd_17350'] != null)
                return formatIndianNumber(obj.aData['dis_grd_17350']);
            else {
                return '-';
            }
        },
        'dis_grd_17351': function (obj, type) {
            if (obj.aData['dis_grd_17351'] != null)
                return formatIndianNumber(obj.aData['dis_grd_17351']);
            else {
                return '-';
            }
        },
        'dis_grd_17017': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17017']) {
                case 153015:
                    status = '<a href="' + $('#View').val() + '&CalledFrom=View&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['PreClearanceStatusButtonText'];
                    status = status + '</button></p> </a>';

                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Valid till ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }
                    break;
                case 153016:
                    status = '<a href="' + $('#View').val() + '&CalledFrom=View&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    status = status + obj.aData['PreClearanceStatusButtonText'];
                    status = status + '</button></p> </a>';

                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Valid till ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }
                    break;
                case 153017:
                    status = '<a href="' + $('#RejectionView').val() + '?CalledFrom=Insider&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-arrow btn-md"><i class="ico ico-times"></i> ';
                    status = status + obj.aData['PreClearanceStatusButtonText'];
                    status = status + '</button></p> </a>';

                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17020': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17020']) {
                case 154002:

                    if (obj.aData['dis_grd_17017'] == '') {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '">';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 154001:
                    if (obj.aData['dis_grd_17017'] == '') {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '">';
                    }
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['ContinuousDisclosureSubmissionDate']);
                    if (obj.aData['IsEnterAndUploadEvent'] == '2') {
                        status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    status = status + '</button></p> </a>';


                    break;
                case 154006:
                    if (obj.aData['dis_grd_17017'] == '') {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '">';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button></p> </a>';

                    break;
                case 154005:
                    if (obj.aData['dis_grd_17017'] == '') {
                        status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=Insider&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=Insider&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                    }
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-round  btn-md center-block"><i class="ico ico-exch"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button></p> </a>';

                    break;
                case 154004:
                    if (obj.aData['TransactionMasterID'] > 0) {
                        if (obj.aData['dis_grd_17017'] == '') {
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                        }
                        else {
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                        }
                        status = status + '<p class="text-center status-green">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['TradingDetailsStatusButtonText'];
                        status = status + '</button></p> </a>';
                    } else if (obj.aData['ReasonForNotTradingCodeId'] != null) {
                        if (obj.aData['dis_grd_17017'] == '') {
                            status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=Insider&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                        }
                        else {
                            status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=Insider&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                        }
                        status = status + '<p class="text-center status-green-end">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['TradingDetailsStatusButtonText'];
                        status = status + '</button></p> </a>';
                    }
                    else {
                        if (obj.aData['IsPartiallyTraded'] == 1 && obj.aData['ShowAddButton'] == 1) {
                            if (obj.aData['dis_grd_17017'] == '') {
                                status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                            }
                            else {
                                status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                            }
                            status = status + '<p class="text-center status-orange">';
                            status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="fa fa-plus-square"></i> ';
                            status = status + obj.aData['TradingDetailsStatusButtonText'];
                            status = status + '</button></p> </a>';
                        }
                        else {
                            if (obj.aData['IsPartiallyTraded'] == 1) {
                                if (obj.aData['dis_grd_17017'] == '') {
                                    status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                                }
                                else {
                                    status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=157&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                                }
                                status = status + '<p class="text-center status-green">';
                                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                                status = status + obj.aData['TradingDetailsStatusButtonText'];
                                status = status + '</button></p> </a>';
                            }
                        }
                    }
                    break;
                default:
                    status = '';
                    break;
            }
            status = status + '<span style="display:none;">' + obj.aData['dis_grd_17017'] + '</span>';
            return status;
        },
        'dis_grd_17021': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17021']) {
                case 0:
                    status = '<a href="' + $('#SoftcopyPending').val() + '?nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001&acid=' + $('#DisclosureActionID').val() + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 1:
                    status = '<a href="' + $('#SoftcopyView').val() + '?nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001&acid=' + $('#DisclosureActionID').val() + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['SoftcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17022': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17022']) {
                case 0:
                    status = '<a href="' + $('#HardcopyPending').val() + '?nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001&acid=' + $('#DisclosureActionID').val() + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    if (obj.aData['HardcopySubmissionwithin'] != null) {
                        status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['HardcopySubmissionwithin'] + '</span><span>' + obj.aData['HardcopySubmissionwithinText'] + '</span></p>'
                    }
                    break;
                case 1:
                    status = '<a href="' + $('#HardcopyView').val() + '?CalledFrom=ContinousInsider&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001&acid=' + $('#DisclosureActionID').val() + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['HardcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17270': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17270']) {
                case 0:
                    status = '<a >';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['HardCopySubmitCOToExchangeButtonText'];
                    status = status + '</button></p> </a>';
                    if (obj.aData['HardCopySubmitCOToExchangeWithin'] != null) {
                        status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['HardCopySubmitCOToExchangeWithin'] + '</span><span>' + obj.aData['HardCopySubmitCOToExchangeWithinText'] + '</span></p>'
                    }
                    break;
                case 1:
                    status = '<a >';
                    status = status + '<p class="text-center status-aqua">';
                    status = status + '<button type="submit" class="btn btn-success btn-aqua btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['HardCopySubmitCOToExchangeDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardCopySubmitCOToExchangeButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        }
    },
    //Insider - Period End Disclosure - Period Status List for Insider
    'GridType_114037': {
        'dis_grd_17011': function (obj, type) {
            return dateTimeFormat(obj.aData['dis_grd_17011'])
        },
        'dis_grd_17012': function (obj, type) { //status column
            var val_return = '';
            if (obj.aData['SubmissionStatusCodeId'] == 154006) {
                val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + '" firstButton="firstButton" >';
                val_return = val_return + '<p class="text-center status-orange">';
                val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-note"></i> ';
                val_return = val_return + obj.aData['SubmissionButtonText'];
                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_17012'] == null) {
                    if (obj.aData['SubmissionButtonText'] != null) {
                        val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + '" firstButton="firstButton" >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['SubmissionButtonText'];
                        val_return = val_return + '</button></p> </a>';
                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p class="inline-block">';
                            val_return += '<span class="days-count">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span>Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + ' " firstButton="firstButton" >';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_17012']);
                    if (obj.aData['IsUploadAndEnterEventGenerate'] == "1") {
                        val_return = val_return + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    val_return = val_return + '</button></p> </a>';
                }
            }
            return val_return;
        },
        'dis_grd_17030': function (obj, type) { //softcopy submit column
            var val_return = '';
            if (obj.aData['ScpStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['ScpButtonText'];
                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_17030'] == null) {
                    if (obj.aData['ScpButtonText'] != null) {
                        val_return = (obj.aData['IsCurrentPeriodEnd'] == 1) ? '<a href="' + $('#softcopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['ScpButtonText'];
                        val_return = val_return + '</button></p> </a>';
                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p class="inline-block">';
                            val_return += '<span class="days-count">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span>Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#softcopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_17030']);
                    val_return = val_return + '</button></p> </a>';

                }
            }

            return val_return;
        },
        'dis_grd_17031': function (obj, type) { //hardcopy submit column
            var val_return = '';
            if (obj.aData['HcpStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['HcpButtonText'];
                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_17031'] == null) {
                    if (obj.aData['HcpButtonText'] != null) {
                        val_return = (obj.aData['IsCurrentPeriodEnd'] == 1) ? '<a href="' + $('#hardcopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['HcpButtonText'];
                        val_return = val_return + '</button></p> </a>';
                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p class="inline-block">';
                            val_return += '<span class="days-count">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span>Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#hardcopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_17031']);
                    val_return = val_return + '</button></p> </a>';
                }
            }

            return val_return;
        },
        'dis_grd_17032': function (obj, type) { //stock exchange submit column
            var val_return = '';
            if (obj.aData['HCpByCOStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['HCpByCOButtonText'];
                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_17032'] == null) {
                    if (obj.aData['HCpByCOButtonText'] != null) {
                        if ($('#stockexchangecopylink').val() != undefined) {
                            val_return = '<a href="' + $('#stockexchangecopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">';
                        } else {
                            val_return = '<a >';
                        }

                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['HCpByCOButtonText'];
                        val_return = val_return + '</button></p> </a>';

                        if (obj.aData['SubmissionDaysRemainingByCO'] > -1) {
                            val_return += '<p class="inline-block">';
                            val_return += '<span class="days-count">' + obj.aData['SubmissionDaysRemainingByCO'] + '</span>';
                            val_return += '<span>Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    if ($('#stockexchangecopylink').val() != undefined) {
                        val_return = '<a href="' + $('#stockexchangecopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">';
                    } else {
                        val_return = '<a >';
                    }

                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-round  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_17032']);
                    val_return = val_return + '</button></p> </a>';
                }
            }
            return val_return;
        }
    },
    //Insider - Period End Disclosure - Period Summary List for Insider
    'GridType_114039': {

        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, '114039_usr_grd_11073');
        },
        'dis_grd_17037': function (obj, type) {
            if (obj.aData['dis_grd_17037'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17037'])
            }
        },
        'dis_grd_17038': function (obj, type) {
            if (obj.aData['dis_grd_17038'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17038'])
            }
        },
        'dis_grd_17039': function (obj, type) {
            if (obj.aData['dis_grd_17039'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17039'])
            }
        },
        'dis_grd_17040': function (obj, type) {
            if (obj.aData['dis_grd_17040'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17040'])
            }
        },
    },

    //TemplateMasterList
    'GridType_114040': {
        'usr_grd_11073': function (obj, type, row) {

            return createActionControlArray(obj, '114040_usr_grd_11073');
        },
        'tra_grd_16073': function (obj, type) {

            var status = '';
            if (obj.aData['tra_grd_16073']) {
                status = '<i class="icon status icon-light-on light-orange"></i>';
            }
            else {
                status = '<i class="icon status icon-light-off light-gray"></i>';
            }

            return status;
        }
    },
    //
    'GridType_114041': {
        'rul_grd_15362': function (obj, type) {
            var str = "";
            str = '<input type="hidden" value="' + obj.aData['SecurityCodeID'] + '" class="form-control inpSecurityCodeID" name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].SecurityCodeID" id="" />';
            if (obj.aData['rul_grd_15362'] != null) {
                str = str + '<input type="text" value="' + formatIndianNumber(obj.aData['rul_grd_15362']) + '" class="form-control numericOnly inpNoOfShare" name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].NoOfShare" />';
            } else {
                str = str + '<input type="text" value="" class="form-control numericOnly inpNoOfShare " name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].NoOfShare" />';
            }
            return str;

        },
        'rul_grd_15363': function (obj, type) {
            var str = "";
            if (obj.aData['rul_grd_15363'] != null) {
                str = '<input type="text" value="' + formatIndianFloat(obj.aData['rul_grd_15363']) + '" class="form-control two-digits inpCapital" name="TradingPolicyModel.PreSecuritiesValuesModel['
                    + rowCount + '].Capital" data-val-regex-pattern="^(100\.00|100\.0|100)|([0-9]{1,2}){0,1}(\.[0-9]{1,2}){0,1}$" data-val-regex="Enter valid % of paid up and subscribed capital" />';
                str = str + '<span data-valmsg-replace="true" data-valmsg-for="TradingPolicyModel.PreSecuritiesValuesModel['
                    + rowCount + '].Capital" class="field-validation-valid"></span>'
            } else {
                str = '<input type="text" value="" class="form-control two-digits inpCapital " name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].Capital" />';
            }
            return str;
        },
        'rul_grd_15364': function (obj, type) {
            var str = "";
            if (obj.aData['rul_grd_15364'] != null) {
                str = '<input type="text" value="' + formatIndianFloat(obj.aData['rul_grd_15364']) + '" class="form-control two-digits inpValueOfShare" name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].ValueOfShare" />';
            } else {
                str = '<input type="text" value="" class="form-control two-digits inpValueOfShare " name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].ValueOfShare" />';
            }
            return str;
        },
    },

    'GridType_114131': {
        'rul_grd_55325': function (obj, type) {
            var str = "";
            str = '<input type="hidden" value="' + obj.aData['SecurityCodeID'] + '" class="form-control inpSecurityCodeID" name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].SecurityCodeID" id="" />';
            if (obj.aData['rul_grd_55325'] != null) {
                str = str + '<input type="text" value="' + formatIndianNumber(obj.aData['rul_grd_55325']) + '" class="form-control numericOnly inpNoOfShare" name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].NoOfShare" />';
            } else {
                str = str + '<input type="text" value="" class="form-control numericOnly inpNoOfShare " name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].NoOfShare" />';
            }
            return str;

        },
        'rul_grd_55326': function (obj, type) {
            var str = "";
            if (obj.aData['rul_grd_55326'] != null) {
                str = '<input type="text" value="' + formatIndianFloat(obj.aData['rul_grd_55326']) + '" class="form-control two-digits inpCapital" name="TradingPolicyModel.PreSecuritiesValuesModel['
                    + rowCount + '].Capital" data-val-regex-pattern="^(100\.00|100\.0|100)|([0-9]{1,2}){0,1}(\.[0-9]{1,2}){0,1}$" data-val-regex="Enter valid % of paid up and subscribed capital" />';
                str = str + '<span data-valmsg-replace="true" data-valmsg-for="TradingPolicyModel.PreSecuritiesValuesModel['
                    + rowCount + '].Capital" class="field-validation-valid"></span>'
            } else {
                str = '<input type="text" value="" class="form-control two-digits inpCapital " name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].Capital" />';
            }
            return str;
        },
        'rul_grd_55327': function (obj, type) {
            var str = "";
            if (obj.aData['rul_grd_55327'] != null) {
                str = '<input type="text" value="' + formatIndianFloat(obj.aData['rul_grd_55327']) + '" class="form-control two-digits inpValueOfShare" name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].ValueOfShare" />';
            } else {
                str = '<input type="text" value="" class="form-control two-digits inpValueOfShare " name="TradingPolicyModel.PreSecuritiesValuesModel[' + rowCount + '].ValueOfShare" />';
            }
            return str;
        },
    },
    //Initial Disclosure Letter list
    'GridType_114042': {
        'dis_grd_17131': function (obj, type) {
            var str = "";
            if (obj.aData['dis_grd_17131'] != null) {
                str = obj.aData['dis_grd_17131'].split('##');
            }
            if (str.length > 1)
                return str[0] + ', ' + str[1] + ', ' + str[2] + ', ' + str[3] + ', ' + str[4]
            else
                return "";
        },
        'dis_grd_17132': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_17132'] != "Self" && obj.aData['dis_grd_17132'] != '') {
                str = obj.aData['dis_grd_17132'].split('##');
                if ($.trim(str[1]) != "")
                    return str[0] + ' (' + str[1] + ')'
                else
                    return str[0];
            }
            else {
                return obj.aData['dis_grd_17132']
            }
        },
        'dis_grd_17133': function (obj, type) {
            if (obj.aData['dis_grd_17133'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17133'])
            } else {
                return "-";
            }
        },
        'dis_grd_17136': function (obj, type) {
            if (obj.aData['dis_grd_17136'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17136'])
            }
        }

    },
    //Communication rule-Master list 
    'GridType_114043': {
        'usr_grd_11073': function (obj, type, row) {

            return createActionControlArray(obj, '114043_usr_grd_11073');
        },
        'cmu_grd_18005': function (obj, type) {
            return SetBoolean(obj.aData['cmu_grd_18005']);
        },
        'cmu_grd_18006': function (obj, type) {
            var status = '';
            switch (obj.aData['cmu_grd_18006']) {
                case 'Active':
                    status = '<i class="icon status icon-light-on light-orange"></i>';
                    break;
                case 'Inactive':
                    status = '<i class="icon status icon-light-off light-gray"></i>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;

        }
    },
    //Communication rule-modes list for a rule
    'GridType_114044': {
        'cmu_grd_18007': function (obj, type) {

            var isAllEdit = $("#hidIsAllEdit").val();

            if (obj.aData['cmu_grd_18007'] == null) {
                obj.aData['cmu_grd_18007'] = "";
            }
            var str = '<input type="hidden" value="' + obj.aData['RuleModeId'] + '" class="form-control inpRuleModeId" name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].RuleModeId" id="" />';
            str = str + '<input type="hidden" value="' + obj.aData['UserId'] + '" class="form-control inpRuleModeId" name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].UserId" id="" />';
            if ($("#hidIsAllEdit").val() == 0) {
                str = str + '<input type="hidden" value="' + obj.aData['cmu_grd_18007'] + '" class="form-control inpRuleModeId" name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].ModeCodeId" id="" />';
            }
            return str + createActionControlArray(obj, objThis.GridType + '_cmu_grd_18007');
        },
        'cmu_grd_18008': function (obj, type) {
            var str = '';
            if (obj.aData['cmu_grd_18008'] == null) {
                obj.aData['cmu_grd_18008'] = "";
            }
            if ($("#hidIsAllEdit").val() == 0) {
                str = str + '<input type="hidden" value="' + obj.aData['cmu_grd_18008'] + '" class="form-control inpRuleModeId" name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].TemplateId" id="" />';
            }
            return str + createActionControlArray(obj, objThis.GridType + '_cmu_grd_18008');
        },
        'cmu_grd_18010': function (obj, type) {
            var str = '';
            if (obj.aData['cmu_grd_18010'] == null) {
                obj.aData['cmu_grd_18010'] = "";
            }
            str = createActionControlArray(obj, objThis.GridType + '_cmu_grd_18010');
            if ($("#hidIsAllEdit").val() == 0) {
                if (obj.aData['UserId'] != null) {
                    str = str.replace('disabled', '');
                }
                str = str + '<input type="hidden" value="' + obj.aData['cmu_grd_18010'] + '" class="form-control inpRuleModeId" name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].ExecFrequencyCodeId" id="" />';
            }
            return str;
        },
        'cmu_grd_18009': function (obj, type) {

            if (obj.aData['cmu_grd_18009'] == null) {
                obj.aData['cmu_grd_18009'] = "";
            }
            if ($("#hidIsAllEdit").val() == 1) {
                var str = '<input type="text" value="' + obj.aData['cmu_grd_18009'] + '" class="form-control signedNumericOnly integer-digits " name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].WaitDaysAfterTriggerEvent" data-val-required="The ' + obj.aData['cmu_grd_18009'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" />';
            }
            else {
                var str = '<input type="text" value="' + obj.aData['cmu_grd_18009'] + '" readonly ="readonly"  class="form-control signedNumericOnly integer-digits" name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].WaitDaysAfterTriggerEvent" data-val-required="The ' + obj.aData['cmu_grd_18009'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" />';
            }
            return str;
        },
        'cmu_grd_18011': function (obj, type) {

            if (obj.aData['cmu_grd_18011'] == null) {
                obj.aData['cmu_grd_18011'] = "";
            }
            if ($("#hidIsAllEdit").val() == 1) {
                var str = '<input type="text" value="' + obj.aData['cmu_grd_18011'] + '" class="form-control numericOnly " name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].NotificationLimit" data-val-required="The ' + obj.aData['cmu_grd_18011'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" />';
            }
            else {
                var str = '<input type="text" value="' + obj.aData['cmu_grd_18011'] + '" class="form-control numericOnly " name="CommunicationRuleModeMasterModelList[' + obj.aData['RowCounter'] + '].NotificationLimit" data-val-required="The ' + obj.aData['cmu_grd_18011'] + '[' + obj.oSettings.aoColumns[obj.iDataColumn].sTitle + '] field is required." id="" />';
            }
            return str;
        },
        'usr_grd_11073': function (obj, type) {
            if ($("#hidIsAllEdit").val() == 1 || obj.aData['PersonalizeFlag']) {
                return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
            } else {

                return '';
            }

        },
    },
    //CO - Period End Disclosure - Users Status List for CO
    'GridType_114045': {
        'dis_grd_17165': function (obj, type) {
            return dateTimeFormat(obj.aData['dis_grd_17165'])
        },
        'dis_grd_17166': function (obj, type) { //status column
            var val_return = '';
            if (obj.aData['SubmissionStatusCodeId'] == 154006) {
                val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + '&uid=' + obj.aData['UserInfoId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + '" firstButton="firstButton" >';
                val_return = val_return + '<p class="text-center status-orange">';
                val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-note"></i> ';
                val_return = val_return + obj.aData['SubmissionButtonText'];

                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_17166'] == null) {
                    if (obj.aData['SubmissionButtonText'] != null) {

                        val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + '&uid=' + obj.aData['UserInfoId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + '" firstButton="firstButton" >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['SubmissionButtonText'];

                        val_return = val_return + '</button></p> </a>';

                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p class="inline-block">';
                            val_return += '<span class="days-count">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span>Working Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {

                    val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + '&uid=' + obj.aData['UserInfoId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + ' " firstButton="firstButton" >';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_17166']);
                    if (obj.aData['IsUploadAndEnterEventGenerate'] == "1") {
                        val_return = val_return + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    val_return = val_return + '</button></p> </a>';

                }
            }

            return val_return;
        },
        'dis_grd_17167': function (obj, type) { //softcopy submit column
            var val_return = '';
            if (obj.aData['ScpStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['ScpButtonText'];

                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_17167'] == null) {
                    if (obj.aData['ScpButtonText'] != null) {
                        val_return = (obj.aData['IsThisCurrentPeriodEnd'] == 1) ? '<a href="' + $('#softcopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['ScpButtonText'];

                        val_return = val_return + '</button></p> </a>';

                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p class="inline-block">';
                            val_return += '<span class="days-count">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span>Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#softcopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_17167']);

                    val_return = val_return + '</button></p> </a>';
                }
            }

            return val_return;
        },
        'dis_grd_17168': function (obj, type) { //hardcopy submit column
            var val_return = '';
            if (obj.aData['HcpStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['HcpButtonText'];

                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_17168'] == null) {
                    if (obj.aData['HcpButtonText'] != null) {
                        val_return = (obj.aData['IsThisCurrentPeriodEnd'] == 1) ? '<a href="' + $('#hardcopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&Period=' + obj.aData['PeriodCodeId'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['HcpButtonText'];

                        val_return = val_return + '</button></p> </a>';

                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p class="inline-block">';
                            val_return += '<span class="days-count">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span>Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#hardcopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&Period=' + obj.aData['PeriodCodeId'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_17168']);

                    val_return = val_return + '</button></p> </a>';
                }
            }

            return val_return;
        },
        'dis_grd_17169': function (obj, type) { //stock exchange submit column
            var val_return = '';
            if (obj.aData['HCpByCOStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['HCpByCOButtonText'];
                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_17169'] == null) {
                    if (obj.aData['HCpByCOButtonText'] != null) {
                        val_return = (obj.aData['IsThisCurrentPeriodEnd'] == 1) ? '<a href="' + $('#stockexchangecopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['HCpByCOButtonText'];
                        val_return = val_return + '</button></p> </a>';

                        if (obj.aData['SubmissionDaysRemainingByCO'] > -1) {
                            val_return += '<p class="inline-block">';
                            val_return += '<span class="days-count">' + obj.aData['SubmissionDaysRemainingByCO'] + '</span>';
                            val_return += '<span>Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#stockexchangecopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-round  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_17169']);
                    val_return = val_return + '</button></p> </a>';
                }
            }

            return val_return;
        },
        'dis_grd_17394': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_dis_grd_17394');
        }
    },

    //CO - Period End Disclosure (Other Security)- Users Status List for CO
    'GridType_114128': {

        'dis_grd_51019': function (obj, type) {
            return dateTimeFormat(obj.aData['dis_grd_51019'])
        },
        'dis_grd_51020': function (obj, type) { //status column
            var val_return = '';
            if (obj.aData['SubmissionStatusCodeId'] == 154006) {
                val_return = '<a href="' + $('#summarylink').val() + '&year=' + obj.aData['YearCodeId'] + '&uid=' + obj.aData['UserInfoId'] + '" firstButton="firstButton" >';
                val_return = val_return + '<p class="text-center status-orange">';
                val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-note"></i> ';
                val_return = val_return + obj.aData['SubmissionButtonText'];

                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_51020'] == null) {
                    if (obj.aData['SubmissionButtonText'] != null) {

                        //val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + '&uid=' + obj.aData['UserInfoId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + '" firstButton="firstButton" >';
                        val_return = '<a href="' + $('#summarylink').val() + '&year=' + obj.aData['YearCodeId'] + '&uid=' + obj.aData['UserInfoId'] + '" firstButton="firstButton" >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['SubmissionButtonText'];

                        val_return = val_return + '</button></p> </a>';

                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p style="font-size:12px;margin:0px 0px 0px 48px">';
                            val_return += '<span class="days-count" style="float: left;margin-left: -30px;">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span style="display:inline-block">Working Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                }
                else {

                    //val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + '&uid=' + obj.aData['UserInfoId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + '" firstButton="firstButton" >';
                    val_return = '<a href="' + $('#summarylink').val() + '&year=' + obj.aData['YearCodeId'] + '&uid=' + obj.aData['UserInfoId'] + '" firstButton="firstButton" >';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_51020']);
                    if (obj.aData['IsUploadAndEnterEventGenerate'] == "1") {
                        val_return = val_return + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    val_return = val_return + '</button></p> </a>';

                }
            }

            return val_return;
        },
        'dis_grd_51021': function (obj, type) { //softcopy submit column
            var val_return = '';
            if (obj.aData['ScpStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['ScpButtonText'];

                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_51021'] == null) {
                    if (obj.aData['ScpButtonText'] != null) {
                        val_return = (obj.aData['IsThisCurrentPeriodEnd'] == 1) ? '<a href="' + $('#softcopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['ScpButtonText'];

                        val_return = val_return + '</button></p> </a>';

                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p style="font-size:12px;margin:0px 0px 0px 48px">';
                            val_return += '<span class="days-count" style="float: left;margin-left: -30px;">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span style="display:inline-block">Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#softcopyviewlink').val() + '&tmid=' + obj.aData['TransactionMasterId'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_51021']);

                    val_return = val_return + '</button></p> </a>';
                }
            }

            return val_return;
        },
        'dis_grd_51022': function (obj, type) { //hardcopy submit column
            var val_return = '';
            if (obj.aData['HcpStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['HcpButtonText'];

                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_51022'] == null) {
                    if (obj.aData['HcpButtonText'] != null) {
                        val_return = (obj.aData['IsThisCurrentPeriodEnd'] == 1) ? '<a href="' + $('#hardcopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&Period=' + obj.aData['PeriodCodeId'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['HcpButtonText'];

                        val_return = val_return + '</button></p> </a>';

                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p style="font-size:12px;margin:0px 0px 0px 48px">';
                            val_return += '<span class="days-count" style="float: left;margin-left: -30px;">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span style="display:inline-block">Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#hardcopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&Period=' + obj.aData['PeriodCodeId'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_51022']);

                    val_return = val_return + '</button></p> </a>';
                }
            }

            return val_return;
        }
    },


    //Continuous disclosure data for letter for Employee Insider Form C
    'GridType_114046': {
        'dis_grd_17187': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_17187'] != null) {
                str = obj.aData['dis_grd_17187'].split('##');
            }
            return str[0] + ', ' + str[1] + ', ' + str[2] + ', ' + str[3] + ', ' + str[4]
        },
        'dis_grd_17188': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_17188'] == '')
                return '-';
            if (obj.aData['dis_grd_17188'] != "Self") {
                str = obj.aData['dis_grd_17188'].split('##');
                return str[0];
            }
            else {
                return obj.aData['dis_grd_17188']
            }
        },
        'dis_grd_17191': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_17191'] != null && obj.aData['dis_grd_17191'] != "-") {
                str = obj.aData['dis_grd_17191'].split('##');
                if (str[1] == 'NA') {
                    return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ')';
                } else {
                    return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ' %)';
                }
                //return formatIndianFloat(obj.aData['dis_grd_17191'])
            }
            return obj.aData['dis_grd_17191'];
        },
        'dis_grd_17194': function (obj, type) {
            if (obj.aData['dis_grd_17194'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17194'])
            }
        },
        'dis_grd_17195': function (obj, type) {
            if (obj.aData['dis_grd_17195'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17195'])
            }
        },
        'dis_grd_17199': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_17199'] != null && obj.aData['dis_grd_17199'] != "-") {
                str = obj.aData['dis_grd_17199'].split('##');
                if (str[1] == 'NA') {
                    return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ')';
                } else {
                    return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ' %)';
                }
                //return formatIndianFloat(obj.aData['dis_grd_17191'])
            }
            return obj.aData['dis_grd_17199'];
        },
        'dis_grd_17201': function (obj, type) {
            if (obj.aData['dis_grd_17201'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17201'])
            } else {
                return "-";
            }
        },
        'dis_grd_17202': function (obj, type) {
            if (obj.aData['dis_grd_17202'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17202'])
            } else {
                return "-";
            }
        },
        'dis_grd_17424': function (obj, type) {
            if (obj.aData['dis_grd_17424'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17424'])
            } else {
                return "-";
            }
        },

    },
    //Continuous disclosure data for letter for Non Employee Insider Form D
    'GridType_114047': {
        'dis_grd_17209': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_17209'] != null) {
                str = obj.aData['dis_grd_17209'].split('##');
            }
            return str[0] + ', ' + str[1] + ', ' + str[2] + ', ' + str[3] + ', ' + str[4]
        },
        'dis_grd_17213': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_17213'] != null && obj.aData['dis_grd_17213'] != '-') {
                str = obj.aData['dis_grd_17213'].split('##');
                if (str[1] == 'NA') {
                    return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ')';
                } else {
                    return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ' %)';
                }
            }
            return obj.aData['dis_grd_17213'];
        },
        'dis_grd_17216': function (obj, type) {
            if (obj.aData['dis_grd_17216'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17216'])
            }
        },
        'dis_grd_17217': function (obj, type) {
            if (obj.aData['dis_grd_17217'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17217'])
            }
        },
        'dis_grd_17221': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_17221'] != null && obj.aData['dis_grd_17221'] != '-') {
                str = obj.aData['dis_grd_17221'].split('##');
                if (str[1] == 'NA') {
                    return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ')';
                } else {
                    return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ' %)';
                }
            }
            return obj.aData['dis_grd_17221'];
        },
        'dis_grd_17223': function (obj, type) {
            if (obj.aData['dis_grd_17223'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17223'])
            }
            else {
                return "-";
            }
        },
        'dis_grd_17224': function (obj, type) {
            if (obj.aData['dis_grd_17224'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17224'])
            } else {
                return "-";
            }
        },
        'dis_grd_17426': function (obj, type) {
            if (obj.aData['dis_grd_17426'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17426'])
            }
            else {
                return "-";
            }
        }

    },

    //Initial Disclosure List By Employee
    'GridType_114103': {

        'dis_grd_52065': function (obj, type) {
            if (obj.aData['UserInfoId'] != '') {
                $("#Grd_Employee_OwnSecurities").show();
            }
            if (obj.aData['dis_grd_52065'] != null)
                return obj.aData['dis_grd_52065'];
            else {
                return '-';
            }
        },
        'dis_grd_52066': function (obj, type) {
            var status = '';
            if (obj.aData['DocumentUploadStatus'] == "Pending") {
                status = '<a href="' + $('#ViewPolicyDocument').val() + '&PolicyDocumentId=' + obj.aData['PolicyDocumentId'] + '&DocumentId=' + obj.aData['DocumentId'] + '&CalledFrom=' + 'ViewAgree' + '&RequiredModuleID=' + '513001' + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['DocumentUploadStatus'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['DocumentUploadStatus'] == "Viewed") {
                status = '<a href="' + $('#ViewPolicyDocument').val() + '&PolicyDocumentId=' + obj.aData['PolicyDocumentId'] + '&DocumentId=' + obj.aData['DocumentId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&CalledFrom=' + 'View' + '&RequiredModuleID=' + '513001' + ' ">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + obj.aData['DocumentUploadStatus'];
                status = status + '</button></p> </a>';
            }
            return status;
        },
        //ID transaction button
        'dis_grd_50756': function (obj, type) {
            var status = '';
            if (obj.aData['TextInitialDisclosureDate'] == "Pending") {
                status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '&frm=' + obj.aData['FrmView'] + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
            if (obj.aData['TextInitialDisclosureDate'] == "Document Uploaded") {
                status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
                //else if (obj.aData['TextInitialDisclosureDate'] == null) {
                //    status = '<a firstButton="firstButton" href="' + $('#InitialDisclosure').val() + '&TransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '">';
                //    status = status + '<p class="text-center status-green">';
                //    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                //    status = status + dateTimeFormat(obj.aData['dis_grd_50756']);
                //    if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                //        status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                //    }
                //    status = status + '</button></p> </a>';
                //}
            else if (obj.aData['TextInitialDisclosureDate'] == null) {
                status = '<a firstButton="firstButton" href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&TransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '&frm=' + obj.aData['FrmView'] + '">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_50756']);
                if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                    status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                }
                status = status + '</button></p> </a>';
            }
            return status;
        },
        //Soft Copy
        'dis_grd_50757': function (obj, type) {
            var status = '';
            switch (obj.aData['TextSoftCopyDate']) {
                case "Pending":
                    status = '<a href="' + $('#SoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&uid=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    status = '<a href="' + $('#ViewSoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&uid=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_50757']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        //Hard Copy
        'dis_grd_50758': function (obj, type) {
            var status = '';
            switch (obj.aData['TextHardCopyDate']) {
                case "Pending":
                    status = '<a href="' + $('#HardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    status = '<a href="' + $('#ViewHardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&CalledFrom=' + 'ViewHardCopy' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_50758']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
    },


    //Initial Disclosure List By Insider
    'GridType_114104': {

        'dis_grd_50759': function (obj, type) {

            if (obj.aData['UserInfoId'] != '') {
                $("#Grd_Insider_OwnSecurities").show();
            }

            if (obj.aData['dis_grd_50759'] != null)
                return obj.aData['dis_grd_50759'];
            else {
                return '-';
            }
        },
        'dis_grd_50760': function (obj, type) {
            var status = '';
            if (obj.aData['DocumentUploadStatus'] == "Pending") {
                status = '<a href="' + $('#ViewPolicyDocument').val() + '&PolicyDocumentId=' + obj.aData['PolicyDocumentId'] + '&DocumentId=' + obj.aData['DocumentId'] + '&CalledFrom=' + 'ViewAgree' + '&RequiredModuleID=' + '513001' + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['DocumentUploadStatus'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['DocumentUploadStatus'] == "Viewed") {
                status = '<a href="' + $('#ViewPolicyDocument').val() + '&PolicyDocumentId=' + obj.aData['PolicyDocumentId'] + '&DocumentId=' + obj.aData['DocumentId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&CalledFrom=' + 'View' + '&RequiredModuleID=' + '513001' + ' ">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + obj.aData['DocumentUploadStatus'];
                status = status + '</button></p> </a>';
            }
            return status;
        },
        //ID transaction button
        'dis_grd_50761': function (obj, type) {
            var status = '';
            if (obj.aData['TextInitialDisclosureDate'] == "Pending") {
                status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '&frm=' + obj.aData['FrmView'] + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
            if (obj.aData['TextInitialDisclosureDate'] == "Document Uploaded") {
                status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextInitialDisclosureDate'] == null) {
                status = '<a firstButton="firstButton" href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&TransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '&frm=' + obj.aData['FrmView'] + '">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_50761']);
                if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                    status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                }
                status = status + '</button></p> </a>';
            }
            return status;
        },
        //Soft Copy
        'dis_grd_50762': function (obj, type) {
            var status = '';
            switch (obj.aData['TextSoftCopyDate']) {
                case "Pending":
                    status = '<a href="' + $('#SoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&uid=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    status = '<a href="' + $('#ViewSoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&uid=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_50762']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        //Hard Copy
        'dis_grd_50763': function (obj, type) {
            var status = '';
            switch (obj.aData['TextHardCopyDate']) {
                case "Pending":
                    status = '<a href="' + $('#HardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    status = '<a href="' + $('#ViewHardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&CalledFrom=' + 'ViewHardCopy' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_50763']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
    },


    //Initial Disclosure List By CO
    'GridType_114048': {
        'dis_grd_17250': function (obj, type) {
            var status = '';
            if (obj.aData['TextEmailSentDate'] == "Pending") {
                status = '<a firstButton="firstButton" >';
                status = status + '<p class="text-center status-orange">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-arrow btn-arrow-line-show btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['TextEmailSentDate'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextEmailSentDate'] != "DONOTSHOW" && obj.aData['TextEmailSentDate'] != "Pending") {
                status = '<a firstButton="firstButton" >';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_17250']);
                status = status + '</button></p> </a>';
            }
            return status;
        },
        // Initial disclosure
        'dis_grd_17251': function (obj, type) {
            var status = '';
            if (obj.aData['TextInitialDisclosureDate'] == "Pending") {
                //status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + ' ">';
                status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '">';
                // status = status + '<p class="text-center">';                
                if (obj.aData['dis_grd_50608'] == "Inactive" && obj.aData['TextInitialDisclosureDate'] == "Pending") {
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['dis_grd_50608'];
                }
                else {
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextInitialDisclosureDate'];
                }
                status = status + '</button></p> </a>';
            }
            if (obj.aData['TextInitialDisclosureDate'] == "Document Uploaded") {
                //status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + ' ">';

                status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '">';

                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextInitialDisclosureDate'] == null) {
                //status = '<a firstButton="firstButton" href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&TransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_17251']);
                if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                    status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                }
                status = status + '</button></p> </a>';
            }

            if (obj.aData['TransPendingFlag'] >= 1) {
                if (obj.aData['TransPendingFlag'] >= "1") {
                    status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '"class="fa fa-download" title="Download Form E file">';

                    status = status + '</a>';
                } else {
                    //status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                    //status = status + '</a>'
                }
            }
            return status;
        },
        //Soft Copy
        'dis_grd_17269': function (obj, type) {
            var status = '';
            switch (obj.aData['TextSoftCopyDate']) {
                case "Pending":
                    //status = '<a href="' + $('#SoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '">';
                    if (obj.aData['dis_grd_50608'] == "Inactive" && obj.aData['TextSoftCopyDate'] == "Pending") {
                        status = status + '<p class="text-center status-gray"">';
                        status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        status = status + obj.aData['dis_grd_50608'];
                    }
                    else {
                        status = status + '<p class="text-center status-orange">';
                        status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                        status = status + obj.aData['TextSoftCopyDate'];
                    }
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    //status = '<a href="' + $('#ViewSoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_17269']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }

            if (obj.aData['SoftcopyPendingFlag'] >= 1) {
                if (obj.aData['SoftcopyPendingFlag'] >= "1") {
                    status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '"class="fa fa-download" title="Download Form E file">';

                    status = status + '</a>';
                } else {
                    //status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="glyphicon glyphicon-download-alt downloadforme" title="Download Form E file" >';
                    //status = status + '</a>'
                }
            }

            return status;
        },
        //Hard Copy
        'dis_grd_17252': function (obj, type) {
            var status = '';
            switch (obj.aData['TextHardCopyDate']) {
                case "Pending":
                    //status = '<a href="' + $('#HardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '">';
                    //status = status + '<p class="text-center status-orange">';
                    if (obj.aData['dis_grd_50608'] == "Inactive" && obj.aData['TextHardCopyDate'] == "Pending") {
                        //status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                        status = status + '<p class="text-center status-gray"">';
                        status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        status = status + obj.aData['dis_grd_50608'];
                    }
                    else {
                        status = status + '<p class="text-center status-orange">';
                        status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                        status = status + obj.aData['TextHardCopyDate'];
                    }
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    //status = '<a href="' + $('#ViewHardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_17252']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }

            if (obj.aData['HardcopyPendingFlag'] >= 1) {
                if (obj.aData['HardcopyPendingFlag'] >= "1") {
                    status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513001' + '"class="fa fa-download" title="Download Form E file">';

                    status = status + '</a>';
                } else {
                    //status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="glyphicon glyphicon-download-alt downloadforme" title="Download Form E file" >';
                    //status = status + '</a>'
                }
            }
            return status;
        },
        //Submission to stock exchange
        'dis_grd_17253': function (obj, type) {
            var status = '';
            if (obj.aData['TextSubmitToStockExchange'] == "Pending") {
                status = '<a href="' + $('#stockexchangecopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                status = status + '<p class="text-center status-orange">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['TextSubmitToStockExchange'];
                status = status + '</button></p> </a>';
            }
            if (obj.aData['TextSubmitToStockExchange'] == "Not Required") {
                status = '<a  >';
                status = status + '<p class="text-center status-gray"">';
                status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                status = status + obj.aData['TextSubmitToStockExchange'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextSubmitToStockExchange'] == null) {
                status = '<a href="' + $('#stockexchangecopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_17253']);
                status = status + '</button></p> </a>';
            }
            return status;
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
    },


    //Initial Disclosure List By CO for Other Securities
    'GridType_114117': {
        'dis_grd_52035': function (obj, type) {
            var status = '';
            if (obj.aData['TextEmailSentDate'] == "Pending") {
                status = '<a firstButton="firstButton" >';
                status = status + '<p class="text-center status-orange">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-arrow btn-arrow-line-show btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['TextEmailSentDate'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextEmailSentDate'] != "DONOTSHOW" && obj.aData['TextEmailSentDate'] != "Pending" && obj.aData['TextEmailSentDate'] != "Not Required") {
                status = '<a firstButton="firstButton" >';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_52035']);
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextEmailSentDate'] == "Not Required") {
                status = '<a  >';
                status = status + '<p class="text-center status-gray"">';
                status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                status = status + obj.aData['TextEmailSentDate'];
                status = status + '</button></p> </a>';
            }
            return status;
        },
        // Initial disclosure
        'dis_grd_52036': function (obj, type) {
            var status = '';
            if (obj.aData['TextInitialDisclosureDate'] == "Pending") {
                //status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + ' ">';
                status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                //status = status + '<p class="text-center">';
                if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextInitialDisclosureDate'] == "Pending") {
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['dis_grd_50608'];
                }
                else {
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextInitialDisclosureDate'];
                }
                status = status + '</button></p> </a>';
            }
            if (obj.aData['TextInitialDisclosureDate'] == "Document Uploaded") {
                //status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + ' ">';

                status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';

                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextInitialDisclosureDate'] == null) {
                //status = '<a firstButton="firstButton" href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&TransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_52036']);
                if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                    status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                }
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextInitialDisclosureDate'] == "Not Required") {
                status = '<a  >';
                status = status + '<p class="text-center status-gray"">';
                if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextInitialDisclosureDate'] == "Not Required" && obj.aData['dis_grd_52036'] == null) {
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['dis_grd_52040'];
                }
                else if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextInitialDisclosureDate'] == "Not Required" && obj.aData['dis_grd_52036']!=null) {
                   
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_52036']);
                    if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                        status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    status = status + '</button></p> </a>';

                }

                else {
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextInitialDisclosureDate'];
                }

                status = status + '</button></p> </a>';
            }

            if (obj.aData['TransPendingFlag'] >= 1) {
                if (obj.aData['TransPendingFlag'] >= "1") {
                    status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '"class="fa fa-download" title="Download Form E file">';

                    status = status + '</a>';
                } else {
                    //status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="glyphicon glyphicon-download-alt downloadforme" title="Download Form E file" >';
                    //status = status + '</a>'
                }
            }
            return status;
        },
        //Soft Copy
        'dis_grd_52037': function (obj, type) {
            var status = '';
            switch (obj.aData['TextSoftCopyDate']) {
                case "Pending":
                    //status = '<a href="' + $('#SoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextSoftCopyDate'] == "Not Required" && obj.aData['Transactionstatus']==0) {
                        status = '';
                    }
                    else if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextSoftCopyDate'] == "Not Required" && (obj.aData['Transactionstatus'] == 148003 || obj.aData['Transactionstatus'] == 148004) && obj.aData['dis_grd_52037'] != null) {
                        status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                        status = status + '<p class="text-center status-green">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                        status = status + dateTimeFormat(obj.aData['dis_grd_52037']);
                        status = status + '</button></p> </a>';
                    }
                    else {
                        status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                        status = status + obj.aData['TextSoftCopyDate'];
                    }
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    //status = '<a href="' + $('#ViewSoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_52037']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }

            if (obj.aData['SoftcopyPendingFlag'] >= 1) {
                if (obj.aData['SoftcopyPendingFlag'] >= "1") {
                    status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '"class="fa fa-download" title="Download Form E file">';

                    status = status + '</a>';
                } else {
                    //status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="glyphicon glyphicon-download-alt downloadforme" title="Download Form E file" >';
                    //status = status + '</a>'
                }
            }

            return status;
        },
        //Hard Copy
        'dis_grd_52038': function (obj, type) {
            var status = '';
            switch (obj.aData['TextHardCopyDate']) {
                case "Pending":
                    //status = '<a href="' + $('#HardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                    if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextHardCopyDate'] == "Pending") {
                        status = status + '<p class="text-center status-gray"">';
                        status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        status = status + obj.aData['dis_grd_52040'];
                    }
                    else {
                        status = status + '<p class="text-center status-orange">';
                        status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                        status = status + obj.aData['TextHardCopyDate'];
                    }
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextHardCopyDate'] == "Not Required" && (obj.aData['Transactionstatus'] == 0) && obj.aData['dis_grd_52038'] == null) {
                        status = '';
                    }
                    else if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextHardCopyDate'] == "Not Required" && (obj.aData['Transactionstatus'] == 148004) && obj.aData['dis_grd_52038'] == null) {
                        status = status + '<p class="text-center status-gray"">';
                        status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        status = status + obj.aData['dis_grd_52040'];
                    }
                    else if (obj.aData['dis_grd_52040'] == "Inactive" && obj.aData['TextHardCopyDate'] == "Not Required" && obj.aData['Transactionstatus'] == 148003 && obj.aData['dis_grd_52038']!=null) {
                        status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                        status = status + '<p class="text-center status-green">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                        status = status + dateTimeFormat(obj.aData['dis_grd_52038']);
                        status = status + '</button></p> </a>';
                    }
                    else {
                        status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                        status = status + obj.aData['TextHardCopyDate'];
                    }
                    status = status + '</button></p> </a>';
                    break;           
                case null:
                    //status = '<a href="' + $('#ViewHardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                    status = '<a href= "' + $('#InitialDisclosure').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_52038']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }

            if (obj.aData['HardcopyPendingFlag'] >= 1) {
                if (obj.aData['HardcopyPendingFlag'] >= "1") {
                    status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=165&UserInfoId=' + obj.aData['UserInfoId'] + '&ReqModuleId=513002' + '"class="fa fa-download" title="Download Form E file">';

                    status = status + '</a>';
                } else {
                    //status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="glyphicon glyphicon-download-alt downloadforme" title="Download Form E file" >';
                    //status = status + '</a>'
                }
            }
            return status;
        },
        //Submission to stock exchange
        'dis_grd_52039': function (obj, type) {
            var status = '';
            if (obj.aData['TextSubmitToStockExchange'] == "Pending") {
                status = '<a href="' + $('#stockexchangecopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                status = status + '<p class="text-center status-orange">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['TextSubmitToStockExchange'];
                status = status + '</button></p> </a>';
            }
            if (obj.aData['TextSubmitToStockExchange'] == "Not Required") {
                status = '<a  >';
                status = status + '<p class="text-center status-gray"">';
                status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                status = status + obj.aData['TextSubmitToStockExchange'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextSubmitToStockExchange'] == null) {
                status = '<a href="' + $('#stockexchangecopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_52039']);
                status = status + '</button></p> </a>';
            }
            return status;
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
    },



    //For Non-Imp
    //Initial Disclosure List By Employee (Other Securities)
    'GridType_114107': {

        'dis_grd_52001': function (obj, type) {
            if (obj.aData['UserInfoId'] != '') {
                $("#Grd_Employee_OtherSecurities").show();
            }

            if (obj.aData['dis_grd_52001'] != null)
                return obj.aData['dis_grd_52001'];
            else {
                return '-';
            }
        },
        'dis_grd_52002': function (obj, type) {
            var status = '';
            if (obj.aData['DocumentUploadStatus'] == "Pending") {
                status = '<a href="' + $('#ViewPolicyDocument').val() + '&PolicyDocumentId=' + obj.aData['PolicyDocumentId'] + '&DocumentId=' + obj.aData['DocumentId'] + '&CalledFrom=' + 'ViewAgree_OS' + '&RequiredModuleID=' + '513002' + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['DocumentUploadStatus'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['DocumentUploadStatus'] == "Viewed") {
                status = '<a href="' + $('#ViewPolicyDocument').val() + '&PolicyDocumentId=' + obj.aData['PolicyDocumentId'] + '&DocumentId=' + obj.aData['DocumentId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&CalledFrom=' + 'View_OS' + '&RequiredModuleID=' + '513002' + ' ">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + obj.aData['DocumentUploadStatus'];
                status = status + '</button></p> </a>';
            }
            return status;
        },
        //ID transaction button
        'dis_grd_52003': function (obj, type) {
            var status = '';
            if (obj.aData['TextInitialDisclosureDate'] == "Pending") {
                status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '&frm=' + obj.aData['FrmView'] + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
            if (obj.aData['TextInitialDisclosureDate'] == "Document Uploaded") {
                status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
                //else if (obj.aData['TextInitialDisclosureDate'] == null) {
                //    status = '<a firstButton="firstButton" href="' + $('#InitialDisclosure').val() + '&TransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '">';
                //    status = status + '<p class="text-center status-green">';
                //    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                //    status = status + dateTimeFormat(obj.aData['dis_grd_50756']);
                //    if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                //        status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                //    }
                //    status = status + '</button></p> </a>';
                //}
            else if (obj.aData['TextInitialDisclosureDate'] == null) {
                status = '<a firstButton="firstButton" href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&TransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '&frm=' + obj.aData['FrmView'] + '">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_52003']);
                if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                    status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                }
                status = status + '</button></p> </a>';
            }
            return status;
        },
        //Soft Copy
        'dis_grd_52004': function (obj, type) {
            var status = '';
            switch (obj.aData['TextSoftCopyDate']) {
                case "Pending":
                    status = '<a href="' + $('#SoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    status = '<a href="' + $('#SoftCopy').val() + '?acid=165&MapToTypeCodeId=132020&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&DisplayCode=Initial Disclosures Form B  for OS ' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_52009']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        //Hard Copy
        'dis_grd_52005': function (obj, type) {
            var status = '';
            switch (obj.aData['TextHardCopyDate']) {
                case "Pending":
                    status = '<a href="' + $('#HardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    status = '<a href="' + $('#ViewHardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&CalledFrom=' + 'ViewHardCopyOS' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_52005']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },

    },

    //Initial Disclosure List By Insider (Other Securities)
    'GridType_114108': {
        'dis_grd_52006': function (obj, type) {
            if (obj.aData['UserInfoId'] != '') {
                $("#Grd_Insider_OtherSecurities").show();
            }
            if (obj.aData['dis_grd_52006'] != null)
                return obj.aData['dis_grd_52006'];
            else {
                return '-';
            }
        },
        'dis_grd_52007': function (obj, type) {
            var status = '';
            if (obj.aData['DocumentUploadStatus'] == "Pending") {
                status = '<a href="' + $('#ViewPolicyDocument').val() + '&PolicyDocumentId=' + obj.aData['PolicyDocumentId'] + '&DocumentId=' + obj.aData['DocumentId'] + '&CalledFrom=' + 'ViewAgree_OS' + '&RequiredModuleID=' + '513002' + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['DocumentUploadStatus'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['DocumentUploadStatus'] == "Viewed") {
                status = '<a href="' + $('#ViewPolicyDocument').val() + '&PolicyDocumentId=' + obj.aData['PolicyDocumentId'] + '&DocumentId=' + obj.aData['DocumentId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&CalledFrom=' + 'View_OS' + '&RequiredModuleID=' + '513002' + ' ">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + obj.aData['DocumentUploadStatus'];
                status = status + '</button></p> </a>';
            }
            return status;
        },
        //ID transaction button
        'dis_grd_52008': function (obj, type) {
            var status = '';
            if (obj.aData['TextInitialDisclosureDate'] == "Pending") {
                status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '&frm=' + obj.aData['FrmView'] + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
            if (obj.aData['TextInitialDisclosureDate'] == "Document Uploaded") {
                status = '<a href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + ' ">';
                status = status + '<p class="text-center">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                status = status + obj.aData['TextInitialDisclosureDate'];
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['TextInitialDisclosureDate'] == null) {
                status = '<a firstButton="firstButton" href="' + $('#InitialDisclosure').val() + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&TransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserTypeCodeId=' + obj.aData['UserTypeCodeId'] + '&frm=' + obj.aData['FrmView'] + '">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['dis_grd_52008']);
                if (obj.aData['IsEnterAndUploadEvent'] == '1') {
                    status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                }
                status = status + '</button></p> </a>';
            }
            return status;
        },
        //Soft Copy
        'dis_grd_52009': function (obj, type) {
            var status = '';
            switch (obj.aData['TextSoftCopyDate']) {
                case "Pending":
                    status = '<a href="' + $('#SoftCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&ParentId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextSoftCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    status = '<a href="' + $('#SoftCopy').val() + '?acid=155&MapToTypeCodeId=132020&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&DisplayCode=Initial Disclosures Form for Other Securities' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_52009']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        //Hard Copy
        'dis_grd_52010': function (obj, type) {
            var status = '';
            switch (obj.aData['TextHardCopyDate']) {
                case "Pending":
                    status = '<a href="' + $('#HardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&frm=' + obj.aData['FrmView'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case "Not Required":
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['TextHardCopyDate'];
                    status = status + '</button></p> </a>';
                    break;
                case null:
                    status = '<a href="' + $('#ViewHardCopy').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&nUserInfoId=' + obj.aData['ParentUserInfoID'] + '&CalledFrom=' + 'ViewHardCopyOS' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['dis_grd_52010']);
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
    },
    //Preclearnce List By Insider(Other Securities)
    'GridType_114118': {
        'dis_grd_53013': function (obj, type) {
            debugger
            if (obj.aData['PreclearanceRequestId'] != null && obj.aData['PreclearanceRequestId'] > 0) {
                var status = "";
                status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" style="color:blue;">';
                status = status + obj.aData['dis_grd_53013'];
                status = status + '</a>';
                if (obj.aData["dis_grd_53013"] != "" && obj.aData['PreclearanceStatusCodeId'] == 144002){                    
                    //&& obj.aData['IsPreclearanceFormForImplementingCompany'] == 1) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '&PreClearanceRequestId=' + obj.aData['DisplaySequenceNo'] + '&DisplayCode=' + obj.aData['dis_grd_53013'] + '" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    }

                }
                return status;
            } else {
                return obj.aData['dis_grd_53013'];
            }
        },
        'dis_grd_53016': function (obj, type) {
            var status = '';
            switch (obj.aData['PreclearanceStatusCodeId']) {
                case 144001:
                    status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['dis_grd_53016'];
                    status = status + '</button></p> </a>';

                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Valid till ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }
                    break;
                case 144002:
                    status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    status = status + obj.aData['dis_grd_53016'];
                    status = status + '</button></p> </a>';

                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Valid till ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }
                    break;
                case 144003:
                    status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-arrow btn-md"><i class="ico ico-times"></i> ';
                    status = status + obj.aData['dis_grd_53016'];
                    status = status + '</button></p> </a>';

                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_53021': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_53021']) {
                case 154002:

                    if (obj.aData['PreclearanceStatusCodeId'] == '144002') {//Preclearance approved
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['ContinuousDisclosureStatus'];
                    status = status + '</button></p> </a>';
                    break;
                case 154001:
                    if (obj.aData['dis_grd_53016'] == '') {
                        if (obj.aData['PreclearanceRequestId'] == null)
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                        else
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                    }
                    else {
                        if (obj.aData['PreclearanceRequestId'] == null)
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                        else
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                    }
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['ContinuousDisclosureButtonText']);
                    if (obj.aData['IsEnterAndUploadEvent'] == '2') {
                        status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    status = status + '</button></p> </a>';


                    break;
                case 154006:
                    if (obj.aData['dis_grd_53016'] == '') {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '">';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                    status = status + obj.aData['ContinuousDisclosureStatus'];
                    status = status + '</button></p> </a>';

                    break;
                case 154005:
                    if (obj.aData['dis_grd_53016'] == '') {
                        status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=Insider&acid=239' + '&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=Insider&acid=239' + '&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                    }
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-round  btn-md center-block"><i class="ico ico-exch"></i> ';
                    status = status + obj.aData['ContinuousDisclosureStatus'];
                    status = status + '</button></p> </a>';

                    break;
                case 154004:
                    if (obj.aData['TransactionMasterID'] > 0) {
                        if (obj.aData['dis_grd_53016'] == '') {
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '" firstButton="firstButton" >';
                        }
                        else {
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '">';
                        }
                        status = status + '<p class="text-center status-green">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['ContinuousDisclosureStatus'];
                        status = status + '</button></p> </a>';
                    } else if (obj.aData['ReasonForNotTradingCodeId'] != null) {
                        if (obj.aData['dis_grd_53016'] == '') {
                            status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=Insider&acid=239' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                        }
                        else {
                            status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=Insider&acid=239' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                        }
                        status = status + '<p class="text-center status-green-end">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['ContinuousDisclosureStatus'];
                        status = status + '</button></p> </a>';
                    }
                    else {
                        if (obj.aData['IsPartiallyTraded'] == 1 && obj.aData['ShowAddButton'] == 1) {
                            if (obj.aData['dis_grd_53016'] == '') {
                                status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '" firstButton="firstButton" >';
                            }
                            else {
                                status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '">';
                            }
                            status = status + '<p class="text-center status-orange">';
                            status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="fa fa-plus-square"></i> ';
                            status = status + obj.aData['ContinuousDisclosureStatus'];
                            status = status + '</button></p> </a>';
                        }
                        else {
                            if (obj.aData['IsPartiallyTraded'] == 1) {
                                if (obj.aData['dis_grd_53016'] == '') {
                                    status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                                }
                                else {
                                    status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=239&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                                }
                                status = status + '<p class="text-center status-green">';
                                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                                status = status + obj.aData['ContinuousDisclosureStatus'];
                                status = status + '</button></p> </a>';
                            }
                        }
                    }
                    break;
                default:
                    status = '';
                    break;
            }
            status = status + '<span style="display:none;">' + obj.aData['dis_grd_53016'] + '</span>';
            return status;
        },
        'dis_grd_53022': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_53022']) {
                case 0:
                    status = '<a href="' + $('#SoftcopyPending').val() + '?nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001&acid=' + $('#DisclosureActionID').val() + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 1:
                    status = '<a href="' + $('#SoftcopyView').val() + '?acid=239&MapToTypeCodeId=132020&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&DisplayCode=Form C  for OS ' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['SoftcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },

        'dis_grd_53023': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_53023']) {
                case 0:
                    status = '<a href="' + $('#HardcopyPending').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    //if (obj.aData['HardcopySubmissionwithin'] != null) {
                    //    status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['HardcopySubmissionwithin'] + '</span><span>' + obj.aData['HardcopySubmissionwithinText'] + '</span></p>'
                    //}
                    break;
                case 1:
                    status = '<a href="' + $('#HardcopyView').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&CalledFrom=' + 'ViewHardCopyOS_CD' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['HardcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
    },


    //Preclearance List For CO (Other Securities)
    'GridType_114119': {
        'usr_grd_11228': function (obj, type) {
            if (obj.aData['PreclearanceStatusCodeId'] == 153045) {
                return createActionControlArray(obj, '114119_usr_grd_11228');
            }
            else {
                var str = "";
                if (obj.aData['PreclearanceStatusCodeId'] == 153046 || obj.aData['PreclearanceStatusCodeId'] == 153047) {
                    str = '<input type="checkbox" disabled = "disabled"/>'
                }
                return str;
            }
        },
        'dis_grd_53040': function (obj, type) {
            if (obj.aData['PreclearanceRequestId'] != null && obj.aData['PreclearanceRequestId'] > 0) {
                var status = "";
                status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" style="color:blue;">';
                status = status + obj.aData['dis_grd_53040'];
                status = status + '</a>';
                if (obj.aData["dis_grd_53040"] != "" && obj.aData['PreclearanceStatusCodeId'] == 153046){
                    //&& obj.aData['IsPreclearanceFormForImplementingCompany'] == 1) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '&PreClearanceRequestId=' + obj.aData['DisplaySequenceNo'] + '&DisplayCode=' + obj.aData['dis_grd_53040'] + '" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    }

                }
                return status;
            } else {
                return obj.aData['dis_grd_53040'];
            }
        },

        'dis_grd_53042': function (obj, type) {
            if (obj.aData['dis_grd_53042'] != null)
                return obj.aData['dis_grd_53042'];
            else {
                return '-';
            }
        },

        'dis_grd_53046': function (obj, type) {
            if (obj.aData['dis_grd_53046'] != null)
                return obj.aData['dis_grd_53046'];
            else {
                return '-';
            }
        },
        'dis_grd_53047': function (obj, type) {
            if (obj.aData['dis_grd_53047'] != null)
                return obj.aData['dis_grd_53047'];
            else {
                return '-';
            }
        },
        'dis_grd_53039': function (obj, type) {
            if (obj.aData['dis_grd_53039'] != null)
                return obj.aData['dis_grd_53039'];
            else {
                return '-';
            }
        },

        'dis_grd_53043': function (obj, type) {
            var status = '';
            switch (obj.aData['PreclearanceStatusCodeId']) {
                case 153045:
                    status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['dis_grd_53043'];
                    status = status + '</button></p> </a>';
                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Take action before ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }
                    //if (obj.aData['PreclearanceValidTill'] != null) {
                    //    status = status + '<p style="font-size:12px;"><small>Valid till ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    //}
                    break;
                case 153046:
                    status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    status = status + obj.aData['dis_grd_53043'];
                    status = status + '</button></p> </a>';

                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Valid till ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }
                    break;
                case 153047:
                    status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-arrow btn-md"><i class="ico ico-times"></i> ';
                    status = status + obj.aData['dis_grd_53043'];
                    status = status + '</button></p> </a>';

                    break;
                default:
                    status = '-';
                    break;
            }

            return status;
        },
        'dis_grd_53048': function (obj, type) {
            var status = '';
            switch (obj.aData['ContinuousDisclosureStatus']) {
                case 154002:

                    if (obj.aData['dis_grd_53043'] == '') {
                        if (obj.aData['PreclearanceRequestId'] == null)
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                        else
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                    }
                    else {
                        if (obj.aData['PreclearanceRequestId'] == null)
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                        else
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['dis_grd_53048'];
                    status = status + '</button></p> </a>';
                    break;
                case 154001:
                    if (obj.aData['dis_grd_53043'] == '') {
                        if (obj.aData['PreclearanceRequestId'] == null)
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                        else
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                    }
                    else {
                        if (obj.aData['PreclearanceRequestId'] == null)
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                        else
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                    }
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['ContinuousDisclosureSubmissionDate']);
                    if (obj.aData['IsEnterAndUploadEvent'] == '2') {
                        status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    status = status + '</button></p> </a>';


                    break;
                case 154006:
                    if (obj.aData['dis_grd_53043'] == '') {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '">';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-note"></i> ';
                    status = status + obj.aData['dis_grd_53048'];
                    status = status + '</button></p> </a>';

                    break;
                case 154005:
                    if (obj.aData['dis_grd_53043'] == '') {
                        status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=COPage&acid=240' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    }
                    else {
                        status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=COPage&acid=240' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                    }
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-round  btn-md center-block"><i class="ico ico-exch"></i> ';
                    status = status + obj.aData['dis_grd_53048'];
                    status = status + '</button></p> </a>';

                    break;
                case 154004:
                    if (obj.aData['TransactionMasterID'] > 0) {
                        if (obj.aData['dis_grd_53043'] == '') {
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                        }
                        else {
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                        }
                        status = status + '<p class="text-center status-green">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['dis_grd_53048'];
                        status = status + '</button></p> </a>';
                    } else if (obj.aData['ReasonForNotTradingCodeId'] != null) {
                        if (obj.aData['dis_grd_53043'] == '') {
                            status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=COPage&acid=240' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                        }
                        else {
                            status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=COPage&acid=240' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                        }
                        status = status + '<p class="text-center status-green-end">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['dis_grd_53048'];
                        status = status + '</button></p> </a>';
                    }
                    else {
                        if (obj.aData['IsPartiallyTraded'] == 1 && obj.aData['ShowAddButton'] == 1) {
                            if (obj.aData['dis_grd_53043'] == '') {
                                status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                            }
                            else {
                                status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                            }
                            status = status + '<p class="text-center status-orange">';
                            status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="fa fa-plus-square"></i> ';
                            status = status + obj.aData['dis_grd_53048'];
                            status = status + '</button></p> </a>';
                        }
                        else {
                            if (obj.aData['IsPartiallyTraded'] == 1) {
                                if (obj.aData['dis_grd_53043'] == '') {
                                    status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '" firstButton="firstButton" >';
                                }
                                else {
                                    status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=240&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&SecurityTypeCode=' + obj.aData['SecurityType'] + '&nUserTypeCodeId=' + obj.aData['UserType'] + '">';
                                }
                                status = status + '<p class="text-center status-green">';
                                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                                status = status + obj.aData['dis_grd_53048'];
                                status = status + '</button></p> </a>';
                            }
                        }
                    }
                    break;
                default:
                    status = '';
                    break;
            }
            status = status + '<span style="display:none;">' + obj.aData['dis_grd_53043'] + '</span>';
            return status;
        },
        'dis_grd_53049': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_53049']) {
                case 0:
                    status = '<a href="' + $('#SoftcopyPending').val() + '&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001' + '">';

                    if (obj.aData['dis_grd_17263'] != '' && obj.aData['dis_grd_17263'] != 0 && obj.aData['dis_grd_17263'] != 1 && obj.aData['dis_grd_17263'] != 2) {
                        status = status + '<p class="text-center status-orange">';
                    } else {

                        status = status + '<p class="text-center status-orange-notend">';
                    }
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 1:
                    //status = '<a href="' + $('#SoftcopyView').val() + '&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001' + '">';
                    status = '<a href="' + $('#SoftcopyView').val() + '?acid=240&MapToTypeCodeId=132020&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&DisplayCode=Form C  for OS ' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['SoftcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_53050': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_53050']) {
                case 0:
                    status = '<a href="' + $('#HardcopyPending').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '">';
                    //if (obj.aData['dis_grd_17264'] != '' && obj.aData['dis_grd_17264'] != 0 && obj.aData['dis_grd_17264'] != 1 && obj.aData['dis_grd_17264'] != 2) {
                    //    status = status + '<p class="text-center status-orange">';
                    //} else {

                    status = status + '<p class="text-center status-orange-notend">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    //if (obj.aData['HardcopySubmissionwithin'] != null) {
                    //    status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['HardcopySubmissionwithin'] + '</span><span>' + obj.aData['HardcopySubmissionwithinText'] + '</span></p>'
                    //}
                    break;
                case 1:
                    status = '<a href="' + $('#HardcopyView').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&CalledFrom=' + 'ViewHardCopyOS_CDCO' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['HardcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
    },


    //Transaction details list- self other security
    'GridType_114120': {
        'usr_grd_11073': function (obj, type) {
            $("#Wrn_Msg").show();
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'tra_grd_53064': function (obj, type) {
            if (obj.aData['CompanyID'] != null) {
                $("#btntblGrid").hide();
            }

            if (obj.aData['tra_grd_53064'] != null) {
                return dateTimeFormat(obj.aData['tra_grd_53064']);
            } else {
                return '';
            }
        },
        'tra_grd_53065': function (obj, type) {
            if (obj.aData['tra_grd_53065'] != null) {
                return dateTimeFormat(obj.aData['tra_grd_53065']);
            } else {
                return '';
            }
        },
    },

    //Transaction details list- relative other security
    'GridType_114121': {
        'usr_grd_11073': function (obj, type) {
            $("#Wrn_Msg").show();
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'tra_grd_53080': function (obj, type) {
            if (obj.aData['CompanyID'] != null) {
                $("#btntblGrid").hide();
            }

            if (obj.aData['tra_grd_53080'] != null) {
                return dateTimeFormat(obj.aData['tra_grd_53080']);
            } else {
                return '';
            }
        },
        'tra_grd_53081': function (obj, type) {
            if (obj.aData['tra_grd_53081'] != null) {
                return dateTimeFormat(obj.aData['tra_grd_53081']);
            } else {
                return '';
            }
        },
    },

    //Initial Disclosure List By Insider- Self (Other Securities)
    'GridType_114109': {

        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'dis_grd_52011': function (obj, type) {

            if (obj.aData['UserInfoId'] != '') {
                $("#Grd_User_OtherSecurities").show();
            }
            return obj.aData['dis_grd_52011'];
        },
    },

    //Initial Disclosure List By Insider- Relatives (Other Securities)
    'GridType_114110': {

        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
            // return createActionControlArray(obj, '114110_usr_grd_11073');
        },

        'dis_grd_52023': function (obj, type) {
            if (obj.aData['RelUserInfoId'] != '') {
                $("#Grd_Relative_OtherSecurities").show();
            }
            return obj.aData['dis_grd_52023'];
        },
    },

    //Continuous Disclosure list for CO
    'GridType_114049': {
        'dis_grd_17256': function (obj, type) {
            if (obj.aData['PreclearanceRequestId'] != null && obj.aData['PreclearanceRequestId'] > 0) {
                var status = "";
                status = '<a href="' + $('#View').val() + '&CalledFrom=View&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" style="color:blue;">';
                status = status + obj.aData['dis_grd_17256'];
                status = status + '</a>';
                if (obj.aData["dis_grd_17256"] != "" && obj.aData['dis_grd_17258'] == 153016 && obj.aData['IsPreclearanceFormForImplementingCompany'] == 1) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '&DisplayCode=' + obj.aData['dis_grd_17256'] + '"class="fa fa-download" title="Download Form E file">';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>'
                    }
                }
                return status;
                //return createActionControlArray(obj, '114049_dis_grd_17256');
            } else {
                return obj.aData['dis_grd_17256'];
            }
        },
        'dis_grd_17257': function (obj, type) {
            if (obj.aData['dis_grd_17257'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17257']);
            } else {
                return '';
            }

        },
        'dis_grd_17354': function (obj, type) {
            if (obj.aData['dis_grd_17354'] != null)
                return formatIndianNumber(obj.aData['dis_grd_17354']);
            else {
                return '-';
            }
        },
        'dis_grd_52123': function (obj, type) {
            if (obj.aData['dis_grd_52123'] != null)
                return formatIndianNumber(obj.aData['dis_grd_52123']);
            else {
                return '-';
            }
        },
        'dis_grd_17355': function (obj, type) {
            if (obj.aData['dis_grd_17355'] != null)
                return formatIndianNumber(obj.aData['dis_grd_17355']);
            else {
                return '-';
            }
        },
        'dis_grd_17448': function (obj, type) {
            if (obj.aData['dis_grd_17448'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17448']);
            } else {
                return "-";
            }
        },
        'dis_grd_17258': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17258']) {
                case 153015:
                    status = '<a href="' + $('#ApproveRejectView').val() + '?acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['PreClearanceStatusButtonText'];

                    status = status + '</button></p> </a>';
                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Take action before ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }

                    break;
                case 153016:
                    status = '<a href="' + $('#View').val() + '&CalledFrom=View&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    if (obj.aData['IsAutoApproved'] == 1) {
                        status = status + obj.aData['IsAutoApprovedText'];
                    } else {
                        status = status + obj.aData['PreClearanceStatusButtonText'];
                    }
                    status = status + '</button></p> </a>';
                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Valid till ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }
                    break;
                case 153017:
                    status = '<a href="' + $('#RejectionView').val() + '?CalledFrom=CO&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreClearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-round btn-md"><i class="ico ico-times"></i> ' + obj.aData['PreClearanceStatusButtonText'] + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17261': function (obj, type) {
            var status = '';
            var nPreClearanceNotTaken = false;
            if (obj.aData['dis_grd_17258'] == '') {
                nPreClearanceNotTaken = true;
            }
            switch (obj.aData['dis_grd_17261']) {
                case 154002:
                    if (nPreClearanceNotTaken) {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" firstButton="firstButton" >';
                    } else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '">';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 154001:
                    if (nPreClearanceNotTaken) {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" firstButton="firstButton" >';
                    } else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '">';
                    }
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['ContinuousDisclosureSubmissionDate']);
                    if (obj.aData['IsEnterAndUploadEvent'] == '2') {
                        status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    status = status + '</button></p> </a>';
                    break;
                case 154006:
                    if (nPreClearanceNotTaken) {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" firstButton="firstButton" >';
                    } else {
                        status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '">';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md"><i class="ico ico-note"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 154005:
                    if (nPreClearanceNotTaken) {
                        status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=CO&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                    } else {
                        status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=CO&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                    }
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-round  btn-md center-block"><i class="ico ico-exch"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button> </p> </a>';
                    break;
                case 154004:
                    if (obj.aData['TransactionMasterID'] > 0) {
                        if (nPreClearanceNotTaken) {
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                        } else {
                            status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                        }
                        status = status + '<p class="text-center status-green">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['TradingDetailsStatusButtonText'];
                        status = status + '</button></p> </a>';
                    } else if (obj.aData['ReasonForNotTradingCodeId'] != null) {
                        if (nPreClearanceNotTaken) {
                            status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=CO&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                        } else {
                            status = '<a href="' + $('#NotTradedView').val() + '?CalledFrom=CO&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                        }
                        status = status + '<p class="text-center status-green-end">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['TradingDetailsStatusButtonText'];
                        status = status + '</button></p> </a>';
                    }
                    else {
                        if (obj.aData['IsPartiallyTraded'] == 1 && obj.aData['ShowAddButton'] == 1) {
                            if (nPreClearanceNotTaken) {
                                status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                            } else {
                                status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                            }
                            status = status + '<p class="text-center status-orange">';
                            status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="fa fa-plus-square"></i> ';
                            status = status + obj.aData['TradingDetailsStatusButtonText'];
                            status = status + '</button></p> </a>';
                        }
                        else {
                            if (obj.aData['IsPartiallyTraded'] == 1) {
                                if (nPreClearanceNotTaken) {
                                    status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '" firstButton="firstButton" >';
                                } else {
                                    status = '<a href="' + $('#TradingDetailsPending').val() + '?acid=167&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nUserInfoId=' + obj.aData['UserInfoId'] + '&nDisclosureTypeCodeId=147002' + '&PreclearanceRequestId=' + obj.aData['PreclearanceRequestId'] + '">';
                                }
                                status = status + '<p class="text-center status-green">';
                                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                                status = status + obj.aData['TradingDetailsStatusButtonText'];
                                status = status + '</button></p> </a>';
                            }
                        }

                    }
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17262': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17262']) {
                case 0:

                    status = '<a href="' + $('#SoftcopyPending').val() + '&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001' + '">';

                    if (obj.aData['dis_grd_17263'] != '' && obj.aData['dis_grd_17263'] != 0 && obj.aData['dis_grd_17263'] != 1 && obj.aData['dis_grd_17263'] != 2) {
                        status = status + '<p class="text-center status-orange">';
                    } else {

                        status = status + '<p class="text-center status-orange-notend">';
                    }
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 1:
                    status = '<a href="' + $('#SoftcopyView').val() + '&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['SoftcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17263': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17263']) {
                case 0:
                    status = '<a href="' + $('#HardcopyPending').val() + '&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001' + '">';
                    if (obj.aData['dis_grd_17264'] != '' && obj.aData['dis_grd_17264'] != 0 && obj.aData['dis_grd_17264'] != 1 && obj.aData['dis_grd_17264'] != 2) {
                        status = status + '<p class="text-center status-orange">';
                    } else {

                        status = status + '<p class="text-center status-orange-notend">';
                    }

                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    if (obj.aData['HardcopySubmissionwithin'] != null) {
                        status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['HardcopySubmissionwithin'] + '</span><span>' + obj.aData['HardcopySubmissionwithinText'] + '</span></p>'
                    }
                    break;
                case 1:
                    status = '<a href="' + $('#HardcopyView').val() + '&CalledFrom=ContinousCO&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151001' + '">';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['HardcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17264': function (obj, type) {
            var status = '';
            switch (obj.aData['dis_grd_17264']) {
                case 0:
                    status = '<a href="' + $('#stockexchangecopylink').val() + '&IsStockExchange=true&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151002' + '">';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['HardCopySubmitCOToExchangeButtonText'];
                    status = status + '</button></p> </a>';
                    if (obj.aData['HardCopySubmitCOToExchangeWithin'] != null) {
                        status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['HardCopySubmitCOToExchangeWithin'] + '</span><span>' + obj.aData['HardCopySubmitCOToExchangeWithinText'] + '</span></p>'
                    }
                    break;
                case 1:
                    status = '<a href="' + $('#stockexchangecopyviewlink').val() + '&sStockExchange=true&nTransactionLetterId=0&nTransactionMasterId=' + obj.aData['TransactionMasterID'] + '&nDisclosureTypeCodeId=147002&nLetterForCodeId=151002' + '">';
                    status = status + '<p class="text-center status-aqua">';
                    status = status + '<button type="submit" class="btn btn-success btn-aqua btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['HardCopySubmitCOToExchangeDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block" ><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardCopySubmitCOToExchangeButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 3:
                    status = '<a  >';
                    status = status + '<p class="text-center status-aqua"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardCopySubmitCOToExchangeButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        }
    },

    ///Nse Download Group details delete functionality for CO added by shubhangi on 20170216

    'GridType_508008': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114049_usr_grd_11228');
        },
        'del_grd_50446': function (obj, type) {
            if (obj.aData['PreclearanceRequestId'] != null && obj.aData['PreclearanceRequestId'] > 0) {
                var status = "";
                status = '<a>';
                status = status + obj.aData['del_grd_50446'];
                status = status + '</a>';
                if (obj.aData["del_grd_50446"] != "" && obj.aData['del_grd_50446'] == 153016 && obj.aData['IsPreclearanceFormForImplementingCompany'] == 1) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a>';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a>';
                        status = status + '</a>'
                    }
                }
                return status;
                //return createActionControlArray(obj, '114049_dis_grd_17256');
            } else {
                return obj.aData['del_grd_50446'];
            }
        },
        'del_grd_50447': function (obj, type) {
            if (obj.aData['del_grd_50447'] != null) {
                return dateTimeFormat(obj.aData['del_grd_50447']);
            } else {
                return '';
            }

        },
        'del_grd_50451': function (obj, type) {
            if (obj.aData['del_grd_50451'] != null)
                return formatIndianNumber(obj.aData['del_grd_50451']);
        },
        'del_grd_50452': function (obj, type) {
            if (obj.aData['del_grd_50452'] != null)
                return formatIndianNumber(obj.aData['del_grd_50452']);
        },
        'del_grd_50456': function (obj, type) {
            if (obj.aData['del_grd_50456'] != null) {
                return formatIndianNumber(obj.aData['del_grd_50456']);
            } else {
                return "-";
            }
        },
        'del_grd_50448': function (obj, type) {
            var status = '';
            switch (obj.aData['del_grd_50448']) {
                case 153015:
                    status = '<a>';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block" disabled = "disabled"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['PreClearanceStatusButtonText'];

                    status = status + '</button></p> </a>';
                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Take action before ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }

                    break;
                case 153016:
                    status = '<a>';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md" disabled = "disabled"><i class="ico ico-check"></i> ';
                    if (obj.aData['IsAutoApproved'] == 1) {
                        status = status + obj.aData['IsAutoApprovedText'];
                    } else {
                        status = status + obj.aData['PreClearanceStatusButtonText'];
                    }
                    status = status + '</button></p> </a>';
                    if (obj.aData['PreclearanceValidTill'] != null) {
                        status = status + '<p style="font-size:12px;"><small>Valid till ' + dateTimeFormat(obj.aData['PreclearanceValidTill']) + '</small></p>';
                    }
                    break;
                case 153017:
                    status = '<a>';
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-round btn-md" disabled = "disabled"><i class="ico ico-times"></i> ' + obj.aData['PreClearanceStatusButtonText'] + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'del_grd_50457': function (obj, type) {
            var status = '';
            var nPreClearanceNotTaken = false;
            if (obj.aData['del_grd_50448'] == '') {
                nPreClearanceNotTaken = true;
            }
            switch (obj.aData['del_grd_50457']) {
                case 154002:

                    if (nPreClearanceNotTaken) {
                        status = '<a>';
                    } else {
                        status = '<a>';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block" disabled = "disabled"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button></p> </a>';
                    if (obj.aData['SubmmisonWithin'] != null) {
                        status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['SubmmisonWithin'] + '</span><span>' + obj.aData['ContinuousDisclosureSubmitWithinText'] + '</span></p>'
                    }
                    break;
                case 154001:
                    if (nPreClearanceNotTaken) {
                        status = '<a>';
                    } else {
                        status = '<a>';
                    }
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md" disabled = "disabled"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['ContinuousDisclosureSubmissionDate']);
                    if (obj.aData['IsEnterAndUploadEvent'] == '2') {
                        status = status + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    status = status + '</button></p> </a>';
                    break;
                case 154006:
                    if (nPreClearanceNotTaken) {
                        status = '<a>';
                    } else {
                        status = '<a>';
                    }
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md" disabled = "disabled"><i class="ico ico-note"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 154005:
                    if (nPreClearanceNotTaken) {
                        status = '<a>';
                    } else {
                        status = '<a>';
                    }
                    status = status + '<p class="text-center status-red">';
                    status = status + '<button type="submit" class="btn btn-danger btn-shape btn-round  btn-md center-block" disabled = "disabled"><i class="ico ico-exch"></i> ';
                    status = status + obj.aData['TradingDetailsStatusButtonText'];
                    status = status + '</button> </p> </a>';
                    break;
                case 154004:
                    if (obj.aData['TransactionMasterID'] > 0) {
                        if (nPreClearanceNotTaken) {
                            status = '<a>';
                        } else {
                            status = '<a>';
                        }
                        status = status + '<p class="text-center status-green">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md" disabled = "disabled"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['TradingDetailsStatusButtonText'];
                        status = status + '</button></p> </a>';
                    } else if (obj.aData['ReasonForNotTradingCodeId'] != null) {
                        if (nPreClearanceNotTaken) {
                            status = '<a>';
                        } else {
                            status = '<a>';
                        }
                        status = status + '<p class="text-center status-green-end">';
                        status = status + '<button type="submit" class="btn btn-success btn-shape btn-round btn-md" disabled = "disabled"><i class="ico ico-check"></i> ';
                        status = status + obj.aData['TradingDetailsStatusButtonText'];
                        status = status + '</button></p> </a>';
                    }
                    else {
                        if (obj.aData['IsPartiallyTraded'] == 1 && obj.aData['ShowAddButton'] == 1) {
                            if (nPreClearanceNotTaken) {
                                status = '<a >';
                            } else {
                                status = '<a >';
                            }
                            status = status + '<p class="text-center status-orange">';
                            status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block" disabled = "disabled"><i class="fa fa-plus-square"></i> ';
                            status = status + obj.aData['TradingDetailsStatusButtonText'];
                            status = status + '</button></p> </a>';
                        }
                        else {
                            if (obj.aData['IsPartiallyTraded'] == 1) {
                                if (nPreClearanceNotTaken) {
                                    status = '<a >';
                                } else {
                                    status = '<a >';
                                }
                                status = status + '<p class="text-center status-green">';
                                status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md" disabled = "disabled"><i class="ico ico-check"></i> ';
                                status = status + obj.aData['TradingDetailsStatusButtonText'];
                                status = status + '</button></p> </a>';
                            }
                        }

                    }
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'del_grd_50453': function (obj, type) {
            var status = '';
            switch (obj.aData['del_grd_50453']) {
                case 0:

                    status = '<a >';

                    if (obj.aData['del_grd_50453'] != '' && obj.aData['del_grd_50453'] != 0 && obj.aData['del_grd_50453'] != 1 && obj.aData['del_grd_50453'] != 2) {
                        status = status + '<p class="text-center status-orange">';
                    } else {

                        status = status + '<p class="text-center status-orange-notend">';
                    }
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block" disabled = "disabled"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    $(status).click(function (e) { e.preventDefault(); });
                    break;
                case 1:
                    status = '<a >';

                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md" disabled = "disabled"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['SoftcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    $(status).click(function (e) { e.preventDefault(); });
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block" disabled = "disabled"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['SoftcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';

                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'del_grd_50454': function (obj, type) {
            var status = '';
            switch (obj.aData['del_grd_50454']) {
                case 0:
                    status = '<a >';
                    if (obj.aData['del_grd_50454'] != '' && obj.aData['del_grd_50454'] != 0 && obj.aData['del_grd_50454'] != 1 && obj.aData['del_grd_50454'] != 2) {
                        status = status + '<p class="text-center status-orange">';
                    } else {

                        status = status + '<p class="text-center status-orange-notend">';
                    }

                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block" disabled = "disabled"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    if (obj.aData['HardcopySubmissionwithin'] != null) {
                        status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['HardcopySubmissionwithin'] + '</span><span>' + obj.aData['HardcopySubmissionwithinText'] + '</span></p>'
                    }
                    break;
                case 1:
                    status = '<a >';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow btn-md" disabled = "disabled"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['HardcopySubmissionDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block" disabled = "disabled"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardcopySubmissionButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'del_grd_50455': function (obj, type) {
            var status = '';
            switch (obj.aData['del_grd_50455']) {
                case 0:
                    status = '<a >';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block" disabled = "disabled"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['HardCopySubmitCOToExchangeButtonText'];
                    status = status + '</button></p> </a>';
                    if (obj.aData['HardCopySubmitCOToExchangeWithin'] != null) {
                        status = status + '<p class="inline-block"><span class="days-count"> ' + obj.aData['HardCopySubmitCOToExchangeWithin'] + '</span><span>' + obj.aData['HardCopySubmitCOToExchangeWithinText'] + '</span></p>'
                    }
                    break;
                case 1:
                    status = '<a >';
                    status = status + '<p class="text-center status-aqua">';
                    status = status + '<button type="submit" class="btn btn-success btn-aqua btn-shape btn-round btn-md" disabled = "disabled"><i class="ico ico-check"></i> ';
                    status = status + dateTimeFormat(obj.aData['HardCopySubmitCOToExchangeDate']);
                    status = status + '</button></p> </a>';
                    break;
                case 2:
                    status = '<a  >';
                    status = status + '<p class="text-center status-gray"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block" disabled = "disabled"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardCopySubmitCOToExchangeButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                case 3:
                    status = '<a  >';
                    status = status + '<p class="text-center status-aqua"">';
                    status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block" disabled = "disabled"><i class="ico ico-barred"></i> ';
                    status = status + obj.aData['HardCopySubmitCOToExchangeButtonText'];
                    status = status + '</button></p> </a>';
                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        }
    },

    //// NSE DownLoad for CO Added by Shubhangi on 20171001
    'GridType_508005': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray_For_NSE_DOWNLOAD(obj, objThis.GridType + '_usr_grd_11073');

        },
        'nse_grd_50430': function (obj, type) {
            if (obj.aData['nse_grd_50430'] != null) {
                return formatIndianNumber(obj.aData['nse_grd_50430'])

            }
            else {
                return '';
            }
        },
        'nse_grd_50431': function (obj, type) {
            if (obj.aData['nse_grd_50431'] != null) {
                return formatIndianNumber(obj.aData['nse_grd_50431'])
                //return obj.aData['nse_grd_50431'];
            }
            else {
                return '';
            }
        },
        'nse_grd_50432': function (obj, type) {
            if (obj.aData['nse_grd_50432'] != null) {
                return dateTimeFormat(obj.aData['nse_grd_50432']);
                //return obj.aData['nse_grd_50432'];
            } else {
                return '';
            }
        },
        'nse_grd_50433': function (obj, type) {
            var status = '';
            if (obj.aData['Groupsubmissionflag'] == 1 && obj.aData['nse_grd_50431'] != 0) {
                status = '<a href="' + $('#GroupSubmission').val() + '?acid=167&GroupId=' + obj.aData['GroupId'] + '" firstButton="firstButton">';
                status = status + '<p class="text-center status-green">';
                status = status + '<button type="submit" class="btn btn-success btn-aqua btn-shape btn-round btn-md"><i class="ico ico-check"></i> ';
                status = status + dateTimeFormat(obj.aData['nse_grd_50433']);
                status = status + '</button></p> </a>';
            }
            else if (obj.aData['Groupsubmissionflag'] == 2 && obj.aData['nse_grd_50431'] != 0) {
                status = '<a href="' + $('#GroupPending').val() + '?acid=223&GroupId=' + obj.aData['GroupId'] + '" firstButton="firstButton">';
                status = status + '<p class="text-center status-orange-notend">';
                status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round  btn-md center-block"><i class="ico ico-exc"></i> ';
                status = status + obj.aData['GroupsubmissionStatusText'];
                status = status + '</button></p> </a>';
            }
            else {
                status = status + '<p class="text-center status-gray">';
                status = status + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block" disabled = "disabled"><i class="ico ico-barred"></i> ';
                status = status + obj.aData['GroupsubmissionStatusText'];
                status = status + '</button></p> </a>';
            }


            return status;
        },
    },

    // Multiple pre-clearance request
    'GridType_507005': {
        'usr_grd_11073': function (obj, type) {
            var sUrlView = $('#EditPreclearance').val();
            var dUrl = $('[name=deleteRowURL]')[0].value + '&sequenceNo=' + obj.aData['SequenceNo'] + '&formId=' + 78;
            var data = [
                {
                    url: sUrlView,
                    type: LINK,
                    param: {
                        href: sUrlView + '&sequenceNo=' + obj.aData['SequenceNo'] + '&formId=' + 78,

                        'class': 'display-icon icon icon-edit'
                    }
                },
                {
                    url: dUrl,
                    type: LINK,
                    param: {
                        href: "javascript:void(0);",
                        name: "deleteRow",
                        "class": "display-icon icon icon-delete",
                        queryString: "[ { ID: 'sequenceNo', key: '" + obj.aData['SequenceNo'] + "' },{ ID: 'formId', key: '" + 78 + "' }]"
                    }
                }];
            return GenerateComponent(data);
        },
        'rl_grd_50581': function (obj, type) {
            if (obj.aData['rl_grd_50581'] != null) {
                return formatIndianNumber(obj.aData['rl_grd_50581'])
            }
            else {
                return '';
            }
        },
        'rl_grd_50582': function (obj, type) {
            if (obj.aData['rl_grd_50582'] != null) {
                return formatIndianNumber(obj.aData['rl_grd_50582'])
            }
            else {
                return '';
            }
        },
    },

    //Initial Disclosure Employee Wise Report
    'GridType_114050': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'rpt_grd_19006': function (obj, type) {
            if (obj.aData['rpt_grd_19006'] != null) {
                return obj.aData['rpt_grd_19006'];
            } else {
                return '';
            }
        },
        'rpt_grd_19072': function (obj, type) {
            if (obj.aData['rpt_grd_19072'] != null) {
                return obj.aData['rpt_grd_19072'];
            } else {
                return '';
            }
        },
        'rpt_grd_19073': function (obj, type) {
            if (obj.aData['rpt_grd_19073'] != null) {
                return obj.aData['rpt_grd_19073'];
            } else {
                return '';
            }
        },
        'rpt_grd_19015': function (obj, type) {
            //if (obj.aData['rpt_grd_19015'] != null) {
            //    return obj.aData['rpt_grd_19015'];
            //} else {
            //    return '';
            //}
            if (!isEmptyOrPending(obj.aData['rpt_grd_19015']) && obj.aData['rpt_grd_19015'] != '-') {
                var ReturnString = '';
                ReturnString = obj.aData['rpt_grd_19015'];
                if (!isEmptyOrPending(obj.aData['rpt_grd_19015']) && obj.aData['rpt_grd_19015'] != '-') {
                    var acid = obj.aData['Acid'];
                    var TransactionLetterId = obj.aData['TransactionLetterId'];
                    var DisclosureTypeCodeId = obj.aData['DisclosureTypeCodeId'];
                    var LetterForCodeId = obj.aData['LetterForCodeId'];
                    var TransactionMasterId = obj.aData['TransactionMasterId'];
                    var EmployeeId = obj.aData['EmployeeId'];
                    var URL = $("#SoftCopyLetterUrl").val() + "&acid=" + acid + "&EmployeeId=" + EmployeeId + "&nTransactionLetterId=" + TransactionLetterId + "&nDisclosureTypeCodeId=" + DisclosureTypeCodeId + "&nLetterForCodeId=" + LetterForCodeId + "&nTransactionMasterId=" + TransactionMasterId;
                    ReturnString = ReturnString + "<a href='" + URL + "'> ( View )</a>";
                }
                return ReturnString;
            } else {
                return obj.aData['rpt_grd_19015'];
            }
        },
        'rpt_grd_19016': function (obj, type) {
            //if (obj.aData['rpt_grd_19016'] != null) {
            //    return obj.aData['rpt_grd_19016'];
            //} else {
            //    return '';
            //}
            if (!isEmptyOrPending(obj.aData['rpt_grd_19016']) && obj.aData['rpt_grd_19016'] != '-') {
                var ReturnString = '';
                ReturnString = obj.aData['rpt_grd_19016'];
                if (!isEmptyOrPending(obj.aData['rpt_grd_19016']) && obj.aData['rpt_grd_19016'] != '-') {
                    var acid = obj.aData['Acid'];
                    var TransactionLetterId = obj.aData['TransactionLetterId'];
                    var DisclosureTypeCodeId = obj.aData['DisclosureTypeCodeId'];
                    var LetterForCodeId = obj.aData['LetterForCodeId'];
                    var TransactionMasterId = obj.aData['TransactionMasterId'];
                    var EmployeeId = obj.aData['EmployeeId'];
                    var URL = $("#HardCopyLetterUrl").val() + "&acid=" + acid + "&EmployeeId=" + EmployeeId + "&nTransactionLetterId=" + TransactionLetterId + "&nDisclosureTypeCodeId=" + DisclosureTypeCodeId + "&nLetterForCodeId=" + LetterForCodeId + "&nTransactionMasterId=" + TransactionMasterId;
                    ReturnString = ReturnString + "<a href='" + URL + "'> ( View )</a>";
                }
                return ReturnString;
            } else {
                return obj.aData['rpt_grd_19016'];
            }
        },
    },
    //Notification list 
    'GridType_114051': {
        'cmu_grd_18014': function (obj, type) {
            return dateTimeFormat(obj.aData['cmu_grd_18014']);
        },

        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
    },
    //Initial Disclosure Individual Employee Report
    'GridType_114052': {
        'rpt_grd_19038': function (obj, type) {
            if (obj.aData['rpt_grd_19038'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19038'])
            }
        },
    },
    //Period End Disclosure Employee Wise Report
    'GridType_114053': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'rpt_grd_19041': function (obj, type) {
            if (obj.aData['rpt_grd_19041'] != null) {
                return obj.aData['rpt_grd_19041'];
            } else {
                return '';
            }
        },
        'rpt_grd_19049': function (obj, type) {
            if (obj.aData['rpt_grd_19049'] != null) {
                return obj.aData['rpt_grd_19049'];
            } else {
                return '';
            }
        },
        'rpt_grd_19051': function (obj, type) {
            if (obj.aData['rpt_grd_19051'] != null) {
                return obj.aData['rpt_grd_19051'];
            } else {
                return '';
            }
        },
        'rpt_grd_19052': function (obj, type) {
            if (obj.aData['rpt_grd_19052'] != null) {
                return obj.aData['rpt_grd_19052'];
            } else {
                return '';
            }
        },
        'rpt_grd_19073': function (obj, type) {
            if (obj.aData['rpt_grd_19073'] != null) {
                return obj.aData['rpt_grd_19073'];
            } else {
                return '';
            }
        },
    },
    //Period End Disclosure Individual Employee Report
    'GridType_114054': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
    },
    //Claw Back Report
    'GridType_122098': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
    },

    //Claw Back Report- Individual 
    'GridType_122100': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
    },

    //Applicability search CO insider.
    'GridType_114055': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114055_usr_grd_11228');
        }
    },
    //Applicability search CO insider OS.
    'GridType_114143': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114143_usr_grd_11228');
        }
    },
    //Applicability association CO insider.
    'GridType_114056': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114056_usr_grd_11228');
        }
    },
    //Applicability association CO insider OS.
    'GridType_114144': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114144_usr_grd_11228');
        }
    },
    //Notification List for DashBoard.
    'GridType_114057': {
        'cmu_grd_18050': function (obj, type) {
            if (obj.aData['cmu_grd_18050'] != null) {
                return dateTimeFormat(obj.aData['cmu_grd_18050']);
            } else {
                return '';
            }
        },
    },
    //Period End Disclosure Individual Employee Details Report
    'GridType_114058': {
        'rpt_grd_19071': function (obj, type) {
            if (obj.aData['rpt_grd_19071'] != null) {
                return obj.aData['rpt_grd_19071'];
            } else {
                return '';
            }
        },
        'rpt_grd_19070': function (obj, type) {
            if (obj.aData['rpt_grd_19070'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19070'])
            }
        },
        'rpt_grd_19068': function (obj, type) {
            if (obj.aData['rpt_grd_19068'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19068'])
            }
        },
        'rpt_grd_19069': function (obj, type) {
            if (obj.aData['rpt_grd_19069'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19069'])
            }
        }
    },
    //Continuous Disclosure Employee Wise Report
    'GridType_114059': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        },
        'rpt_grd_19076': function (obj, type) {
            if (obj.aData['rpt_grd_19076'] != null) {
                return obj.aData['rpt_grd_19076'];
            } else {
                return '';
            }
        },
        'rpt_grd_19087': function (obj, type) {
            if (obj.aData['rpt_grd_19087'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19087'])
            }
        },
        'rpt_grd_19088': function (obj, type) {
            if (obj.aData['rpt_grd_19088'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19088'])
            }
        },
        'rpt_grd_19089': function (obj, type) {
            if (obj.aData['rpt_grd_19089'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19089'])
            }
        },
    },
    //Continuous Disclosure Individual Employee Report
    'GridType_114060': {
        'rpt_grd_19098': function (obj, type) {
            if (obj.aData['rpt_grd_19098'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19098'])
            }
        },
        'rpt_grd_19099': function (obj, type) {
            if (obj.aData['rpt_grd_19099'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19099'])
            }
        },
        'rpt_grd_19100': function (obj, type) {
            if (obj.aData['rpt_grd_19100'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19100'])
            }
        },
        'rpt_grd_19101': function (obj, type) {
            if (obj.aData['rpt_grd_19101'] != null) {
                return obj.aData['rpt_grd_19101']
            }
        },
        'rpt_grd_19102': function (obj, type) {
            if (obj.aData['rpt_grd_19102'] != null) {
                return obj.aData['rpt_grd_19102']
            }
        },
        'rpt_grd_19104': function (obj, type) {
            if (obj.aData['rpt_grd_19104'] != null) {
                return obj.aData['rpt_grd_19104']
            }
        },
        'rpt_grd_19106': function (obj, type) {
            if (!isEmptyOrPending(obj.aData['rpt_grd_19106'])) {
                var ReturnString = '';
                ReturnString = obj.aData['rpt_grd_19106'];
                if (!isEmptyOrPending(obj.aData['rpt_grd_19106'])) {
                    var acid = obj.aData['Acid'];
                    var TransactionLetterId = obj.aData['TransactionLetterId'];
                    var DisclosureTypeCodeId = obj.aData['DisclosureTypeCodeId'];
                    var LetterForCodeId = obj.aData['LetterForCodeId'];
                    var TransactionMasterId = obj.aData['TransactionMasterId'];
                    var URL = $("#SoftCopyLetterUrl").val() + "&acid=" + acid + "&nTransactionLetterId=" + TransactionLetterId + "&nDisclosureTypeCodeId=" + DisclosureTypeCodeId + "&nLetterForCodeId=" + LetterForCodeId + "&nTransactionMasterId=" + TransactionMasterId;
                    ReturnString = ReturnString + "<a href='" + URL + "'> ( View )</a>";
                }
                return ReturnString;
            } else {
                return obj.aData['rpt_grd_19106'];
            }
        },
        'rpt_grd_19107': function (obj, type) {
            if (!isEmptyOrPending(obj.aData['rpt_grd_19107'])) {
                var ReturnString = '';
                ReturnString = obj.aData['rpt_grd_19107'];
                if (!isEmptyOrPending(obj.aData['rpt_grd_19107'])) {
                    var acid = obj.aData['Acid'];
                    var TransactionLetterId = obj.aData['TransactionLetterId'];
                    var DisclosureTypeCodeId = obj.aData['DisclosureTypeCodeId'];
                    var LetterForCodeId = obj.aData['LetterForCodeId'];
                    var TransactionMasterId = obj.aData['TransactionMasterId'];
                    var URL = $("#HardCopyLetterUrl").val() + "&acid=" + acid + "&nTransactionLetterId=" + TransactionLetterId + "&nDisclosureTypeCodeId=" + DisclosureTypeCodeId + "&nLetterForCodeId=" + LetterForCodeId + "&nTransactionMasterId=" + TransactionMasterId;
                    ReturnString = ReturnString + "<a href='" + URL + "'> ( View )</a>";
                }
                return ReturnString;
            } else {
                return obj.aData['rpt_grd_19107'];
            }
        },
        'rpt_grd_19109': function (obj, type) {
            if (!isEmptyOrPending(obj.aData['rpt_grd_19109'])) {
                var ReturnString = '';
                ReturnString = obj.aData['rpt_grd_19109'];
                if (!isEmptyOrPending(obj.aData['rpt_grd_19109'])) {
                    var acid = obj.aData['Acid'];
                    var TransactionLetterId = obj.aData['TransactionLetterId'];
                    var DisclosureTypeCodeId = obj.aData['DisclosureTypeCodeId'];
                    var LetterForCodeId = obj.aData['LetterForCodeId'];
                    var TransactionMasterId = obj.aData['TransactionMasterId'];
                    var URL = $("#SoftCopyLetterUrl").val() + "&StockExchange=true&acid=" + acid + "&nTransactionLetterId=" + TransactionLetterId + "&nDisclosureTypeCodeId=" + DisclosureTypeCodeId + "&nLetterForCodeId=" + LetterForCodeId + "&nTransactionMasterId=" + TransactionMasterId;
                    ReturnString = ReturnString + "<a href='" + URL + "'> ( View )</a>";
                }
                return ReturnString;
            } else {
                return obj.aData['rpt_grd_19109'];
            }
        }
    },
    //Preclearence Employee wise
    'GridType_114061': {
        'rpt_grd_19193': function (obj, type) {
            if (obj.aData['rpt_grd_19193'] != null) {
                return obj.aData['rpt_grd_19193'];
            }
        },
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //Preclearence Employee individual
    'GridType_114062': {
        'rpt_grd_19207': function (obj, type) {
            if (obj.aData['rpt_grd_19207'] != null) {
                return obj.aData['rpt_grd_19207'];
            }
        },
        'rpt_grd_19215': function (obj, type) {
            if (obj.aData['rpt_grd_19215'] != null) {
                return obj.aData['rpt_grd_19215'];
            }
        },
        'rpt_grd_19216': function (obj, type) {
            if (obj.aData['rpt_grd_19216'] != null) {
                return obj.aData['rpt_grd_19216'];
            }
        },
        'rpt_grd_19220': function (obj, type) {
            if (obj.aData['rpt_grd_19220'] != null) {
                return obj.aData['rpt_grd_19220'];
            }
        },
        'rpt_grd_19212': function (obj, type) {
            if (obj.aData['rpt_grd_19212'] != null && obj.aData['rpt_grd_19212'] != "" && obj.aData['rpt_grd_19212'] != "-") {
                return formatIndianFloat(obj.aData['rpt_grd_19212']);
            }
        },
        'rpt_grd_19213': function (obj, type) {
            if (obj.aData['rpt_grd_19213'] != null && obj.aData['rpt_grd_19213'] != "" && obj.aData['rpt_grd_19213'] != "-") {
                return formatIndianFloat(obj.aData['rpt_grd_19213']);
            }
        },
        'rpt_grd_19218': function (obj, type) {
            if (obj.aData['rpt_grd_19218'] != null && obj.aData['rpt_grd_19218'] != "" && obj.aData['rpt_grd_19218'] != "-") {
                return formatIndianFloat(obj.aData['rpt_grd_19218']);
            }
        },
        'rpt_grd_19219': function (obj, type) {
            if (obj.aData['rpt_grd_19219'] != null && obj.aData['rpt_grd_19219'] != "" && obj.aData['rpt_grd_19219'] != "-") {
                return formatIndianFloat(obj.aData['rpt_grd_19219']);
            }
        },
        'rpt_grd_19221': function (obj, type) {
            if (obj.aData['rpt_grd_19221'] != null && obj.aData['rpt_grd_19221'] != "" && obj.aData['rpt_grd_19221'] != "-") {
                return formatIndianFloat(obj.aData['rpt_grd_19221']);
            }
        }
    },
    // GetEventsForMonthList
    'GridType_114063': {
        'rul_grd_15384': function (obj, type) {
            if (obj.aData['rul_grd_15384'] != null) {
                return dateTimeFormat(obj.aData['rul_grd_15384']);
            }
        },
        'rul_grd_15385': function (obj, type) {
            if (obj.aData['rul_grd_15385'] != null) {
                return dateTimeFormat(obj.aData['rul_grd_15385']);
            }
        }
    },
    // Userwise Overlap Trading Policy List
    'GridType_114064': {
        'rul_grd_15402': function (obj, type) {
            if (obj.aData['rul_grd_15402'] != null) {
                return dateTimeFormat(obj.aData['rul_grd_15402']);
            }
        },
        'rul_grd_15403': function (obj, type) {
            if (obj.aData['rul_grd_15403'] != null) {
                return dateTimeFormat(obj.aData['rul_grd_15403']);
            }
        }
    },
    // Userwise Overlap Trading Policy List for OS
    'GridType_114150': {
        'rul_grd_55378': function (obj, type) {
            if (obj.aData['rul_grd_55378'] != null) {
                return dateTimeFormat(obj.aData['rul_grd_55378']);
            }
        },
        'rul_grd_55379': function (obj, type) {
            if (obj.aData['rul_grd_55379'] != null) {
                return dateTimeFormat(obj.aData['rul_grd_55379']);
            }
        }
    },
    // CO Pre-clearance list
    'GridType_114076': {
        'dis_grd_17360': function (obj, type) {
            if (obj.aData['IsTotalRow'] != 0) {
                return "<label class='strong'>" + obj.aData['dis_grd_17360'] + "</label>";
            } else {
                //return obj.aData['dis_grd_17360'];

                var status = "";
                status = status + obj.aData['dis_grd_17360'];
                if (obj.aData['PreclearanceStatus'] == 144002 && obj.aData['IsPreclearanceFormForImplementingCompany'] == 1) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '&PreClearanceRequestId=' + obj.aData['PreClearanceRequestID'] + '&DisplayCode=' + obj.aData['dis_grd_17360'] + '"class="fa fa-download" title="Download Form E file">';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    }

                }
                return status;
            }
        },
        'dis_grd_17361': function (obj, type) {
            if (obj.aData['dis_grd_17361'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17361']);
            }
        },
        'dis_grd_17387': function (obj, type) {
            if (obj.aData['dis_grd_17387'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17387']);
            }
        },
        'dis_grd_17364': function (obj, type) {
            if (obj.aData['dis_grd_17364'] != null) {
                if (obj.aData['IsTotalRow'] != 0) {
                    return "<label class='strong'>" + formatIndianFloat(obj.aData['dis_grd_17364']) + "</label>";
                } else {
                    return formatIndianFloat(obj.aData['dis_grd_17364']);
                }
            }
        },
        'dis_grd_17365': function (obj, type) {
            if (obj.aData['dis_grd_17365'] != null) {
                //Link to per clearance page
                if (obj.aData['IsTotalRow'] != 0) {
                    return "<label class='strong'>" + formatIndianFloat(obj.aData['dis_grd_17365']) + "</label>";
                } else {
                    var val_return = '';

                    val_return += formatIndianFloat(obj.aData['dis_grd_17365']);

                    if (obj.aData['PreClearanceRequestID'] != null) {
                        val_return += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        val_return += '<a href="' + $('#perclearancelink').val() + '&PreclearanceRequestId=' + obj.aData['PreClearanceRequestID'] + '" class="display-icon icon icon-eye">';
                        val_return += '</a>';
                    }

                    return val_return;
                }
            }
        },
        'dis_grd_17366': function (obj, type) {
            if (obj.aData['dis_grd_17366'] != null) {
                if (obj.aData['IsTotalRow'] != 0) {
                    return "<label class='strong'>" + formatIndianNumber(obj.aData['dis_grd_17366']) + "</label>";
                } else {
                    return formatIndianNumber(obj.aData['dis_grd_17366']);
                }

            }
        },
        'dis_grd_17367': function (obj, type) {
            if (obj.aData['dis_grd_17367'] != null) {
                //Link to transaction page

                if (obj.aData['IsTotalRow'] != 0) {
                    return "<label class='strong'>" + formatIndianNumber(obj.aData['dis_grd_17367']) + "</label>";
                } else {
                    var val_return = '';

                    val_return += formatIndianNumber(obj.aData['dis_grd_17367']);

                    if (obj.aData['TransactionMasterID'] != null) {
                        val_return += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        val_return += '<a href="' + $('#transactiondetailslink').val() + '&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" class="display-icon icon icon-eye">';
                        val_return += '</a>';
                    }

                    return val_return;
                }
            }
        },
        'dis_grd_17368': function (obj, type) {
            if (obj.aData['PreclearanceStatus'] == 144001) {
                //Link to pre clearance page
                var val_return = '';

                val_return += '<a href="' + $('#Appoveperclearancelink').val() + '&PreclearanceRequestId=' + obj.aData['PreClearanceRequestID'] + '">';
                val_return += obj.aData['dis_grd_17368'];
                val_return += '</a>';

                return val_return;
            } else {
                return obj.aData['dis_grd_17368']
            }
        },
    },
    // Insider Pre-clearance list
    'GridType_114077': {
        'dis_grd_17369': function (obj, type) {
            if (obj.aData['IsTotalRow'] != 0) {
                return "<label class='strong'>" + obj.aData['dis_grd_17369'] + "</label>";


            } else {
                // return obj.aData['dis_grd_17369'];
                var status = "";
                status = status + obj.aData['dis_grd_17369'];
                if (obj.aData['PreclearanceStatus'] == 144002 && obj.aData['IsPreclearanceFormForImplementingCompany'] == 1) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '&PreClearanceRequestId=' + obj.aData['PreClearanceRequestID'] + '&DisplayCode=' + obj.aData['dis_grd_17369'] + '"class="fa fa-download" title="Download Form E file">';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    }

                }
                return status;
            }
        },
        'dis_grd_17370': function (obj, type) {
            if (obj.aData['dis_grd_17370'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17370']);
            }
        },
        'dis_grd_17388': function (obj, type) {
            if (obj.aData['dis_grd_17388'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_17388']);
            }
        },
        'dis_grd_17373': function (obj, type) {
            if (obj.aData['dis_grd_17373'] != null) {
                if (obj.aData['IsTotalRow'] != 0) {
                    return "<label class='strong'>" + formatIndianFloat(obj.aData['dis_grd_17373']) + "</label>";
                } else {
                    return formatIndianFloat(obj.aData['dis_grd_17373']);
                }
            }
        },
        'dis_grd_17374': function (obj, type) {
            if (obj.aData['dis_grd_17374'] != null) {
                //Link to per clearance page
                if (obj.aData['IsTotalRow'] != 0) {
                    return "<label class='strong'>" + formatIndianFloat(obj.aData['dis_grd_17374']) + "</label>";
                } else {
                    var val_return = '';

                    val_return += formatIndianFloat(obj.aData['dis_grd_17374']);

                    if (obj.aData['PreClearanceRequestID'] != null) {
                        val_return += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        val_return += '<a href="' + $('#perclearancelink').val() + '&PreclearanceRequestId=' + obj.aData['PreClearanceRequestID'] + '" class="display-icon icon icon-eye">';
                        val_return += '</a>';
                    }

                    return val_return;
                }
            }
        },
        'dis_grd_17375': function (obj, type) {
            if (obj.aData['dis_grd_17375'] != null) {
                if (obj.aData['IsTotalRow'] != 0) {
                    return "<label class='strong'>" + formatIndianNumber(obj.aData['dis_grd_17375']) + "</label>";
                } else {
                    return formatIndianNumber(obj.aData['dis_grd_17375']);
                }
            }
        },
        'dis_grd_17376': function (obj, type) {
            if (obj.aData['dis_grd_17376'] != null) {
                //Link to transaction page
                if (obj.aData['IsTotalRow'] != 0) {
                    return "<label class='strong'>" + formatIndianNumber(obj.aData['dis_grd_17376']) + "</label>";
                } else {
                    var val_return = '';

                    val_return += formatIndianNumber(obj.aData['dis_grd_17376']);

                    if (obj.aData['TransactionMasterID'] != null) {
                        val_return += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        val_return += '<a href="' + $('#transactiondetailslink').val() + '&TransactionMasterId=' + obj.aData['TransactionMasterID'] + '" class="display-icon icon icon-eye">';
                        val_return += '</a>';
                    }

                    return val_return;
                }
            }
        },
    },
    // Defaulter List
    'GridType_114078': {
        'rpt_grd_19272': function (obj, type) {
            var status = '';
            if (obj.aData['ISRemoveFromList'] == 1) {
                status = '<i class="glyphicon glyphicon-record" style="background-color: Orange;font-size:20px;"></i>';
            } else {
                status = '';
            }
            return status;
        },
        'rpt_grd_19275': function (obj, type) {
            if (obj.aData['rpt_grd_19275'] != null) {
                return obj.aData['rpt_grd_19275'];
            }
        },
        'rpt_grd_19287': function (obj, type) {
            if (obj.aData['rpt_grd_19287'] != null) {
                return obj.aData['rpt_grd_19287'];
            }
        },
        'rpt_grd_19291': function (obj, type) {
            if (obj.aData['rpt_grd_19291'] != null) {
                return obj.aData['rpt_grd_19291'];
            }
        },
        'rpt_grd_19292': function (obj, type) {
            if (obj.aData['rpt_grd_19292'] != null) {
                return obj.aData['rpt_grd_19292'];
            }
        },
        'rpt_grd_19298': function (obj, type) {
            if (obj.aData['rpt_grd_19298'] != null) {
                return formatIndianNumber(obj.aData['rpt_grd_19298']);
            }
        },
        'rpt_grd_19299': function (obj, type) {
            if (obj.aData['rpt_grd_19299'] != null) {
                return formatIndianNumber(obj.aData['rpt_grd_19299']);
            }
        },
        'rpt_grd_19300': function (obj, type) {
            if (obj.aData['rpt_grd_19300'] != null) {
                return formatIndianNumber(obj.aData['rpt_grd_19300']);
            }
        },
        'rpt_grd_19301': function (obj, type) {
            if (obj.aData['rpt_grd_19301'] != null) {
                return formatIndianNumber(obj.aData['rpt_grd_19301']);
            }
        },
        'rpt_grd_19302': function (obj, type) {
            if (obj.aData['rpt_grd_19302'] != null) {
                return obj.aData['rpt_grd_19302'];
            }
        },
        'rpt_grd_19303': function (obj, type) {
            if (obj.aData['rpt_grd_19303'] != null) {
                return obj.aData['rpt_grd_19303'];
            }
        },
        'rpt_grd_19305': function (obj, type) {
            if (obj.aData['rpt_grd_19305'] != null) {
                return obj.aData['rpt_grd_19305'];
            }
        },
        'rpt_grd_19307': function (obj, type) {
            if (obj.aData['rpt_grd_19307'] != null) {
                return (obj.aData['rpt_grd_19307']);
            }
        },
        'rpt_grd_19308': function (obj, type) {
            if (obj.aData['rpt_grd_19308'] != null) {
                return obj.aData['rpt_grd_19308'];
            }
        },
        'rpt_grd_19310': function (obj, type) {
            if (obj.aData['rpt_grd_19310'] != null) {
                return obj.aData['rpt_grd_19310'];
            }
        },
        'rpt_grd_19312': function (obj, type) {
            if (obj.aData['PreclearanceBlankComment'] == '1') {
                return '';
            } else {
                return createActionControlArray(obj, objThis.GridType + '_rpt_grd_19312');
            }
        },
        'rpt_grd_19304': function (obj, type) {
            var str = "";
            if (obj.aData['rpt_grd_19304'] == 1) {
                str = '<input type="checkbox" checked="checked" disabled = "disabled"/>'
            } else {
                str = ''
            }
            return str;
        }
    },

    'GridType_114079': {
        'usr_grd_50009': function (obj, type) {
            if (obj.aData['usr_grd_50009'] != null) {
                return dateTimeFormat(obj.aData['usr_grd_50009']);
            }
        },
        'usr_grd_50010': function (obj, type) {
            if (obj.aData['usr_grd_50010'] != null) {
                return dateTimeFormat(obj.aData['usr_grd_50010']);
            }
        },
        'usr_grd_11073': function (obj, type) {
            var currentDate = new Date();
            var newDate = new Date(obj.aData['usr_grd_50010']);
            if (newDate < currentDate) {
                return createActionControlArray_For_RestrictedList(obj, objThis.GridType + '_usr_grd_11073');

            }
            else {
                return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
            }
        }
    },

    //Initial Disclosure Letter , Form B list Grid 2
    'GridType_114080': {
        'dis_grd_17139': function (obj, type) {
            if (obj.aData['dis_grd_17139'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17139'])
            }
        },
        'dis_grd_17140': function (obj, type) {
            if (obj.aData['dis_grd_17140'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17140'])
            }
        },
        'dis_grd_17142': function (obj, type) {
            if (obj.aData['dis_grd_17142'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17142'])
            }
        },
        'dis_grd_17143': function (obj, type) {
            if (obj.aData['dis_grd_17143'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17143'])
            }
        }

    },
    //Continus Disclosure Letter, Form C list Grid 2
    'GridType_114081': {
        'dis_grd_17206': function (obj, type) {
            if (obj.aData['dis_grd_17206'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17206'])
            }
        },
        'dis_grd_17207': function (obj, type) {
            if (obj.aData['dis_grd_17207'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17207'])
            }
        },
        'dis_grd_17417': function (obj, type) {
            if (obj.aData['dis_grd_17417'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17417'])
            }
        },
        'dis_grd_17418': function (obj, type) {
            if (obj.aData['dis_grd_17418'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17418'])
            }
        }
    },
    //Continus Disclosure Letter, Form D list Grid 2
    'GridType_114082': {
        'dis_grd_17228': function (obj, type) {
            if (obj.aData['dis_grd_17228'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17228'])
            }
        },
        'dis_grd_17229': function (obj, type) {
            if (obj.aData['dis_grd_17229'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17229'])
            }
        },
        'dis_grd_17421': function (obj, type) {
            if (obj.aData['dis_grd_17421'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17421'])
            }
        },
        'dis_grd_17422': function (obj, type) {
            if (obj.aData['dis_grd_17422'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_17422'])
            }
        }
    },
    //policy docuement applicablity list for employee
    'GridType_114092': {
        'tra_grd_16441': function (obj, type) {
            var val_return = 'NA';
            if (obj.aData['DocumentViewFlag']) {
                val_return = (obj.aData['DocumentViewedDate'] != null) ? dateTimeFormat(obj.aData['DocumentViewedDate']) : 'Pending';
            }
            return val_return;
        },
        'tra_grd_16442': function (obj, type) {
            var val_return = 'NA';
            if (obj.aData['DocumentViewAgreeFlag']) {
                val_return = (obj.aData['DocumentAgreedDate'] != null) ? dateTimeFormat(obj.aData['DocumentAgreedDate']) : 'Pending';
            }
            return val_return;
        }
    },
    //Applicability employee .
    'GridType_114089': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114089_usr_grd_11228');
        }
    },
    //Applicability employee OS .
    'GridType_114145': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114145_usr_grd_11228');
        }
    },
    //Applicability filter employee .
    'GridType_114090': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114090_usr_grd_11228');
        }
    },
    //Applicability filter employee OS .
    'GridType_114146': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114146_usr_grd_11228');
        }
    },
    //Applicability employee non insider.
    'GridType_114091': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114091_usr_grd_11228');
        }
    },

    //Applicability employee non insider OS.
    'GridType_114147': {
        'usr_grd_11228': function (obj, type) {
            return createActionControlArray(obj, '114147_usr_grd_11228');
        }
    },
    //Trading Transaction Uploaded Document List.
    'GridType_114093': {
        'usr_grd_11073': function (obj, type) {
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    'GridType_114094': {

        'dis_grd_17485': function (obj, type) {
            if (obj.aData['DisplaySequenceNo'] != null && obj.aData['DisplaySequenceNo'] > 0) {
                var status = "";
                //status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['DisplaySequenceNo'] + '" firstButton="firstButton" style="color:blue;">';
                //status = status + obj.aData['dis_grd_17485'];
                //status = status + '</a>';
                status = obj.aData['dis_grd_17485'];
                if (obj.aData["dis_grd_17485"] != "" && obj.aData['PreclearanceStatusCodeId'] == 144002) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=216&PreClearanceRequestId=' + obj.aData['DisplaySequenceNo'] + '&DisplayCode=' + obj.aData['dis_grd_17485'] + '" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    }

                }
                return status;
                // return createActionControlArray(obj, '114038_dis_grd_17014');
            } else {
                return obj.aData['dis_grd_17485'];
            }
        },
        'dis_grd_17488': function (obj, type) {
            var status = '';
            switch (obj.aData['PreclearanceStatusCodeId']) {
                case 144001:
                    status = '<a href="#" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['dis_grd_17488'];
                    status = status + '</button></p> </a>';
                    break;
                case 144002:
                    status = '<a href="#" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    status = status + obj.aData['dis_grd_17488'];
                    status = status + '</button></p> </a>';

                    break;
                case 144003:
                    //status = '<a href="' + $('#RejectionView').val() + '?CalledFrom=Insider&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreClearanceRequestId=' + obj.aData['PreClearanceRequestID'] + '" firstButton="firstButton" >';
                    //status = status + '<p class="text-center status-red">';
                    //status = status + '<button type="submit" class="btn btn-danger btn-shape btn-arrow btn-md"><i class="ico ico-times"></i> ';
                    //status = status + obj.aData['dis_grd_17488'];
                    //status = status + '</button></p> </a>';

                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17491': function (obj, type) {
            if (obj.aData['dis_grd_17491'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17491'])
            }
        }
    },
    'GridType_114095': {
        'dis_grd_17516': function (obj, type) {
            if (obj.aData['DisplaySequenceNo'] != null && obj.aData['DisplaySequenceNo'] > 0) {
                var status = "";
                //status = '<a href="' + $('#View').val() + '&pclid=' + obj.aData['DisplaySequenceNo'] + '" firstButton="firstButton" style="color:blue;">';
                //status = status + obj.aData['dis_grd_17516'];
                //status = status + '</a>';
                status = obj.aData['dis_grd_17516'];
                if (obj.aData["dis_grd_17516"] != "" && obj.aData['PreclearanceStatusCodeId'] == 144002) {
                    if (obj.aData['IsFORMEGenrated'] == "1") {
                        status = status + '&nbsp;<a href= "' + $('#DownloadFormE').val() + '?acid=217&PreClearanceRequestId=' + obj.aData['DisplaySequenceNo'] + '&DisplayCode=' + obj.aData['dis_grd_17516'] + '" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    } else {
                        status = status + '&nbsp;<a href= "#" onclick="showerrormessage(this);" errormessage="FORM E not generated" class="fa fa-download downloadforme" title="Download Form E file" >';
                        status = status + '</a>';
                    }

                }
                return status;
                // return createActionControlArray(obj, '114038_dis_grd_17014');
            } else {
                return obj.aData['dis_grd_17516'];
            }
        },
        'dis_grd_17518': function (obj, type) {
            var status = '';
            switch (obj.aData['PreclearanceStatusCodeId']) {
                case 144001:
                    //status = '<a href="' + $('#View').val() + 'pclid=' + obj.aData['DisplaySequenceNo'] + '" firstButton="firstButton" >';
                    status = '<a href="#" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-orange">';
                    status = status + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                    status = status + obj.aData['dis_grd_17518'];
                    status = status + '</button></p> </a>';
                    break;
                case 144002:
                    status = '<a href="#" firstButton="firstButton" >';
                    status = status + '<p class="text-center status-green">';
                    status = status + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    status = status + obj.aData['dis_grd_17518'];
                    status = status + '</button></p> </a>';

                    break;
                case 144003:
                    //status = '<a href="' + $('#RejectionView').val() + '?CalledFrom=Insider&acid=' + $("#PreclearaceRequestCOUserAction").val() + '&PreClearanceRequestId=' + obj.aData['PreClearanceRequestID'] + '" firstButton="firstButton" >';
                    //status = status + '<p class="text-center status-red">';
                    //status = status + '<button type="submit" class="btn btn-danger btn-shape btn-arrow btn-md"><i class="ico ico-times"></i> ';
                    //status = status + obj.aData['dis_grd_17518'];
                    //status = status + '</button></p> </a>';

                    break;
                default:
                    status = '';
                    break;
            }
            return status;
        },
        'dis_grd_17521': function (obj, type) {
            if (obj.aData['dis_grd_17521'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_17521'])
            }
        }
    },
    //Restricted List search report - CO
    'GridType_114096': {
        //'rl_grd_50310': function (obj, type) {
        //    if (obj.aData['rl_grd_50310'] != null) {
        //        return dateTimeFormat(obj.aData['rl_grd_50310'])
        //    }
        //},
        //'rl_grd_50314': function (obj, type) {
        //    if (obj.aData['rl_grd_50314'] != null) {
        //        return dateTimeFormat(obj.aData['rl_grd_50314'])
        //    }
        //},
        'rl_grd_50317': function (obj, type) {
            if (obj.aData['rl_grd_50317'] != null) {
                return formatIndianFloat(obj.aData['rl_grd_50317'])
            }
        },
        'rl_grd_50318': function (obj, type) {
            if (obj.aData['rl_grd_50318'] != null) {
                return formatIndianFloat(obj.aData['rl_grd_50318'])
            }
        },
        //'rl_grd_50320': function (obj, type) {
        //    if (obj.aData['rl_grd_50320'] != null) {
        //        return dateTimeFormat(obj.aData['rl_grd_50320'])
        //    }
        //},
    },
    'GridType_114098': {
        'usr_grd_11482': function (obj, type) {
            if (obj.aData['usr_grd_11482'] != null) {
                return formatIndianFloat(obj.aData['usr_grd_11482'])
            }
        },
    },
    'GridType_114099': {
        'rpt_grd_19337': function (obj, type) {
            if (obj.aData['rpt_grd_19337'] != null) {
                return dateTimeFormat(obj.aData['rpt_grd_19337']);
            }
        },
        'rpt_grd_19338': function (obj, type) {
            if (obj.aData['rpt_grd_19338'] != null) {
                return formatIndianFloat(obj.aData['rpt_grd_19338'])
            }
        },
    },

    //Period End disclosure for letter for employee insider grid 1
    'GridType_507004': {
        'dis_grd_50442': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_50442'] != null && obj.aData['dis_grd_50442'] != '') {
                str = obj.aData['dis_grd_50442'].split('##');
                return str[0] + ', ' + str[1] + ', ' + str[2] + ', ' + str[3] + ', ' + str[4]
            }
            else {
                return '';
            }
        },
        'dis_grd_50388': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_50388'] == '')
                return '-';
            if (obj.aData['dis_grd_50388'] != "Self") {
                str = obj.aData['dis_grd_50388'].split('##');
                return str[0];
            }
            else {
                return obj.aData['dis_grd_50388']
            }
        },
        'dis_grd_50391': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_50391'] != null && obj.aData['dis_grd_50391'] != "-") {
                if (obj.aData['dis_grd_50391'] != 0) {
                    str = obj.aData['dis_grd_50391'].split('##');
                    if (str[1] == 'NA') {
                        return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ')';
                    } else {
                        return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ' %)';
                    }
                }
                else {
                    return formatIndianFloat(obj.aData['dis_grd_50391']);
                }
                //return formatIndianFloat(obj.aData['dis_grd_50391'])
            }
            return obj.aData['dis_grd_50391'];
        },
        'dis_grd_50393': function (obj, type) {
            if (obj.aData['dis_grd_50393'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_50393'])
            }
        },
        'dis_grd_50394': function (obj, type) {
            if (obj.aData['dis_grd_50394'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_50394'])
            }
        },
        'dis_grd_50397': function (obj, type) {
            var str = '';
            if (obj.aData['dis_grd_50397'] != null && obj.aData['dis_grd_50397'] != "-") {
                if (obj.aData['dis_grd_50397'] != 0) {
                    str = obj.aData['dis_grd_50397'].split('##');
                    if (str[1] == 'NA') {
                        return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ')';
                    } else {
                        return formatIndianFloat(str[0]) + '<br/> (' + str[1] + ' %)';
                    }
                }
                else {
                    return formatIndianFloat(obj.aData['dis_grd_50397']);
                }
                //return formatIndianFloat(obj.aData['dis_grd_50397'])
            }
            return obj.aData['dis_grd_50397'];
        },
        'dis_grd_50398': function (obj, type) {
            if (obj.aData['dis_grd_50398'] != null) {
                return dateTimeFormat(obj.aData['dis_grd_50398'])
            } else {
                return "-";
            }
        },
        'dis_grd_50399': function (obj, type) {
            if (obj.aData['dis_grd_50399'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_50399'])
            }
        },
        'dis_grd_50400': function (obj, type) {
            if (obj.aData['dis_grd_50400'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_50400'])
            }
        },
        'dis_grd_50401': function (obj, type) {
            if (obj.aData['dis_grd_50401'] != null) {
                return formatIndianNumber(obj.aData['dis_grd_50401'])
            }
        },
    },

    //Period End disclosure for letter for employee insider grid 2
    'GridType_507003': {
        'dis_grd_50403': function (obj, type) {
            if (obj.aData['dis_grd_50403'] == null) {
                return '-';
            }
            else {
                return obj.aData['dis_grd_50403'];
            }
        },
        'dis_grd_50404': function (obj, type) {
            if (obj.aData['dis_grd_50404'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_50404'])
            }
            else {
                return '-';
            }
        },
        'dis_grd_50406': function (obj, type) {
            if (obj.aData['dis_grd_50406'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_50406'])
            }
            else {
                return '-';
            }
        },
        'dis_grd_50422': function (obj, type) {
            if (obj.aData['dis_grd_50422'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_50422'])
            }
            else {
                return '-';
            }
        },
        'dis_grd_50408': function (obj, type) {
            if (obj.aData['dis_grd_50408'] != null) {
                return formatIndianFloat(obj.aData['dis_grd_50408'])
            }
            else {
                return '-';
            }
        }
    },
    //EducationList
    'GridType_114115': {

        'usr_grd_11073': function (obj, type, row) {
            if (obj.aData['UEW_id'] != '') {
                $("#btnUserDontDetails").hide();
                $("#ConfirmEductionDetails").show();
            }
            else {
                $("#btnUserDontDetails").show();
                $("#ConfirmEductionDetails").hide();
            }
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    //WorkList
    'GridType_114116': {

        'usr_grd_11073': function (obj, type, row) {
            if (obj.aData['UEW_id'] != '') {
                $("#btnUserDontDetails").hide();
                $("#ConfirmEductionDetails").show();
            }
            else {
                $("#btnUserDontDetails").show();
                $("#ConfirmEductionDetails").hide();
            }
            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    'GridType_114124': {

        'usr_grd_11073': function (obj, type, row) {

            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
    'GridType_114125': {
        'rpt_grd_53113': function (obj, type, row) {
            if (obj.aData['rpt_grd_53113'] != null) {
                return dateTimeFormat_WithTime(obj.aData['rpt_grd_53113'])
            } else {
                return "-";
            }
        }
    },
    //Insider - Period End Disclosure - Period Status List for Insider OTHER SECURITY
    'GridType_114126': {
        'dis_grd_53123': function (obj, type) {
            return dateTimeFormat(obj.aData['dis_grd_53123'])
        },
        'dis_grd_53124': function (obj, type) { //status column
            var val_return = '';
            if (obj.aData['SubmissionStatusCodeId'] == 154006) {
                val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + '" firstButton="firstButton" >';
                val_return = val_return + '<p class="text-center status-orange">';
                val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-note"></i> ';
                val_return = val_return + obj.aData['SubmissionButtonText'];
                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_53124'] == null) {
                    if (obj.aData['SubmissionButtonText'] != null) {
                        val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + '" firstButton="firstButton" >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['SubmissionButtonText'];
                        val_return = val_return + '</button></p> </a>';
                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p style="font-size:12px;margin:0px 0px 0px 48px">';
                            val_return += '<span class="days-count" style="float: left;margin-top: -3px;">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span style="display:inline-block">Working Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#summarylink').val() + '&period=' + obj.aData['PeriodCodeId'] + '&year=' + obj.aData['YearCodeId'] + '&pdtype=' + obj.aData['PeriodTypeId'] + (obj.aData['TransactionMasterId'] != null ? '&tmid=' + obj.aData['TransactionMasterId'] : '') + ' " firstButton="firstButton" >';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_53124']);
                    if (obj.aData['IsUploadAndEnterEventGenerate'] == "1") {
                        val_return = val_return + '&nbsp;&nbsp;<i class="ico ico-document"></i>';
                    }
                    val_return = val_return + '</button></p> </a>';
                }
            }
            return val_return;
        },
        'dis_grd_53125': function (obj, type) { //softcopy submit column
            var val_return = '';
            if (obj.aData['ScpStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['ScpButtonText'];
                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_53125'] == null || obj.aData['dis_grd_53125'] == "") {
                    if (obj.aData['ScpButtonText'] != null) {
                        val_return = (obj.aData['IsCurrentPeriodEnd'] == 1) ? '<a href="' + $('#softcopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '&period=' + obj.aData['PeriodCodeId'] + '&pdtypeId=' + obj.aData['PeriodTypeId'] + '&pdtype=' + obj.aData['PeriodType'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['ScpButtonText'];
                        val_return = val_return + '</button></p> </a>';
                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p style="font-size:12px;margin:0px 0px 0px 48px">';
                            val_return += '<span class="days-count" style="float: left;margin-top: -3px;">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span style="display:inline-block">Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#softcopyviewlink').val() + '&tmid=' + obj.aData['TransactionMasterId'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_53125']);
                    val_return = val_return + '</button></p> </a>';

                }
            }

            return val_return;
        },
        'dis_grd_53126': function (obj, type) { //hardcopy submit column
            var val_return = '';
            if (obj.aData['HcpStatusCodeId'] == 154007) { //not required status
                val_return = '<a >';
                val_return = val_return + '<p class="text-center status-gray">';
                val_return = val_return + '<button type="submit" class="btn btn-gray btn-shape btn-round btn-md center-block"><i class="ico ico-barred"></i> ';
                val_return = val_return + obj.aData['HcpButtonText'];
                val_return = val_return + '</button></p> </a>';
            } else {
                if (obj.aData['dis_grd_53126'] == null) {
                    if (obj.aData['HcpButtonText'] != null) {
                        val_return = (obj.aData['IsCurrentPeriodEnd'] == 1) ? '<a href="' + $('#hardcopylink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '">' : '<a >';
                        val_return = val_return + '<p class="text-center status-orange">';
                        val_return = val_return + '<button type="submit" class="btn btn-warning btn-shape btn-round btn-md center-block"><i class="ico ico-exc"></i> ';
                        val_return = val_return + obj.aData['HcpButtonText'];
                        val_return = val_return + '</button></p> </a>';
                        if (obj.aData['SubmissionDaysRemaining'] > -1) {
                            val_return += '<p style="font-size:12px;margin:0px 0px 0px 48px">';
                            val_return += '<span class="days-count" style="float: left;margin-top: -3px;">' + obj.aData['SubmissionDaysRemaining'] + '</span>';
                            val_return += '<span style="display:inline-block">Days Left</span>';
                            val_return += '</p>';
                        }
                    }
                } else {
                    val_return = '<a href="' + $('#hardcopyviewlink').val() + '&nTransactionMasterId=' + obj.aData['TransactionMasterId'] + '&year=' + obj.aData['YearCodeId'] + '">';
                    val_return = val_return + '<p class="text-center status-green">';
                    val_return = val_return + '<button type="submit" class="btn btn-success btn-shape btn-arrow  btn-md center-block"><i class="ico ico-check"></i> ';
                    val_return = val_return + dateTimeFormat(obj.aData['dis_grd_53126']);
                    val_return = val_return + '</button></p> </a>';
                }
            }

            return val_return;
        },
    },
    'GridType_114127': {

        'usr_grd_11073': function (obj, type, row) {

            return createActionControlArray(obj, objThis.GridType + '_usr_grd_11073');
        }
    },
}



//Common function for column formatting
function fetchSearch(element, GridType) {

    var arrList = [];
    // This is to specifies for array size 50 Element as used in populate grid db procedure.
    arrList[50] = "";
    $.each((element.parents('.search[gridtype=' + GridType + ']').find("input,select[GridType=" + GridType + "]").toArray().sort(function (a, b) { return a.id - b.id; })), function () {
        if ($(this).hasClass("Checkbox")) {
            if ($(this).is(":checked")) {
                arrList[parseInt($(this).attr("id")) - 1] = 1;
            }
            else {
                arrList[parseInt($(this).attr("id")) - 1] = 0;
            }
        }
        else {
            var data = "";
            //Code to check if dropdown is multiple select one so, the value will be array if it is multi select dropdown.
            if ($(this).val() instanceof Array)
                data = $(this).val().join(',');
            else
                //Check if date field and convert the date format from dd/mm/yyyy to yyyy/mm/dd
                //if ($(this).parents('div.date').length > 0) {
                //    val = $(this).val();
                //    arr_data = val.split('/');
                //    if (arr_data.length > 2)
                //        data = arr_data[2] + '/' + arr_data[1] + '/' + arr_data[0];
                //}
                //else
                data = $(this).val();
            arrList[parseInt($(this).attr("id")) - 1] = data;
        }
    });
    return arrList;
}

function link(link, display) {
    // alert(trim(link));
    if (link.trim().length >= 1 && trim().link.indexOf("undefined") < 0) {
        return '<a href=' + link + '>' + display + '</a>';
    }
    return "";
}

function GenerateComponent(components) {
    sComponentBuilder = "";
    $.each(components, function (index, component) {
        //  alert(component.url);
        if (component.url != undefined && component.url != null && $.trim(component.url).length >= 1 && $.trim(component.url).indexOf("undefined") == -1) {
            if (component.type == LINK) {
                sComponentBuilder += $('<a>', component.param)[0].outerHTML + '&nbsp;&nbsp;';
            }
            else if (component.type == CHECKBOX) {
                sComponentBuilder += $('<input>', component.param)[0].outerHTML + '&nbsp;&nbsp;';
            }
            else if (component.type == DROPDOWN) {

                var shtml = $('#' + component.param['id']).clone();
                shtml.find("option[value = '" + component.param['value'] + "']").attr("selected", "selected");
                shtml.find("option[optionattribute][optionattribute!='" + component.param['CModeValue'] + "']").remove();
                shtml = shtml.html();
                component.param['id'] = "";
                var dropdownElement = $('<select>', component.param).append(shtml);
                sComponentBuilder += dropdownElement[0].outerHTML + '&nbsp;&nbsp;';
            }
        }
    });
    return sComponentBuilder;
}

function UserStatus(status) {
    color = 'red';
    if (status != undefined && status.trim() == 'Active')
        color = 'green';

    return "<div style='color:" + color + "; text-decoration: underline;'>" + status + "</div>";
}

function SetBoolean(value) {
    if (value == 1)
        return "Yes";
    else
        return "No";
}

function deleteAjax(displayText, key, value) {
    return '<a href="javascript:void(0);" name="deleteRow" ID="' + value + '" key="' + key + '" >' + displayText + '</input>'
}

function dateTimeFormat(i_dDateTime) {
    var re = /-?\d+/;
    var datetime = i_dDateTime;
    if (i_dDateTime != null && i_dDateTime != "" && i_dDateTime != "-") {
        var m = re.exec(i_dDateTime);
        var d = new Date(parseInt(m[0]));
        var month = ("0" + (d.getMonth() + 1)).slice(-2);
        var months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        datetime = ("0" + d.getDate()).slice(-2) + "/" + months[month - 1] + "/" + d.getFullYear();
    }
    return datetime;
}

function dateTimeFormat_WithTime(i_dDateTime) {
    var re = /-?\d+/;
    var datetime = i_dDateTime;
    if (i_dDateTime != null && i_dDateTime != "" && i_dDateTime != "-") {
        var m = re.exec(i_dDateTime);
        var d = new Date(parseInt(m[0]));
        var month = ("0" + (d.getMonth() + 1)).slice(-2);
        var months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        datetime = ("0" + d.getDate()).slice(-2) + "/" + months[month - 1] + "/" + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
    }
    return datetime;
}

function isIE() {
    var myNav = navigator.userAgent.toLowerCase();
    return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
}

function isEmptyOrPending(sInValue) {
    if (sInValue == null || sInValue == "" || sInValue == "Pending" || sInValue == "Not Required")
        return true;
    else
        return false;
}

function showerrormessage(obj) {
    //  alert($(obj).attr("errormessage"));
    showMessage($(obj).attr("errormessage"), false);
    return false;
}

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, '');
}

function createActionControlArray_For_RestrictedList(obj, gridcolumntype) {
    var data = [];

    $("input[type='hidden'].gridtypecontrol[gridcolumntype='" + gridcolumntype + "']").each(function () {

        var url = $(this).val();
        var strParams = $(this).attr("param");
        var type = $(this).attr("ctrtype");
        var arrProperties = strParams.match(/<([^>]+)>/g);
        $(arrProperties).each(function () {
            var columnsName = this.replace('<', '');
            columnsName = columnsName.replace('>', '');
            strParams = strParams.replace(this, ("" + obj.aData[columnsName]).replace(/'/g, '&#39;'));
            strParams = strParams.replace("btnEditTradingPolicy", "hideEditBtn")
        });

        var parameters = '{ param:' + strParams + '}';
        data.push(
            {
                url: url,
                type: type,
                param: eval('(' + parameters + ')').param
            }
        );
    });
    return GenerateComponent(data);
}

function onlyNumbers(evt) {
    var e = event || evt;
    var charCode = e.which || e.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

