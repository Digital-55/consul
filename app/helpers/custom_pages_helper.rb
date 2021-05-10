module CustomPagesHelper

  def publish_options
    {
      t("admin.custom_pages.filters.index.draft") => false,
      t("admin.custom_pages.filters.index.published") => true
    }
  end

  def retrieve_options_key(hash, value)
    key = hash.key(value)
    value == true ? "<strong>#{key}</strong>".html_safe : key
  end

  def custom_page_module_partial(form_data)
    return 'subtitle_module' if form_data.type == "SubtitleModule"
    return 'claim_module' if form_data.type == "ClaimModule"
    return 'rich_text_module' if form_data.type == "RichTextModule"
    return 'youtube_module' if form_data.type == "YoutubeModule"
    return 'cta_module' if form_data.type == "CTAModule"
    return 'js_snippet_module' if form_data.type == "JSSnippetModule"
    return 'custom_image_module' if form_data.type == "CustomImageModule"
    return 'promotional_module' if form_data.type == "PromotionalModule"
  end

  def module_id(object)
    if object.new_record?
      "new_custom_page_module"
    else
      "custom_page_module_#{object.id}"
    end
  end

  def enabled_snippets
    @custom_page.custom_page_modules.enabled.map(&:js_snippet).compact
  end

  def youtube_thumbnail(youtube_url)
    "https://img.youtube.com/vi/#{youtube_id(youtube_url)}/hqdefault.jpg"
  end

  def youtube_id(youtube_url)
    regex = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
    match = regex.match(youtube_url)
    if match && !match[1].blank?
      match[1]
    else
      nil
    end
  end

end
