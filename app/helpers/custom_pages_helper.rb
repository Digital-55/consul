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

end
