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
    }
  });
});