module CustomPagesHelper

  def publish_options
    {
      t("admin.custom_pages.filters.index.draft") => false,
      t("admin.custom_pages.filters.index.published") => true
    }
  end

  def set_hierarchy_page_class(custom_page)
    title_class = ""
    title_class += custom_page.children_pages.blank? ? " icon-arrow-right" : " icon-arrow-down"
    title_class += " children-page" if custom_page.parent_slug.present?
    title_class.html_safe
  end

  def parent_slug_options
    slugs = ['']
    unless @custom_page.children_pages.present?
      CustomPage.parent_pages.pluck(:slug).each do |slug|
        slugs << slug
      end
      slugs -= [@custom_page.slug]
    end
    slugs
  end

  def promo_location_options
    {
      "Izquierda" => 'left',
      "Centro" => 'center',
      "Derecha" => 'right'
    }
  end

  def promo_location_sort(custom_page_module)
    locations = {
                  'one': custom_page_module.attributes['promo_location_one'],
                  'two': custom_page_module.attributes['promo_location_two'],
                  'three': custom_page_module.attributes['promo_location_three']
                }
    [locations.key("left").to_s, locations.key("center").to_s, locations.key("right").to_s]
  end

  def custom_page_preview_path(custom_page)
    if custom_page.parent_slug.present?
      custom_page_url_path(custom_page.parent_slug, custom_page.slug)
    else
      custom_page_path(custom_page.slug)
    end
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

  def video_thumbnail(url)
    if url.include?("youtu")
      return "https://img.youtube.com/vi/#{video_id(url, "youtube")}/hqdefault.jpg"
    end
    if url.include?("vimeo.com")
      uri = URI.parse("https://vimeo.com/api/oembed.json?url=#{url}")
      response = Net::HTTP.get_response(uri)
      if response.code == "200"
        response_json = JSON.parse(response.body)
        return response_json["thumbnail_url"]
      else
        return "https://i.vimeocdn.com/video/"
      end
    end
  end

  def custom_page_module_renders(custom_page)
    renders = []
    custom_page.custom_page_modules.enabled.sorted.each do |custom_page_module|
      renders << render_module(custom_page_module)
    end
    renders.compact
  end

  def render_module(custom_page_module)
    render partial: "/custom_pages/#{custom_page_module.type.underscore}", locals: {custom_page_module: custom_page_module} rescue nil
  end

  def render_video_resource(url)
    if url.include?("vimeo.com")
      return "<iframe src='https://player.vimeo.com/video/#{video_id(url, "vimeo")}?color=ffffff&title=0&byline=0&portrait=0' width='800' height='450' frameborder='0' allow='autoplay; fullscreen; picture-in-picture' allowfullscreen></iframe>".html_safe
    end
    if url.include?("youtu")
      return "<iframe width='800' height='450' src='https://www.youtube.com/embed/#{video_id(url, "youtube")}' title='YouTube video player' frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>".html_safe
    end
  end

  def video_id(url, type)
    regex = case type
    when "youtube"
      /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
    when "vimeo"
      /(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/(?:[^\/]*)\/videos\/|album\/(?:\d+)\/video\/|video\/|)(\d+)(?:[a-zA-Z0-9_\-]+)?/
    end
    match = regex.match(url)
    if match && !match[1].blank?
      match[1]
    else
      nil
    end
  end

end
