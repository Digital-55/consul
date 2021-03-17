function getFieldNames(select_table, element_change) {
    console.log(element_change)
    console.log(select_table)

    $(element_change).load(window.location.href+encodeURI("?select_table_generic="+select_table.val())+" "+element_change);
}