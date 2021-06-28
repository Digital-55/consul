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

  $('#custom-page-modules-list').bind('cocoon:after-insert', function() {
    validateInputFields();
    updatePromotionalsLocation();
  });

  loadCodeSnippet();
  toggleCustomPageModuleCardSection();
  toggleAllCustomPageModuleCardSection();
  toggleCustomPageMetaTags();
  avoidScrollTopOnReveal();
  closeRevealAfterAddModule();
  slugAutoFill();
  validateInputFields();
  updatePromotionalsLocation();
  displayCharLimit();
});

function validateInputFields() {
  $('.custom_page_module-youtube_url').change(function(){
    var url = $(this).val();
    var regex
    debugger;
    if(url.includes("youtube.com") || url.includes("youtu.be")){
      regex = /http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)?/
    } else {
      regex = new RegExp ([
              'https?:\/\/(www.)?vimeo.com\/([0-9]{9})+|',
              'https?:\/\/([a-z0-9]+[.])*slideshare.net\/[a-zA-Z0-9\-]+\/[a-zA-Z0-9\-]+|',
              'https?:\/\/([a-z0-9]+[.])*prezi.com\/[a-zA-Z0-9\-]+\/[a-zA-Z0-9-\-/]+'
            ].join(''));
    }
    var urlValidation = url.match(regex) ? true : false;
    displayValidation(urlValidation, $(this))
  })

  $('.custom_page_module-cta_link, .custom_page_module-promo_link_one, .custom_page_module-promo_link_two, .custom_page_module-promo_link_three').change(function(){
    var link = $(this).val();
    var regex = /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/gm;
    var linkValidation = link.match(regex) ? true : false;
    if(link == ""){
      linkValidation = true;
    };
    displayValidation(linkValidation, $(this))
  })
}

function displayValidation(validation, $this){
  if(!validation) {
    if(!$this.siblings('.error-message').length) {
      if($this.context.classList.value == "custom_page_module-youtube_url"){
        $this.after('<small class="error-message">El enlace no corresponde a una URL de Vídeo o Presentación</small>');
      } else {
        $this.after('<small class="error-message">El enlace no corresponde a una URL</small>');
      }
    }
    $this.addClass('wrap-field-error');
    $("input[type=submit]").attr('disabled', true);
  } else {
    $this.siblings('.error-message').remove();
    $this.removeClass('wrap-field-error');
    $("input[type=submit]").removeClass('disabled');
    $("input[type=submit]").attr('disabled', false);
  }
  return false;
}

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
    var $arrowDown = $(this).find('.icon-angle-down');
    if($arrowDown.length) {
      $arrowDown.toggleClass('icon-angle-down icon-angle-up');
    } else {
      var $arrowTop = $(this).find('.icon-angle-up');
      if($arrowTop.length){
        $arrowTop.toggleClass('icon-angle-up icon-angle-down');
      }
    }
  })
}

function toggleAllCustomPageModuleCardSection() {
  $('#toggle_modules_collapse_button').on('click', function(){
    $(this).toggleClass('toggle-open');
    $(this).find('.icon-angle-down').toggleClass('icon-angle-down icon-angle-up');
    var cardSections = $('#custom-page-modules-list .card-section')
    for(var cardSection of cardSections) {
      var $arrow = $(cardSection).siblings('.card-divider')
      if($(this).hasClass('toggle-open')){
        $(this).find('.icon-angle-down').toggleClass('icon-angle-down icon-angle-up');
        cardSections.show('slow', 'swing');
        $arrow.find('.icon-angle-down').toggleClass('icon-angle-down icon-angle-up');
      } else {
        $(this).find('.icon-angle-up').toggleClass('icon-angle-up icon-angle-down');
        cardSections.hide('slow', 'swing');
        $arrow.find('.icon-angle-up').toggleClass('icon-angle-up icon-angle-down');
      }
    }
    return false;
  })
}

function toggleCustomPageMetaTags() {
  $('#custom_page-meta_tags').hide();
  $('.custom_page-fields .icon-angle-down').on('click', function(){
    $('#custom_page-meta_tags').slideToggle();
    $('#custom_page-toggle_meta_tags a').toggleClass('icon-angle-down icon-angle-up');
    return false;
  })
}

function avoidScrollTopOnReveal(){
  $('#add_modules_button').on('click', function(e){
    e.preventDefault();
  })
}

function closeRevealAfterAddModule(){
  $('a.add_fields').on('click', function(){
    $('.reveal .close-button').click()
  })
}

function slugAutoFill(){
  if($('.custom_page-fields #slug').text().length == 0) {
    $('.custom_page-fields #title').one('blur', function(){
      var title = this.value;
      var str = title.replace(/^\s+|\s+$/g, '').toLowerCase();
      var from = "ãàáäâẽèéëêìíïîõòóöôùúüûñç·/_,:;";
      var to   = "aaaaaeeeeeiiiiooooouuuunc------";
      for (var i=0, l=from.length ; i<l ; i++) {
        str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
      }
      str = str.replace(/[^a-z0-9 -]/g, '')
                .replace(/\s+/g, '-')
                .replace(/-+/g, '-');

      $('#slug').val(str);
    })
  }
}

function updatePromotionalsLocation(){
  $('[id*="_promo_location_one"], [id*="_promo_location_two"], [id*="_promo_location_three"]').change(function(){
    var targetId = this.id.split("_").map(Number).filter(Number).toString() || "0";
    var promoOneLocation, promoTwoLocation, promoThreeLocation;
    var selectValues = {};
    if($(this).parents('#new_custom_page_module').length == 0) {
      promoOneLocation = $('#custom_page_custom_page_modules_attributes_' + targetId + '_promo_location_one').val();
      promoTwoLocation = $('#custom_page_custom_page_modules_attributes_' + targetId + '_promo_location_two').val();
      promoThreeLocation = $('#custom_page_custom_page_modules_attributes_' + targetId + '_promo_location_three').val();
      selectValues['custom_page_custom_page_modules_attributes_' + targetId + '_promo_location_one'] = promoOneLocation;
      selectValues['custom_page_custom_page_modules_attributes_' + targetId + '_promo_location_two'] = promoTwoLocation;
      selectValues['custom_page_custom_page_modules_attributes_' + targetId + '_promo_location_three'] = promoThreeLocation;
    } else {
      promoOneLocation = $('#custom_page_promotionals_attributes_' + targetId + '_promo_location_one').val();
      promoTwoLocation = $('#custom_page_promotionals_attributes_' + targetId + '_promo_location_two').val();
      promoThreeLocation = $('#custom_page_promotionals_attributes_' + targetId + '_promo_location_three').val();
      selectValues['custom_page_promotionals_attributes_' + targetId + '_promo_location_one'] = promoOneLocation;
      selectValues['custom_page_promotionals_attributes_' + targetId + '_promo_location_two'] = promoTwoLocation;
      selectValues['custom_page_promotionals_attributes_' + targetId + '_promo_location_three'] = promoThreeLocation;
    }
    var locationToUpdate = ($.grep(["left", "center", "right"], function(el){return $.inArray(el, [promoOneLocation, promoTwoLocation, promoThreeLocation]) == -1}))[0];
    var changedPromotionalLocation = $(this).context.id;
    var changedPromotionalLocationValue = selectValues[changedPromotionalLocation];
    delete selectValues[changedPromotionalLocation]
    var valueIndex = Object.values(selectValues).indexOf(changedPromotionalLocationValue);
    var selectorToUdpate = Object.keys(selectValues)[valueIndex];
    $('#' + selectorToUdpate).val(locationToUpdate).change()

  })
}

function displayCharLimit() {
  for(var metaSelector of ['#meta-title', '#meta-description']) {
    if ($(metaSelector).length && $(metaSelector).val().length > $(metaSelector).data('charLimit') ){
      $(metaSelector).css('color', '#ff0000');
      $(metaSelector).siblings('#char_num').css('color', '#ff0000');
    }

    $(metaSelector).bind('keyup keydown', function() {
      var len = this.value.length;
      var charLimit = $(this).data('charLimit');
      $(this).siblings('#char_num').text(charLimit - len);
      if (len > charLimit) {
        $(this).css('color', '#ff0000')
        $(this).siblings('#char_num').css('color', '#ff0000');
      } else {
        $(this).css('color', '#000000')
        $(this).siblings('#char_num').css('color', '#000000');
      }
    })
  }
};
