$(document).ready(function () {

    var dataTable = null;
    /// Save for User Document----------------------------------------------------------
    $(document).delegate("#btnSaveDocumentDetails", "click", function () {
        var gridTableName = "DatatableGrid";
        var dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        if ($("table[name='DatatableGrid_userdoc'][gridtype='" + $(this).attr("gridtype") + "']").length > 0) {
            dataTable = $("table[name='DatatableGrid_userdoc'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        }
        if ($("#frmDocumentDetails").valid()) {
            var data = {};
            data['nMapToTypeCodeId'] = $("[name='[0].Value[0].MapToTypeCodeId']").val();
            data['nMapToId'] = $("[name='[0].Value[0].MapToId']").val();
            data['sDocName'] = $("#DocName").val();
            data['sDocDescription'] = $("#DocDescription").val();
            data['acid'] = $('#file_acid').val();
            data['GUID'] = $("[name='[0].Value[0].GUID']").val();
            data['nDocumentDetailsID'] = $("[name='[0].Value[0].DocumentId']").val();
            $.ajax({
                url: $("#SaveDocument").val(),
                type: "POST",
                headers: getRVToken(),
                dataType: 'json',
                data: data,
                success: function (data) {
                    if (data.status) {
                        $('#DocumentModal').modal('hide');
                        $("#divDocumentDetailsModal").hide();
                        dataTable.fnDraw();
                    }
                    else {
                        $('div[name=ErrorMessageDocument]').addClass('alert-danger').fadeIn('slow');
                        $('div[name=ErrorMessageDocument]').html(data.Message['Document']);
                        showMessage(data.Message['Document'], true);
                        setTimeout(function () {
                            $('div[name=ErrorMessageDocument]').removeClass('alert-danger').fadeOut('slow');
                            $('div[name=ErrorMessageDocument]').html("");
                        }, 20000);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $("#simple-msg").html('<pre>"fail"</pre>');
                }
            });
        }
    });

    $(document).delegate('.document', 'click', function (e) {
        $this = $(this);
        $(this).fileupload({
            dataType: 'json',
            autoUpload: false,
            replaceFileInput: false,
            maxNumberOfFiles: 1,
            //maxFileSize: 52428800, //50MB           
            url: $("#UploadDocument").val(),
            add: function (e, data) {

                var acceptFileTypes = /^(pdf|xls|xlsx|doc|docx|png|jpg|jpeg)$/i;
                var filename = $($this).closest(".clsParentFileUpload").find("input[type='file']").val();
                var extension = filename.replace(/^.*\./, '');
                if (!acceptFileTypes.test(extension)) {
                    showMessage('Only following file types can be uploaded: pdf,xls,xlsx,doc,docx,png,jpg,jpeg', false);
                    return false;
                } 
                var FileNameSize = 5;
                var Filesize = 1024;

                var FileNameWithExtension = data.files[0]["name"];
                var OnlyFileName = FileNameWithExtension.substr(0, FileNameWithExtension.lastIndexOf('.'));               

                var specialchar = OnlyFileName.match(/[`!@#$%^&*+\-=\[\]{};':"\\|,<>\/?~]/g)
                var OneExtension = OnlyFileName.match(/[.]/g)

                if (!specialchar == null || !specialchar == "") {
                    showMessage("Invalid file name, only letters and numbers are allowed", false);
                    return false;
                }
                else if (!OneExtension == null || !OneExtension == "") {
                    showMessage("Invalid file, It should have only one extension", false);
                    return false;
                }
               
                if (FileNameWithExtension.length < FileNameSize) {
                    showMessage("File name should be greater than or equal to 5 Characters", false);
                    return false;
                }
                else if (FileNameWithExtension.length > 128) {
                    showMessage("File name should be less than 129 Characters", false)
                    return false;
                }               

                if (data.files[0]["size"] > 52428800)
                {
                    showMessage("File Size should be less than or equal to 50 MB", false);
                    return false;
                }
                else if (data.files[0]["size"] < Filesize) {                   
                    showMessage("File Size should be greater than or equal to 1 KB", false);
                    return false;
                }
                else {
                    //This to disable other file upload controls if there are more than one available on a page
                    var this_indexvalue = $($this).closest(".clsParentFileUpload").attr("indexvalue");
                    $(".clsParentFileUpload").each(function () {
                        var index_Valuetocheck = $(this).attr("indexvalue");
                        if (index_Valuetocheck != this_indexvalue) {
                            $(this).find("input[type='file']").attr("disabled", "disabled");
                            $(this).find("span.btn.btn-default.btn-file").addClass("disable-file-upload");
                        }
                    });

                    $(this).closest(".clsParentFileUpload").find(".clsStartFileUpload").attr("data-flag", "true");
                    data.context = $($this).closest(".clsFileUpload").find(".clsStartFileUpload").off("click").click(function () {
                        if ($(this).attr("data-flag") == "true") {
                            $("body").addClass("loading");
                            $("#buttonName").val($(this).attr("data-details"));
                            $("#index").val($(this).attr("data-index"));
                            $("#divclone").val($(this).closest(".clsFileUpload").find(".clsDivDynamic").attr("id"));
                            data.submit();
                            return false;
                        }
                        return false;
                    });
                }
            },
            change: function (e, data) {
                $($this).closest(".clsFileUpload").find("button.clsStartFileUpload").attr("data-flag", "false");
                //This is to enable back all the file upload controls on the page
                $(".clsParentFileUpload").each(function () {
                    $(this).find("input[type='file']").removeAttr("disabled");
                    $(this).find("span.btn.btn-default.btn-file").removeClass("disable-file-upload");
                });

                var nameOfHidden = $($this).closest(".clsFileUpload").find("input[type='hidden'][name$='.Document']").attr("name");
                $($this).closest(".clsFileUpload").find("input[type='file'].form-control.document").attr("name", nameOfHidden);
                $($this).closest(".clsFileUpload").find("input[type='hidden'][name$='Document']").remove();
                $($this).closest(".clsFileUpload").find("input[type='file'].form-control.document.valid").removeClass("valid");
            },
            done: function (e, data) {
                $("body").removeClass("loading");
                showMessage(data.result.Message.Document, data.result.status);
                data.result.obj.forEach(function (value, index) {
                    $("[name='[" + value.Index + "].Value[" + value.SubIndex + "].GUID']").val(value.GUID);
                    $("[name='[" + value.Index + "].Value[" + value.SubIndex + "].DocumentId']").val(value.DocumentID);
                    $("[name='[" + value.Index + "].Value[" + value.SubIndex + "].DocumentName']").val(value.DocumentName);
                    $("#" + data.result.divclone).html("");
                    var str = '<div id="' + value.Index + value.SubIndex + '"> \
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6"> \
                                    <a href="' + $("#DownloadDocument").val() + '?nDocumentDetailsID=' + value.DocumentID + '&GUID=' + value.GUID + '&sDocumentName=' + value.DocumentName + '&sFileType=' + value.FileType + '&acid=' + value.UserAction + '">' + value.DocumentName + '</a> \
                                </div> '
                    if ($('#del_action').val() == '1') {
                        str = str + '<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6"> \
                                    <a href="javascript:void(0);" class="display-icon icon icon-delete deleteDocument" querystring="[{key:\'acid\',value:' + value.UserAction + '},{key:\'nDocumentDetailsID\',value:' + value.DocumentID + '},{key:\'nIndex\',value:' + value.Index + '},{key:\'nSubIndex\',value:' + value.SubIndex + '},{key:\'GUID\',value:\'' + value.GUID + '\'}]"></a> \
                                </div> \
                            </div>';
                    }
                    
                    $("#" + data.result.divclone).append(str);
                    //commented successful msg 
                    //$('div[name=ErrorMessageDocument]').addClass('alert-success').fadeIn('slow');
                    //$('div[name=ErrorMessageDocument]').html(data.result.Message['Document']);

                    $($this).closest(".clsFileUpload").find("button.clsStartFileUpload").attr("data-flag", "false");
                    //This is to enable back all the file upload controls on the page
                    $(".clsParentFileUpload").each(function () {
                        $(this).find("input[type='file']").removeAttr("disabled");
                        $(this).find("span.btn.btn-default.btn-file").removeClass("disable-file-upload");
                    });
                    //For reseting the control after a file is uploaded
                    $($this).closest(".clsFileUpload").find(".fileinput-filename").text("");
                    $($this).closest(".clsFileUpload").find(".fileinput.input-group.fileinput-exists").attr("class", "fileinput input-group fileinput-new");
                    $($this).closest(".clsFileUpload").find("input[type='hidden'][name='']").remove();

                    setTimeout(function () {
                        $('div[name=ErrorMessageDocument]').removeClass('alert-success').fadeOut('slow');
                        $('div[name=ErrorMessageDocument]').html("");
                    }, 20000);
                });
                return false;
            }
        });
    });
   
    $(document).delegate(".btnEditDocumentDetails", "click", function () {
        data = {};
        data["acid"] = $("#EditDocumentACID").attr("data-acid");
        data["nmaptotypecodeid"] = $(this).attr("data-maptotypecodeid");
        data["nmaptoid"] = $(this).attr("data-maptoid");
        data["nDocumentDetailsID"] = $(this).attr("data-documentDetailsID");
        data["npurposecodeid"] = $(this).attr("data-purposecodeid");
        $.ajax({
            url: $(this).attr("url"),
            type: 'post',
            headers: getRVToken(),
            data: data,
            success: function (data) {
                $("#divDocumentDetailsModal").html(data);
                $("#divDocumentDetailsModal").show();
                $('#DocumentModal').modal('show');
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });

    $(document).delegate("#btnAddDocumentDetails", "click", function () {
        $.ajax({
            url: $(this).attr("url"),
            method: 'post',
            headers: getRVToken(),
            data: { "acid": $(this).attr("data-acid"), "nMapToTypeCodeId": $(this).attr("data-maptotypecodeid"), "nMapToId": $(this).attr("data-maptoid") },
            success: function (data) {
                $("#divDocumentDetailsModal").html(data);
                $("#divDocumentDetailsModal").show();
                $('#DocumentModal').modal('show');
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });

    $(document).delegate(".deleteDocument", "click", function () {
        var $this = this;
        if (confirm("Are you sure you want to delete the record?")) {
            var privateDataTable = $("table[name='DatatableGrid'][gridtype='114006']").dataTable();
            if ($("table[name='DatatableGrid_userdoc'][gridtype='114006']").length > 0) {
                privateDataTable = $("table[name='DatatableGrid_userdoc'][gridtype='114006']").dataTable();
            }
            var data = {};
            if ($(this).attr('queryString') != undefined) {
                var obj = eval('{ queryParam: ' + $(this).attr("queryString") + ' }');
                $.each(obj, function (key, value) {
                    data[value.key] = value.value;
                });
                $.ajax({
                    "url": $("#DeleteSingleDocument").val(),
                    "type": 'post',
                    headers: getRVToken(),
                    "data": data,
                    "dataType": 'json',
                    "success": function (data) {
                        if (data.userType) {
                            privateDataTable.fnDraw();
                            $('#DocumentModal').modal('hide');
                            $("#divDocumentDetailsModal").hide();
                        }
                        else {
                            if (data.removeMapToId == true) {
                                $("[name='[" + data.Index + "].Value[" + data.SubIndex + "].MapToId']").removeAttr("value");
                                $("[name='[" + data.Index + "].Value[" + data.SubIndex + "].MapToTypeCodeId']").removeAttr("value");
                                $("[name='[" + data.Index + "].Value[" + data.SubIndex + "].PurposeCodeId']").removeAttr("value");
                            }
                            $("#" + data.Index + data.SubIndex).remove();
                            $("[name='[" + data.Index + "].Value[" + data.SubIndex + "].DocumentId']").removeAttr("value");
                            $("[name='[" + data.Index + "].Value[" + data.SubIndex + "].GUID']").removeAttr("value");
                            $("[name='[" + data.Index + "].Value[" + data.SubIndex + "].DocumentName']").removeAttr("value");
                            

                            $('div[name=ErrorMessageDocument]').addClass('alert-success').fadeIn('slow');
                            $('div[name=ErrorMessageDocument]').html(data.Message['Document']);
                            showMessage(data.Message['Document'], true);
                            setTimeout(function () {
                                $('div[name=ErrorMessageDocument]').removeClass('alert-success').fadeOut('slow');
                                $('div[name=ErrorMessageDocument]').html("");
                            }, 20000);
                            $($this).closest(".clsFileUpload").find("button.clsStartFileUpload").attr("data-flag", "false");
                            //For reseting the control after a file is deleted
                            $($this).closest(".clsFileUpload").find(".fileinput-filename").text("");
                            $($this).closest(".clsFileUpload").find(".fileinput.input-group.fileinput-exists").attr("class", "fileinput input-group fileinput-new");
                            $($this).closest(".clsFileUpload").find("input[type='hidden'][name='']").remove();
                        }
                    },
                    "error": function (jqXHR, textStatus, errorThrown) {
                        alert(errorThrown);
                    }

                });
            }
        }
    });
});