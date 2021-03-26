$(document).on('page:change', function(){  
  $('#menu-items-list').sortable({
    cursor: "move",
    opacity: 0.7,
    connectWith: '.nesting-wrapper',
    placeholder: 'ui-state-hover',
    update: function(e, ui) {
      $.ajax({
        url: $(this).data("url"),
        type: "PATCH",
        data: $(this).sortable('serialize'),
      });
    }
  })

  $('.nesting-wrapper').sortable({
    cursor: "move",
    opacity: 0.7,
    connectWith: '.nesting-wrapper',
    placeholder: 'ui-state-hover',
    update: function(e, ui) {
      $.ajax({
        url: $(this).data("url"),
        type: "PATCH",
        data: $(this).sortable('serialize') + '&parent_id=' + getParentItem(this)
      });
    },
    start: function( e, ui ) {
      $('.nesting-wrapper').addClass('subitem');
      $('.nesting-wrapper.subitem.dropped').removeClass('dropped');
    },
    stop: function( e, ui ) {
      $('.nesting-wrapper.subitem').addClass('dropped')
      $('.nesting-wrapper').addClass('subitem')
    }
  })

  function getParentItem(data) {
    if($(data)[0].getAttribute('id') !== "menu-items-list") {
      return $(data)[0].closest('.card.nested-fields').attributes['id'].value.split("_").pop()
    } else {
      return 0
    }
  }
});