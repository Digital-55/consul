require "rails_helper"

describe "Admin custom pages management" do

  before do
    login_as(create(:administrator).user)
  end

  context "Index" do
    before do
      @custom_page = create(:custom_page)
    end

    scenario "Custom Pages management is listed on admin menu" do
      visit admin_root_path

      within("#side_menu") do
        expect(page).to have_link "Páginas personalizadas (WIP)"
      end
    end

    scenario "Index show all custom pages" do
      visit admin_custom_pages_path(filter: "all")
      expect(page).to have_content("There is 1 custom page")
    end

    scenario "Index show published custom pages" do
      visit admin_custom_pages_path(filter: "published")
      expect(page).to have_content("custom pages cannot be found")
    end

    scenario "Index show draft custom pages" do
      visit admin_custom_pages_path(filter: "draft")
      expect(page).to have_content("There is 1 custom page")
    end

    scenario "Draft custom page is not a public page" do
      visit("/#{@custom_page.slug}")
      expect(status_code).to eq(404)
    end

    scenario "Published custom page is displayed as public page" do
      @custom_page.update_column(:published, true)
      visit("/#{@custom_page.slug}")
      expect(page).to have_content(@custom_page.title)
    end

  end
end