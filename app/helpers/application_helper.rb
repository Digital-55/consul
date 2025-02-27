module ApplicationHelper

  def home_page?
    return false if user_signed_in?
    # Using path because fullpath yields false negatives since it contains
    # parameters too
    request.path == "/"
  end

  # if current path is /debates current_path_with_query_params(foo: "bar") returns /debates?foo=bar
  # notice: if query_params have a param which also exist in current path,
  # it "overrides" (query_params is merged last)
  def current_path_with_query_params(query_parameters)
    return human_rights_proposals_path(request.query_parameters.merge(query_parameters)) if controller_name == "human_rights"
    url_for(request.query_parameters.merge(query_parameters))
  end

  def markdown(text)
    return text if text.blank?

    # See https://github.com/vmg/redcarpet for options
    render_options = {
      filter_html:     false,
      hard_wrap:       true,
      link_attributes: {  target: "_blank" }
    }
    renderer = Redcarpet::Render::HTML.new(render_options)
    extensions = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end

  def author_of?(authorable, user)
    return false if authorable.blank? || user.blank?
    authorable.author_id == user.id
  end

  def back_link_to(destination = :back, text = t("shared.back"))
    link_to destination, class: "back" do
      content_tag(:span, nil, class: "icon-angle-left") + text
    end
  end

  def image_path_for(filename)
    SiteCustomization::Image.image_path_for(filename) || filename
  end

  def content_block(name, locale)
    SiteCustomization::ContentBlock.block_for(name, locale)
  end

  def kaminari_path(url)
    "#{root_url.chomp("\/")}#{url}"
  end

  def css_for_landing
    "landing-" + params[:landing] if params[:landing].present?
  end

  def self.asset_data_base64(path)
    asset = (Rails.application.assets || ::Sprockets::Railtie.build_environment(Rails.application))
                                                             .find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def render_custom_partial(partial_name)
    controller_action = @virtual_path.split("/").last
    custom_partial_path = "custom/#{@virtual_path.remove(controller_action)}#{partial_name}"
    render custom_partial_path if lookup_context.exists?(custom_partial_path, [], true)
  end

  def management_controller?
    controller.class.to_s.include?("Management")
  end

  def host_helper
    root_url
  end

end
