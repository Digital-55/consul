$(document).on('page:change', function(){
  $('#custom-page-modules-list').sortable({
    cursor: "move",
    opacity: 0.7,
    connectWith: '.nesting-wrapper',
    placeholder: 'ui-state-hover',
    update: function(e, ui) {
      $.ajax({
        url: $(this).data("url"),
        type: "PATCH",
        data: $(this).sortable('serialize')
      });
    },
    start: function (event, ui) {
      var id_textarea = ui.item.find(".ckeditor textarea").attr('id');
      if(id_textarea) {
        CKEDITOR.instances[id_textarea].destroy();
      }
    },
    stop: function (event, ui) {
      var id_textarea = ui.item.find(".ckeditor textarea").attr('id');
      if(id_textarea) {
        CKEDITOR.replace(id_textarea);
      }
    }
  });
});