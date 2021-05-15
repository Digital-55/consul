$(document).on('page:change', function(){

  $('#custom-page-modules-list').sortable({
    axis: 'y',
    cursor: "move",
    opacity: 0.7,
    connectWith: '.nesting-wrapper',
    placeholder: 'ui-state-hover',
    handle: '.icon-bars',
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
        CKEDITOR.replace(id_textarea, {toolbar: 'admin'});
      }
    }
  });

  loadCodeSnippet();
  toggleCustomPageModuleCardSection();
  toggleAllCustomPageModuleCardSection();
  toggleCustomPageMetaTags();
});

function loadCodeSnippet(){
  var snippets = $('.js_snippets').data("snippets")
  if(snippets) {
    for (var snippet of snippets) {
      eval(snippet)
    }
  }
}

function toggleCustomPageModuleCardSection() {
  $('#custom-page-modules-list .card-section').hide()
  $('#custom-page-modules-list .card-divider').on('click', function(){
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

function toggleAllCustomPageModuleCardSection() {
  $('#toggle_modules_collapse_button').on('click', function(){
    $(this).toggleClass('toggle-open');
    $(this).find('.icon-arrow-down').toggleClass('icon-arrow-down icon-arrow-top');
    var cardSections = $('#custom-page-modules-list .card-section')
    for(var cardSection of cardSections) {
      var $arrow = $(cardSection).siblings('.card-divider')
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

function toggleCustomPageMetaTags() {
  $('#custom_page-meta_tags').hide();
  $('.custom_page-fields .icon-arrow-down').on('click', function(){
    $('#custom_page-meta_tags').slideToggle();
    $('#custom_page-toggle_meta_tags a').toggleClass('icon-arrow-down icon-arrow-top');
    return false;
  })
}