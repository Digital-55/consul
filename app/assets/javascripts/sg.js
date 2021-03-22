function getFieldNames(select_table, element_change) {
    var union="?";
    if(window.location.href.includes(union)) union="&";
    $(element_change).load(window.location.href.replace('#','')+union+encodeURI("select_table_generic="+select_table.val())+" "+element_change);
}


function addTable(container, id) {
    var union="?";
    if(window.location.href.includes(union)) union="&";
    $(container).load(window.location.href.replace('#','')+union+encodeURI("id="+id+"&add_table=true")+" "+container);
}

function changetitle(element, container) {
    var union="?";
    if(window.location.href.includes(union)) union="&";
    $(container).load(window.location.href.replace('#','')+union+encodeURI("legend_title="+element.val())+" "+container);
}

function showselected(list, element_show) {
    var obj_sel = $(list).val();
    if(obj_sel == 'select') {
        $(element_show).show();
    } else {
        $(element_show).hide();
    }
}