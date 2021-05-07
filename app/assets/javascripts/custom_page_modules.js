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
    $(this).siblings('.card-section').slideToggle()
  })
}