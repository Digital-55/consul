module MenusHelper

  def section_options
    {
      t("admin.menus.new.section_select") => '',
      t("admin.menus.new.header") => 'header',
      t("admin.menus.new.footer") => 'footer'
    }
  end

  def publish_options
    {
      t("admin.menus.new.draft") => false,
      t("admin.menus.new.published") => true
    }
  end

  def retrieve_options_key(hash, value)
    key = hash.key(value)
    value == true ? "<strong>#{key}</strong>".html_safe : key
  end

end
