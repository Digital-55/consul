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
    SiteCustomization::Page.where(status: "published").pluck(:title, :slug).each do |key, value|
      key = "#{key} (/#{value})"
      hash[key] = value
    end
    hash.reverse_merge(default_link_options)
        .merge(custom_page_options)
  end

  def default_link_options
    {
      "Inicio (/)" => root_path,
      "Debates (/debates)" => 'debates',
      "Propuestas (/proposals)" => 'proposals',
      "Votaciones (/vota)" => 'vota',
      "Procesos (/procesos)" => 'procesos',
      "Presupuestos Participativos (/presupuestos)" => 'presupuestos',
      "Ayuda (/mas-informacion)" => 'mas-informacion'
    }
  end

  def custom_page_options
    hash = {}
    CustomPage.pluck(:title, :parent_slug, :slug).each do |title, parent_slug, slug|
      if parent_slug
        title = "#{title} (/#{parent_slug}/#{slug})"
        hash[title] = "#{parent_slug}/#{slug}"
      else
        title = "#{title} (/#{slug})"
        hash[title] = slug
      end
    end
    hash
  end

  def retrieve_options_key(hash, value)
    key = hash.key(value)
    value == true ? "<strong>#{key}</strong>".html_safe : key
  end

  def menu_items_partial(form_data)
    return 'menu_item_fields_page_link' if form_data.item_type == "page_link"
    return 'menu_item_fields_url' if form_data.item_type == "url"
  end

  def main_header_menu
    Menu.header.published.first
  end

  def main_footer_menu
    Menu.footer.published.first
  end

  def main_menu_items(main_menu)
    main_menu&.menu_items.enabled.where(parent_item_id: 0).sort_by(&:position)
  end

  def parent_admin_menu_items(menu, parent_id)
    menu.menu_items.where(parent_item_id: parent_id).sort_by(&:position)
  end

  def children_menu_items(menu, menu_item_id)
    menu&.menu_items.enabled.where(parent_item_id: menu_item_id)
  end

  def menu_item_link(menu_item)
    return menu_item.url if menu_item.url.present?
    return menu_item.page_link if menu_item.page_link.present?
    return ''
  end

  def menu_item_target(menu_item)
    menu_item.target_blank ? '_blank' : ''
  end

  def menu_user_email(menu)
    menu.user.email rescue ''
  end

  def menu_user_roles(menu)
    display_user_roles(menu.user) rescue ''
  end
end
