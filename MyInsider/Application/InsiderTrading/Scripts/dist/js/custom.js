$(document).ready(function () {
    $('#example').DataTable();
});

$(document).ready(function () {
    $('table').css('width', '100%');
});
jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

$(document).ready(function () { // Lightbulb toggle
    $('table tr td').click(function(){
        // $(this).find('i').toggleClass('light-orange light-gray')
        $(this).find('.status').toggleClass('icon-light-off icon-light-on')
        
    });
    $('table tr td').click(function(){
        // $(this).find('i').toggleClass('light-orange light-gray')
        $(this).find('.status').toggleClass('light-orange light-gray')       
    });

// Update stateful
    $(".updateButton").click(function() {
        var $btn = $(this);
        $btn.button('loading');
        setTimeout(function () {
            $btn.button('reset');
        }, 1000);
    });

    $('.search input[type=text], .search select').on('keyup', function (e) {
        //if (e.which == 13) {
        //    $('.search button i.fa-search').parents('button').trigger('click');
        //    e.preventDefault();
        //}
    });

// check all input boxes
// check all employee/insider
//$("#cr-user-all").click(function () {
//    $(".cr-check").prop('checked', $(this).prop('checked'));
//});
//$("#emp-all").click(function () {
//    $(".emp-check").prop('checked', $(this).prop('checked'));
//});
//// check all master
//$("#master-all").click(function () {
//    $(".master-check").prop('checked', $(this).prop('checked'));
//});


// boot-wizard
$(document).ready(function() {
    $('#rootwizard').bootstrapWizard();
});

$('.input-group.date>input').keypress(function () { $(this).val("" + $(this).val().toUpperCase()); });

    try{
        $("#sandbox-container .input-group.date").datepicker.dates['en'] = $.extend($("#sandbox-container .input-group.date").datepicker.dates['en'],
            {
                days: ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"],
                daysShort: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"],
                daysMin: ["SU", "MO", "TU", "WE", "TH", "FR", "SA", "SU"],
                months: ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"],
                monthsShort: ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"],
                today: "TODAY",
                clear: "CLEAR"
            });
    }catch(e){}
// $("#sandbox-container .input-group.date").datepicker.dates['au'] = ;

// datepicker
$(document).delegate("#sandbox-container .input-group.date", "click", function () {
    var objthis = this;
    //alert($(objthis).children('input').prop("disabled"));
    if (!$(objthis).children('input').prop("disabled") && $(objthis).children('input').prop("disabled")
        != undefined) {
     $(objthis).datepicker({
         format: "dd/M/yyyy",
         monthsShort: ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"],
         weekStart: 0,
         todayBtn: "linked",
         clearBtn: true,
         orientation: "auto",
         multidate: false,
         autoclose: true,
         todayHighlight: true,
     }).datepicker('show');

    //// alert(JSON.stringify($(objthis).datepicker()));

    //  $(objthis).datepicker().datepicker.defaults.language = 'au';

    //alert('hi');

    $(objthis).datepicker().on("change", function () {
        //   alert("In change datepicker");
        var inputField = $(objthis).find("input");
        if (inputField.length > 0) {
            inputField.removeClass("input-validation-error");
            $(objthis).closest("#sandbox-container").find(".field-validation-error").html("");
            $(objthis).closest("#sandbox-container").find(".field-validation-error").addClass("field-validation-valid");
            $(objthis).closest("#sandbox-container").find(".field-validation-error").removeClass("field-validation-error");
        }
    });
}
});

$(document).delegate("#Month-container", "click", function () {
    var objthis = this;
    $(objthis).datepicker({
        format: "MM yyyy",
        viewMode: "months",
        minViewMode: "months",
        clearBtn: true,
        autoclose: true,
    }).datepicker('show');

});



$('#Month').datepicker({
    format: "MM yyyy",
    viewMode: "months",
    minViewMode: "months",
    clearBtn: true,
    autoclose: true,
});

$('#Year').datepicker({
    format: " yyyy",
    viewMode: "years",
    minViewMode: "years",
    clearBtn: true,
    autoclose: true,
});


jQuery.validator.methods.date = function (value, element) {
    var isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
    //alert(isChrome);
    //if (isChrome) {
    //    var d = new Date();
    //  //  alert(new Date(d.toLocaleDateString(value)));
    //    return this.optional(element) || !/Invalid|NaN/.test(new Date(d.toLocaleDateString(value)));
    //}
    //else {
        var months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        var testValue = value.split('/');
        value = testValue[2] + '-' + months[testValue[1] - 1]  + '-' + testValue[0];
        //alert(value);
        return this.optional(element) || !/Invalid|NaN/.test(new Date(value));
    //}
};



// Add document
function addDocument(){
    var newDocRow = "<tr>\
                        <td>6125451210000</td>\
                        <td>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo</td>\
                        <td>\
                            <div class='fileinput fileinput-new input-group' data-provides='fileinput'>\
                              <div class='form-control' data-trigger='fileinput'><i class='glyphicon glyphicon-file fileinput-exists'></i><span class='fileinput-filename'></span></div>\
                              <span class='input-group-addon btn btn-default btn-file'><span class='fileinput-new'>Select file</span><span class='fileinput-exists'>Change</span><input type='file' name='...''></span>\
                              <a href='#' class='input-group-addon btn btn-default fileinput-exists' data-dismiss='fileinput'><i class='fa fa-times-circle-o'></i></a>\
                            </div>\
                        </td>\
                        <td>\
                            <a href='#' class='display-icon' data-title='Upload Documents' data-toggle='modal' data-target='#upload-documents'>\
                                <i class='icon icon-download'></i></a>&nbsp;\
                            <a href='#' class='display-icon' data-title='Edit Documents' data-toggle='modal' data-target='#edit-documents'>\
                                <i class='icon icon-edit'></i></a>&nbsp;\
                            <a href='#' class='display-icon' data-title='Delete' data-toggle='modal' data-target='#delete'>\
                                <i class='icon icon-delete'></i>\
                            </a>\
                        </td>\
                    </tr>";
    $("#documentsTable tbody").prepend(newDocRow);
}

$(function () {
    // Replace the builtin US date validation with UK date validation
    $.validator.addMethod(
        "date",
        function (value, element) {
            var bits = value.match(/^(([0-9])|([0-2][0-9])|([3][0-1]))\/(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\/\d{4}$/);///([0-9]+)/gi), str;///
            if (!bits)
                return this.optional(element) || false;
            var months = [];
            months['JAN'] = 0;
            months['FEB'] = 1;
            months['MAR'] = 2;
            months['APR'] = 3;
            months['MAY'] = 4;
            months['JUN'] = 5;
            months['JUL'] = 6;
            months['AUG'] = 7;
            months['SEP'] = 8;
            months['OCT'] = 9;
            months['NOV'] = 10;
            months['DEC'] = 11;

                //[, 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
                value = value.toUpperCase();
                var testValue = value.split('/');
                //alert(months[testValue[1]]);
                //alert(testValue[1].toUpperCase());
                value = testValue[2] + '/' + (months[testValue[1]] + 1) + '/' + testValue[0];
               // alert(value);
              //  alert(new Date(value));
                return this.optional(element) || !/Invalid|NaN/.test(new Date(value));
        },
        ""
    );
});

// Accordion icon change

    $('.collapse').on('shown.bs.collapse', function(){
        $(this).parent().find(".fa-plus").removeClass("fa-plus").addClass("fa-minus");
    }).on('hidden.bs.collapse', function(){
        $(this).parent().find(".fa-minus").removeClass("fa-minus").addClass("fa-plus");
    });


// accordion coloring
    $('.accordion-toggle').on('click', function(){
        $(this).closest('.panel-group').children().each(function(){
            $(this).find('>.panel-heading').removeClass('active');
        });

        $(this).closest('.panel-heading').toggleClass('active');
    });

    //calender
    $(function () {

        /* initialize the external events
         -----------------------------------------------------------------*/
        function ini_events(ele) {
            ele.each(function () {

                // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
                // it doesn't need to have a start or end
                var eventObject = {
                    title: $.trim($(this).text()) // use the element's text as the event title
                };

                // store the Event Object in the DOM element so we can get to it later
                $(this).data('eventObject', eventObject);

                // make the event draggable using jQuery UI
                $(this).draggable({
                    zIndex: 1070,
                    revert: true, // will cause the event to go back to its
                    revertDuration: 0  //  original position after the drag
                });

            });
        }
        ini_events($('#external-events div.external-event'));

        /* initialize the calendar
         -----------------------------------------------------------------*/
        //Date for the calendar events (dummy data)
        var date = new Date();
        var d = date.getDate(),
                m = date.getMonth(),
                y = date.getFullYear();
        if ($('#calendar').length > 0) {
            $('#calendar').fullCalendar({
                height: 650,
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                },
                buttonText: {
                    today: 'Today',
                    month: 'Month',
                    week: 'Week',
                    day: 'Day'
                },
                //Random default events
                // events: [
                //   {
                //     title: 'All Day Event',
                //     start: new Date(y, m, 1),
                //     backgroundColor: "#f56954", //red
                //     borderColor: "#f56954" //red
                //   },
                //   {
                //     title: 'Long Event',
                //     start: new Date(y, m, d - 5),
                //     end: new Date(y, m, d - 2),
                //     backgroundColor: "#f39c12", //yellow
                //     borderColor: "#f39c12" //yellow
                //   },
                //   {
                //     title: 'Meeting',
                //     start: new Date(y, m, d, 10, 30),
                //     allDay: false,
                //     backgroundColor: "#0073b7", //Blue
                //     borderColor: "#0073b7" //Blue
                //   },
                //   {
                //     title: 'Lunch',
                //     start: new Date(y, m, d, 12, 0),
                //     end: new Date(y, m, d, 14, 0),
                //     allDay: false,
                //     backgroundColor: "#00c0ef", //Info (aqua)
                //     borderColor: "#00c0ef" //Info (aqua)
                //   },
                //   {
                //     title: 'Birthday Party',
                //     start: new Date(y, m, d + 1, 19, 0),
                //     end: new Date(y, m, d + 1, 22, 30),
                //     allDay: false,
                //     backgroundColor: "#00a65a", //Success (green)
                //     borderColor: "#00a65a" //Success (green)
                //   },
                //   {
                //     title: 'Click for Google',
                //     start: new Date(y, m, 28),
                //     end: new Date(y, m, 29),
                //     url: 'http://google.com/',
                //     backgroundColor: "#3c8dbc", //Primary (light-blue)
                //     borderColor: "#3c8dbc" //Primary (light-blue)
                //   }
                // ],
                editable: true,
                droppable: true, // this allows things to be dropped onto the calendar !!!
                drop: function (date, allDay) { // this function is called when something is dropped

                    // retrieve the dropped element's stored Event Object
                    var originalEventObject = $(this).data('eventObject');

                    // we need to copy it, so that multiple events don't have a reference to the same object
                    var copiedEventObject = $.extend({}, originalEventObject);

                    // assign it the date that was reported
                    copiedEventObject.start = date;
                    copiedEventObject.allDay = allDay;
                    copiedEventObject.backgroundColor = $(this).css("background-color");
                    copiedEventObject.borderColor = $(this).css("border-color");

                    // render the event on the calendar
                    // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
                    $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);

                    // is the "remove after drop" checkbox checked?
                    if ($('#drop-remove').is(':checked')) {
                        // if so, remove the element from the "Draggable Events" list
                        $(this).remove();
                    }

                }
            });
        }
        /* ADDING EVENTS */
        var currColor = "#3c8dbc"; //Red by default
        //Color chooser button
        var colorChooser = $("#color-chooser-btn");
        $("#color-chooser > li > a").click(function (e) {
            e.preventDefault();
            //Save color
            currColor = $(this).css("color");
            //Add color effect to button
            $('#add-new-event').css({ "background-color": currColor, "border-color": currColor });
        });
        $("#add-new-event").click(function (e) {
            e.preventDefault();
            //Get value and make sure it is not null
            var val = $("#new-event").val();
            if (val.length == 0) {
                return;
            }

            //Create events
            var event = $("<div />");
            event.css({ "background-color": currColor, "border-color": currColor, "color": "#fff" }).addClass("external-event");
            event.html(val);
            $('#external-events').prepend(event);

            //Add draggable funtionality
            ini_events(event);

            //Remove event from text input
            $("#new-event").val("");
        });
    });
});


$(document).ready(function () {
    $('.collapse.in').addClass('show');

    /*if target not defined remove toogle*/
    $("a[data-toggle='modal']").on("click", function () {
        var attr = $(this).attr('data-target');

        if (!(typeof attr !== typeof undefined && attr !== false)) {
            $(this).removeAttr("data-toggle");
        }
    });

    /*accordion color hide other element*/
    $('.accordion-toggle').on('click', function () {
        $(this).closest('.panel-group').children().each(function () {
            $(this).find('>.card-header').removeClass('active');
        });
        $(this).closest('.card-header').toggleClass('active');
    });

    $('#companyInfoAccordion  .accordion-toggle').on('click', function () {
        var hrefAttr = $(this).attr('href');
        $(hrefAttr).collapse('toggle');
    });

     /*nav tabs add active class*/
    $('li').on('click', function () {
        $(this).closest('.custom-tabs').children().each(function () {
            $(this).find('>li').removeClass('active');
        });
        $(this).addClass("active");
    });

    /*remove space taken by hidden column*/
    $('.col-lg-3:has(div[style="display:none;"])').each(function () {
        $(this).hide();
    }); 
});





