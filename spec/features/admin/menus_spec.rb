require "rails_helper"

describe "Admin menus management" do

  before do
    login_as(create(:administrator).user)
  end

  context "Index" do
    before do
      @menu1 = create(:menu,
                      title: "Menu number one",
                      section: "header"
                    )
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
end