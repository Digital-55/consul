class CreateMenuItems < ActiveRecord::Migration[5.0]
  def up
    create_table :menu_items do |t|
      t.string :title
      t.string :url
      t.string :page_link
      t.string :item_type
      t.integer :position, default: 0
      t.integer :parent_item_id, default: 0
      t.boolean :target_blank, default: false
      t.boolean :editable, default: true
      t.boolean :disabled, default: false
      t.references :menu, foreign_key: true

      t.timestamps
    end

    @header_menu = Menu.create(title: "Main header", section: "header", published: true)
    @header_menu.menu_items.build(title: "Inicio", page_link: '', item_type: 'page_link', position: 1, editable: false).save
    @header_menu.menu_items.build(title: "Debates", page_link: 'debates', item_type: 'page_link', position: 2, editable: false).save
    @header_menu.menu_items.build(title: "Propuestas", page_link: 'proposals', item_type: 'page_link', position: 3, editable: false).save
    @header_menu.menu_items.build(title: "Votaciones", page_link: 'vota', item_type: 'page_link', position: 4, editable: false).save
    @header_menu.menu_items.build(title: "Procesos", page_link: 'procesos', item_type: 'page_link', position: 5, editable: false).save
    @header_menu.menu_items.build(title: "Presupuestos participativos", page_link: 'presupuestos', item_type: 'page_link', position: 6, editable: false).save
    @header_menu.menu_items.build(title: "Ayuda", page_link: 'mas-informacion', item_type: 'page_link', position: 7, editable: false).save

    @footer_menu = Menu.create(title: "Main footer", section: "footer", published: true)
    @footer_menu.menu_items.build(title: "Política de Privacidad", page_link: 'privacy', item_type: 'page_link', position: 1, editable: false).save
    @footer_menu.menu_items.build(title: "Condiciones de uso", page_link: 'conditions', item_type: 'page_link', position: 2, editable: false).save
    @footer_menu.menu_items.build(title: "Accesibilidad", page_link: 'accessibility', item_type: 'page_link', position: 3, editable: false).save
  end

  def down
    drop_table :menu_items
  end
end
