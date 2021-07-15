$(document).on('page:change', function(){  

  $('#menu-items-list').bind('cocoon:after-insert', function() {
    $('.nesting-wrapper').sortable({
      cursor: "move",
      opacity: 0.7,
      connectWith: '.nesting-wrapper',
      placeholder: 'ui-state-hover',
      update: function(e, ui) {
        $.ajax({
          url: $(this).data("url"),
          type: "PATCH",
          data: $(this).sortable('serialize') + '&parent_item_id=' + getParentItem(e.target)
        });
      },
      start: function( e, ui ) {
        $sortedItem = ui.item;
        $('.nesting-wrapper').addClass('subitem');
        $('.nesting-wrapper.subitem.dropped').removeClass('dropped');
        // Avoids nesting more than two levels deep
        $('.nested-fields').each(function() {
          if($(this).parents('.nested-fields').length > 0 || $sortedItem.find('.nested-fields').length > 0){
            $(this).find('.nesting-wrapper.subitem').addClass('dropped')
          }
        });
      },
      stop: function( e, ui ) {
        $('.nesting-wrapper.subitem').addClass('dropped')
        $('.nesting-wrapper').addClass('subitem')
      }
    })

    function getParentItem(event_target) {
      if(event_target.id !== "menu-items-list") {
        return event_target.parentElement.getAttribute('id').split('_').pop()
      }
    }
  });

  $('.nesting-wrapper.nested').on('change', function(e, ui) {
    var eventTargetMenuItem = getMenuItem(e.target);
    var $menuItem = $(eventTargetMenuItem)
    if (!!eventTargetMenuItem) {
      var urlArray = window.location.href.split("/");
      var menuId = urlArray.map(Number).filter(Number)[0].toString()
      var itemField = getItemField(eventTargetMenuItem.classList);
      var itemType, url, page_link;
      var link = getItemLink($menuItem)
      if (["title", "url", "page_link", "target_blank"].includes(itemField)) {
        var title = $menuItem.find('input.menu-item-title').val()
        if(eventTargetMenuItem.classList.value.includes("url")) {
          itemType = "url"
          url = link
          page_link = ''
        };
        if(eventTargetMenuItem.classList.value.includes("page_link")) {
          itemType = "page_link"
          url = ''
          page_link = link
        };
        var parentItemId = getParentItemId($menuItem)
        var position = $menuItem.index()
        var targetBlank = $menuItem.find('input.menu-item-target_blank')[0]['checked']
        var disabled = $menuItem.find('input.menu-item-disabled')[0]['checked']
        var childrenItemIds = getChildrenItemId($menuItem)
        if (title.length > 0) {
          if (eventTargetMenuItem.id == "new_menu_item") {
            $.ajax({
              url: "/admin/menus/" + menuId + "/menu_items",
              type: "POST",
              data: {
                      'title': title,
                      'url': url,
                      'page_link': page_link,
                      'parent_item_id': parentItemId,
                      'children_item_ids': childrenItemIds,
                      'position': position,
                      'item_type': itemType,
                      'target_blank': targetBlank,
                      'disabled': disabled
                    },
              item: $menuItem,
              success: function(data){
                if (data.errors) {
                  var errorField = Object.keys(data.errors)[0];
                  var menuItemSelector = '#new_menu_item';
                  var $menuItem = $(menuItemSelector);
                  var fieldSelector = '.menu-item-' + errorField
                  var $itemField = $menuItem.find(fieldSelector).first()
                  $itemField.addClass('wrap-field-error')
                } else {
                  var $newItem = this.item
                  var itemData = data['menu_item']
                  var $newItemTitle = $newItem.find('.menu-item-tag').first()
                  $newItemTitle.text(itemData['title'] + ' (Guardando...)')
                  setTimeout(
                    function(){
                      $newItemTitle.text(itemData['title'])
                    }, 500)
                  $newItem.attr('id', "menu_item_" + itemData['id'])
                }
              }
            });
          };

          if (eventTargetMenuItem.id.includes('menu_item_')) {
            var itemId = eventTargetMenuItem.id.split('_').pop();
            $.ajax({
              url: "/admin/menus/" + menuId + "/menu_items/" + itemId,
              type: "PUT",
              data: {
                      'title': title,
                      'url': url,
                      'page_link': page_link,
                      'parent_item_id': parentItemId,
                      'item_type': itemType,
                      'target_blank': targetBlank,
                      'disabled': disabled
                    },
              success: function(data){
                if (data.errors) {
                  var errorField = Object.keys(data.errors)[0];
                  var menuItemSelector = '#menu_item_' + data.menu_item.id;
                  var $menuItem = $(menuItemSelector);
                  var fieldSelector = '.menu-item-' + errorField
                  var $itemField = $menuItem.find(fieldSelector).first()
                  $itemField.addClass('wrap-field-error')
                } else {
                  var itemData = data['menu_item']
                  var menuItemSelector = "#menu_item_" + itemData['id']
                  var $menuItemTitle = $(menuItemSelector + " h5.menu-item-tag").first()
                  $menuItemTitle.text(itemData['title'] + ' (Actualizando...)')
                  setTimeout(
                    function(){
                      $menuItemTitle.text(itemData['title'])
                    }, 500)
                  $(menuItemSelector).find('.wrap-field-error').removeClass('wrap-field-error')
                }
              }
            });
          };
        }
      }
    };
    removeItem();
  })

  toggleMenuItemCardSection();
  toggleAllMenuItemCardSection();
  removeItem();
  // Activates 'cocoon:after-insert' to allow sorting existing menu-items
  if($('.nested-fields').length > 0) {
    $('.button.add_fields').click()
    $('.remove_fields.dynamic').click()
  }
});

function removeItem() {
  $('#menu-items-list a.remove_fields').click(function(e) {
    var urlArray = window.location.href.split("/");
    var menuId = urlArray.map(Number).filter(Number)[0].toString()
    var eventTargetMenuItem = getMenuItem(e.target);
    var itemId = eventTargetMenuItem.id.split('_').pop();
    $.ajax({
      url: "/admin/menus/" + menuId + "/menu_items/" + itemId,
      type: "DELETE"
    });
  })
}

function getMenuItem(event_target) {
  var newMenuItem = event_target.closest('#new_menu_item');
  var persistedMenuItem = event_target.closest('[id*="menu_item_"]');
  if (!!newMenuItem) {
    return newMenuItem;
  };
  if (!!persistedMenuItem) {
    return persistedMenuItem;
  };
}

function getItemField(itemClasses) {
  if(itemClasses.value.includes("url")) {
    return "url";
  };
  if(itemClasses.value.includes("page_link")) {
    return "page_link";
  };
}

function getItemLink(menuItem) {
  if (menuItem.hasClass('url')) {
    return menuItem.find('input.menu-item-url').first().val()
  }
  if (menuItem.hasClass('page_link')) {
    return menuItem.find('select.menu-item-page_link').first().val()
  }
}

function getParentItemId(menuItem) {
  if (menuItem.parents('[id*="menu_item_"]').first().length > 0 ) {
    return menuItem.parents('[id*="menu_item_"]').first().attr('id').split("_").pop()
  } else {
    return 0
  }
}

function getChildrenItemId(menuItem) {
  var childrenIds = [];
  menuItem.find('.nested-fields').each(function () {
    var childrenId = this.id.split('_').pop();
    if (parseInt(childrenId)) {
      childrenIds.push(childrenId);
    }
  })
  return childrenIds;
}

function toggleMenuItemCardSection() {
  $('#menu-items-list .card-section').hide();
  $('#menu-items-list .card-divider').on('click', function(){
    $(this).siblings('.card-section').slideToggle();
    var $arrowDown = $(this).find('.icon-arrow-down');
    if($arrowDown.length) {
      $arrowDown.toggleClass('icon-arrow-down icon-arrow-top');
    } else {
      var $arrowTop = $(this).find('.icon-arrow-top');
      if($arrowTop.length){
        $arrowTop.toggleClass('icon-arrow-top icon-arrow-down');
      }
    }
  })
}

function toggleAllMenuItemCardSection(e) {
  $('#toggle_menu_collapse_button').on('click', function(){
    $(this).toggleClass('toggle-open');
    $(this).find('.icon-arrow-down').toggleClass('icon-arrow-down icon-arrow-top');
    var cardSections = $('#menu-items-list .card-section')
    for(var cardSection of cardSections) {
      var $arrow = $(cardSection).siblings('.card-divider')
      // debugger;
      if($(this).hasClass('toggle-open')){
        $(this).find('.icon-arrow-down').toggleClass('icon-arrow-down icon-arrow-top');
        cardSections.show('slow', 'swing');
        $arrow.find('.icon-arrow-down').toggleClass('icon-arrow-down icon-arrow-top');
      } else {
        $(this).find('.icon-arrow-top').toggleClass('icon-arrow-top icon-arrow-down');
        cardSections.hide('slow', 'swing');
        $arrow.find('.icon-arrow-top').toggleClass('icon-arrow-top icon-arrow-down');
      }
    }
    return false;
  })
}