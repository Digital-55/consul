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
    return 'subtitle_module' if form_data.type == "Subtitle"
    return 'claim_module' if form_data.type == "Claim"
  end

end
