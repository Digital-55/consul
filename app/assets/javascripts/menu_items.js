$(document).on('page:change', function(){  
  $('#menu-items-list').sortable({
    cursor: "move",
    opacity: 0.7,
    update: function(e, ui) {
      $.ajax({
        url: $(this).data("url"),
        type: "PATCH",
        data: $(this).sortable('serialize'),
      });
    }
  })
});
  