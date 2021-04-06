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

  def page_link_options
    hash = { t("admin.menus.menu_items.page_link_select") => nil }
    SiteCustomization::Page.pluck(:title, :slug).each do |key, value|
      key = "#{key} (/#{value})"
      hash[key] = value
    end
    hash.merge(default_link_options)
  end

  def default_link_options
    {
      "Inicio (/)" => '',
      "Debates (/debates)" => 'debates',
      "Propuestas (/proposals)" => 'proposals',
      "Votaciones (/vota)" => 'vota',
      "Procesos (/procesos)" => 'procesos',
      "Presupuestos Participativos (/presupuestos)" => 'presupuestos',
      "Ayuda (/mas-informacion)" => 'mas-informacion'
    }
  end

  def retrieve_options_key(hash, value)
    key = hash.key(value)
    value == true ? "<strong>#{key}</strong>".html_safe : key
  end

  def menu_items_partial(form_data)
    return 'menu_item_fields_page_link' if form_data.item_type == "page_link"
    return 'menu_item_fields' if form_data.item_type == "url"
  end

end
