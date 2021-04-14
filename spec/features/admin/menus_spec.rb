require "rails_helper"

describe "Admin menus management" do

  before do
    login_as(create(:administrator).user)
  end

  context "Index" do
    before do
      @menu = create(:menu)
    end

    scenario "Menus management is listed on admin menu" do
      visit admin_root_path
  
      within("#side_menu") do
        expect(page).to have_link "Menus"
      end
    end

    scenario "Index show all menus" do
      visit admin_menus_path(filter: "all")
      expect(page).to have_content("There is 1 menu")
    end

    scenario "Index show header menus" do
      visit admin_menus_path(filter: "header")
      expect(page).to have_content("There is 1 menu")
    end

    scenario "Index show footer menus" do
      visit admin_menus_path(filter: "footer")
      expect(page).to have_content("menus cannot be found")
    end
  end

  context "New" do
    scenario "Can´t create menu items before menu creation" do
      visit new_admin_menu_path
      expect(page).not_to have_content("Añadir ítems de enlace")
      expect(page).not_to have_content("Añadir ítems de página")
    end    
  end

  context "Edit" do
    before do
      @menu = create(:menu)
    end
    scenario "Can create menu items after menu creation" do
      visit edit_admin_menu_path(@menu)
      expect(page).to have_content("Añadir ítems de enlace")
      expect(page).to have_content("Añadir ítems de página")
    end
  end


  context "Web Navbar" do
    before do
      @menu = create(:menu)
      @menu_item1 = create(:menu_item, title: "Item 1", menu_id: @menu.id)
      @menu_item2 = create(:menu_item, title: "Item 2", menu_id: @menu.id)
    end
    scenario "Menu Items are displayed in site navbar header menu" do
      visit root_path
      expect(page).to have_content("Item 1")
      expect(page).to have_content("Item 2")
    end

    scenario "One level nested Menu Item is displayed in site navbar header menu" do
      @menu_item3 = create(:menu_item, title: "Item 3", parent_item_id: @menu_item2.id, menu_id: @menu.id)
      visit root_path
      expect(page).to have_content("Item 3")
    end

    scenario "Two levels nested Menu Item is not displayed in site navbar header menu" do
      @menu_item3 = create(:menu_item, title: "Item 3", parent_item_id: @menu_item2.id, menu_id: @menu.id)
      @menu_item4 = create(:menu_item, title: "Item 4", parent_item_id: @menu_item3.id, menu_id: @menu.id)
      visit root_path
      expect(page).not_to have_content("Item 4")
    end

  end

  
end