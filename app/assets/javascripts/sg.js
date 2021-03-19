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