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

  def font_type_options
    {
      "Arial" => "'Arial', sans-serif",
      "Arial Black" => "'Arial Black', sans-serif",
      "Verdana" => "'Verdana', sans-serif",
      "Tahoma" => "'Tahoma', sans-serif",
      "Trebuchet MS" => "'Trebuchet MS', sans-serif",
      "Impact" => "'Impact', sans-serif",
      "Times New Roman" => "'Times New Roman', serif",
      "Didot" => "'Didot', serif",
      "Georgia" => "'Georgia', serif",
      "American Typewriter" => "'American Typewriter', serif",
      "Andale Mono" => "'Andale Mono', monospace",
      "Courier" => "'Courier', monospace",
      "Courier New" => "'Courier New', monospace",
      "Lucida Console" => "'Lucida Console', monospace",
      "Monaco" => "'Monaco', monospace",
      "Bradley Hand" => "'Bradley Hand', cursive",
      "Brush Script MT" => "'Brush Script MT', cursive",
      "Garamond" => "'Garamond', serif",
      "Helvetica" => "'Helvetica', sans-serif",
      "Lato" => "'Lato', sans-serif;",
      "Luminary" => "'Luminary', fantasy;",
      "Comic Sans" => "'Comic Sans', cursive;",
    }
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

  def custom_page_user_email(custom_page)
    custom_page.user.email rescue ''
  end

  def custom_page_user_roles(custom_page)
    display_user_roles(custom_page.user) rescue ''
  end

  def enabled_snippets
    @custom_page.custom_page_modules.enabled.map(&:js_snippet).compact
  end

  def custom_page_font_color_or_default
    @custom_page.font_color.present? ? @custom_page.font_color : CustomPage::DEFAULT_FONT_COLOR
  end

  def custom_page_module_renders(custom_page)
    renders = []
    custom_page.custom_page_modules.enabled.sorted.each do |custom_page_module|
      renders << render_module(custom_page_module)
    end
    renders.compact
  end

  def video_thumbnail(url)
    if url.include?("youtu")
      return "<img src='https://img.youtube.com/vi/#{video_id(url, 'youtube')}/hqdefault.jpg'>".html_safe
    end
    if url.include?("vimeo.com")
      uri = URI.parse("https://vimeo.com/api/oembed.json?url=#{url}")
      response = Net::HTTP.get_response(uri)
      if response.code == "200"
        response_json = JSON.parse(response.body)
        return "<img src='#{response_json['thumbnail_url']}'>".html_safe
      else
        return "<img src='https://i.vimeocdn.com/video/'>"
      end
    end
    if url.include?("slideshare.net")
      uri = URI.parse("https://www.slideshare.net/api/oembed/2?url=#{url}&format=json")
      response = Net::HTTP.get_response(uri)
      if response.code == "200"
        response_json = JSON.parse(response.body)
        return "<img src='#{response_json['thumbnail_url']}' width='260'>".html_safe
      else
        return "<img src='https://i.vimeocdn.com/video/'>".html_safe
      end
    end
    if url.include?("prezi.com")
      return "<iframe src='https://prezi.com/embed/#{video_id(url, "prezi")}' id='iframe_container' frameborder='0' height='170' width='260'></iframe>".html_safe
    end
  end

  def render_module(custom_page_module)
    render partial: "/custom_pages/#{custom_page_module.type.underscore}", locals: {custom_page_module: custom_page_module} rescue nil
  end

  ## Youtube

  def default_video_size(text_position)
    if text_position == 'none'
      {
        width: '800',
        height: '450'
      }
    else
      {
        width: '500',
        height: '280'
      }
    end
  end

  def youtube_position_options
    {
      "Texto no visible" => 'none',
      "Texto a la derecha" => 'right',
      "Texto a la izquierda" => 'left',
    }
  end

  def render_video_resource(url, text_position)
    if url.include?("vimeo.com")
      return "<iframe src='https://player.vimeo.com/video/#{video_id(url, "vimeo")}?color=ffffff&title=0&byline=0&portrait=0' width='#{default_video_size(text_position)[:width]}' height='#{default_video_size(text_position)[:height]}' frameborder='0' allow='autoplay; fullscreen; picture-in-picture' allowfullscreen></iframe>".html_safe
    end
    if url.include?("youtu")
      return "<iframe width='#{default_video_size(text_position)[:width]}' height='#{default_video_size(text_position)[:height]}' src='https://www.youtube.com/embed/#{video_id(url, "youtube")}' frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>".html_safe
    end
    if url.include?("slideshare.net")
      return slideshare_render(url).html_safe
    end
    if url.include?("prezi.com")
      return "<iframe src='https://prezi.com/embed/#{video_id(url, "prezi")}' id='iframe_container' frameborder='0' height='#{default_video_size(text_position)[:height]}' width='#{default_video_size(text_position)[:width]}'></iframe>".html_safe
    end
  end

  def slideshare_render(url)
    uri = URI.parse("https://www.slideshare.net/api/oembed/2?url=#{url}&format=json")
    response = Net::HTTP.get_response(uri)
    if response.code == "200"
      response_json = JSON.parse(response.body)
      slideshare_html = response_json["html"]
      return update_slideshare_size(slideshare_html)
    else
      return "<iframe src='https://www.slideshare.net/slideshow/embed_code/key/not_found' width='#{default_video_size[:width]}' height='#{default_video_size[:height]}' style='border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;' allowfullscreen> </iframe>"
    end
  end

  def update_slideshare_size(html)
    width = (html.scan(/width="([0-9]+)"/)).flatten.first
    height = (html.scan(/height="([0-9]+)"/)).flatten.first
    html.gsub!(width, default_video_size[:width])
    html.gsub!(height, default_video_size[:height])
    html
  end

  def video_id(url, type)
    regex = case type
    when "youtube"
      /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
    when "vimeo"
      /(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/(?:[^\/]*)\/videos\/|album\/(?:\d+)\/video\/|video\/|)(\d+)(?:[a-zA-Z0-9_\-]+)?/
    when "prezi"
      splitted_url = url.split("/")
      id_index = splitted_url.find_index("prezi.com") + 1
      return splitted_url[id_index]
    end
    match = regex.match(url)
    if match && !match[1].blank?
      match[1]
    else
      nil
    end
  end

  ## CTA

  def get_image_height(cta_image)
    geometry = Paperclip::Geometry.from_file(cta_image)
    geometry.height.to_f*(CTAModule::IMAGE_WIDTH/geometry.width.to_f)
  end

  def get_rgba_color(overlay_color, overlay_opacity)
    rgba = overlay_color.match(/^#(..)(..)(..)$/).captures.map(&:hex)
    opacity_ratio = overlay_opacity.to_f/100
    "rgba(#{rgba[0]}, #{rgba[1]}, #{rgba[2]}, #{opacity_ratio})"
  end

  def set_cta_content_height(height_position, cta_image)
    image_height = get_image_height(cta_image)
    ratio = image_height*height_position.to_f/image_height/100
    "#{image_height*(1-ratio)}px"
  end

  def cta_width_position_options
    {
      "Alineado izquierda" => 'left',
      "Centrado" => 'center',
      "Alineado derecha" => 'right'
    }
  end

end
