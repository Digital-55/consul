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

  def custom_page_module_renders(custom_page)
    renders = []
    custom_page.custom_page_modules.enabled.sort_by(&:position).each do |custom_page_module|
      renders << render_module(custom_page_module)
    end
    renders.compact
  end

  def render_module(custom_page_module)
    render partial: "/custom_pages/#{custom_page_module.type.underscore}", locals: {custom_page_module: custom_page_module} rescue nil
  end

end
