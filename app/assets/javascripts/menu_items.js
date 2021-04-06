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
        data: $(this).sortable('serialize') + '&parent_item_id=' + getParentItem(this)
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

  $('#menu-items-list').on('change', function(e) {
    var menuItem = getMenuItem(e.target);
    if (!!menuItem) {
      var urlArray = window.location.href.split("/")
      var menuId = urlArray.find(e => Number.isInteger(parseInt(e)))
      var itemClass = e.target.classList.value
      var itemField = itemClass.split('-').pop()
      var itemType, url, page_link
      var link =  menuItem.children[1].children[3].children[1].value
      if (["title", "url", "page_link", "target_blank"].includes(itemField)) {
        var title = menuItem.children[1].children[2].children[1].value
        if(menuItem.classList.value.includes("url")) {
          itemType = "url"
          url = link
          page_link = ''
        }
        if(menuItem.classList.value.includes("page_link")) {
          itemType = "page_link"
          url = ''
          page_link = link
        }
        var parentItemId = menuItem.parentElement.parentElement.id.split("_").pop() || 0
        var targetBlank = menuItem.children[1].children[4].children[1]['checked']
        if (title.length > 0) {
          if (menuItem.id == "new_menu_item") {
            $.ajax({
              url: "/admin/menus/" + menuId + "/menu_items",
              type: "POST",
              data: {'title': title, 'url': url, 'page_link': page_link, 'parent_item_id': parentItemId, 'item_type': itemType, 'target_blank': targetBlank, 'editable': false },
              success: function(data){
                var itemData = data['menu_item']
                var title = itemData['title']
                var id = itemData['id']
                $('#new_menu_item h5').text(title)
                $('#new_menu_item').attr('id', "menu_item_" + id)
              }
            });
          }

          if (menuItem.id.includes('menu_item_')) {
            var itemId = menuItem.id.split('_').pop()
            $.ajax({
              url: "/admin/menus/" + menuId + "/menu_items/" + itemId,
              type: "PUT",
              data: {'title': title, 'url': url, 'page_link': page_link, 'parent_item_id': parentItemId, 'item_type': itemType, 'target_blank': targetBlank, 'editable': false },
              success: function(data){
                var itemData = data['menu_item']
                var title = itemData['title']
                var id = itemData['id']
                $("#menu_item_" + id + " h5").text(title)
              }
            })
          }
        }
      }
    }

  })

  $('.remove_fields.existing').click(function(e) {
    var urlArray = window.location.href.split("/")
    var menuId = urlArray.find(e => Number.isInteger(parseInt(e)))
    var menuItem = getMenuItem(e.target);
    var itemId = menuItem.id.split('_').pop()
    $.ajax({
      url: "/admin/menus/" + menuId + "/menu_items/" + itemId,
      type: "DELETE"
    })
  })

  function getMenuItem(event_target) {
    var newMenuItem = event_target.closest('#new_menu_item')
    var persistedMenuItem = event_target.closest('[id*="menu_item_"]')
    if (!!newMenuItem) {
      return newMenuItem;
    }
    if (!!persistedMenuItem) {
      return persistedMenuItem;
    }
  }


});