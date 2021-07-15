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
        expect(page).to have_link "Páginas personalizadas"
      end
    end

    scenario "Index show all custom pages" do
      visit admin_custom_pages_path(filter: "all")
      expect(page).to have_content("Hay 1 custom page")
    end

    scenario "Index show published custom pages" do
      visit admin_custom_pages_path(filter: "published")
      expect(page).to have_content("No se han encontrado custom pages")
    end

    scenario "Index show draft custom pages" do
      visit admin_custom_pages_path(filter: "draft")
      expect(page).to have_content("Hay 1 custom page")
    end

    scenario "Draft custom page is an admin page" do
      visit("/#{@custom_page.slug}")
      expect(page).to have_current_path(admin_custom_page_draft_preview_path(@custom_page))
    end

    scenario "Published custom page is displayed as public page" do
      @custom_page.update_column(:published, true)
      visit("/#{@custom_page.slug}")
      expect(page).to have_content(@custom_page.title)
      expect(page).to have_current_path(custom_page_path(@custom_page.slug))
    end

  end

  context "New" do
    scenario "Can´t create custom page modules before custom page creation" do
      visit new_admin_custom_page_path
      expect(page).not_to have_content("Añadir Módulo")
    end

    scenario "Allows to create parent custom pages" do
      @parent_custom_page = create(:custom_page)
      @custom_page = create(:custom_page, title: "Children custon page", slug: "children-custom-page", parent_slug: @parent_custom_page.slug)
      visit("/#{@custom_page.parent_slug}""/#{ @custom_page.slug}")
      expect(page).to have_content(@custom_page.title)
    end
  end

  context "Create/Edit" do
    before do
      @custom_page = create(:custom_page)
    end

    scenario "Can create custom page modules after custom page creation" do
      visit edit_admin_custom_page_path(@custom_page)
      expect(page).to have_content("Añadir Módulo")
    end

    scenario "Displays draft preview custom page as default" do
      visit "/#{@custom_page.slug}"
      expect(page).not_to have_current_path("/#{@custom_page.slug}")
      expect(page).to have_current_path(admin_custom_page_draft_preview_path(@custom_page))
    end

    scenario "Displays public view custom page if page is published" do
      @custom_page.update_column(:published, true)
      visit "/#{@custom_page.slug}"
      expect(page).to have_current_path("/#{@custom_page.slug}")
      expect(page).not_to have_current_path(admin_custom_page_draft_preview_path(@custom_page))
    end
  end

  context "Create custom page modules" do
    before do
      @custom_page = create(:custom_page, published: true)
      visit edit_admin_custom_page_path(@custom_page)
      within("#add_modules_button") do
        click_link "Añadir Módulo"
      end
    end

    scenario "Subtitle Module", :js do
      within("#add_modules") do
        click_link "Subtítulo"
      end
      find('button.close-button').click
      within(".subtitle-module") do
        fill_in "Subtítulo", with: "Subtitle text"
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page).to have_content(@custom_page.custom_page_modules.first.subtitle)
    end

    scenario "Claim Module", :js do
      within("#add_modules") do
        click_link "Claim"
      end
      find('button.close-button').click
      within(".claim-module") do
        fill_in_ckeditor 'claim_text_area_', with: 'Claim Text'
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page).to have_content("Claim Text")
    end

    scenario "CTA Module", :js do
      within("#add_modules") do
        click_link "CTA"
      end
      find('button.close-button').click
      within(".cta-module") do
        fill_in_ckeditor 'cta_text_area_', with: 'CTA Text'
        fill_in "Texto botón Call to Action", with: 'CTA button'
        fill_in "Enlace botón Call to Action", with: "https://decide.madrid.es"
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page).to have_content('CTA Text')
      expect(page).to have_button(value: @custom_page.custom_page_modules.first.cta_button)

      click_button 'CTA button'
      expect(page).to have_current_path(@custom_page.custom_page_modules.first.cta_link)
    end

    scenario "Youtube Module", :js do
      within("#add_modules") do
        click_link "Vídeo/Presentación"
      end
      find('button.close-button').click
      within(".youtube-module") do
        fill_in "URL de Vídeo o Presentación (YouTube, Vimeo, Slideshare, Prezi)", with: "https://www.youtube.com/watch?v=w-2Zk9or8bs"
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page.find('iframe')['src']).to have_content "https://www.youtube.com/embed/w-2Zk9or8bs"
    end

    scenario "Custom Image Module", :js do
      within("#add_modules") do
        click_link "Imagen"
      end
      find('button.close-button').click
      within(".custom_image-module") do
        attach_file "Imagen Personalizada", Rails.root.join("spec/fixtures/files/custom_map.jpg")
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page).to have_css("img[src*='custom_map.jpg']")
    end

    scenario "Rich Text Module", :js do
      within("#add_modules") do
        click_link "Texto"
      end
      find('button.close-button').click
      within(".rich_text-module") do
        fill_in_ckeditor 'rich_text_area_', with: 'Custom Rich Text'
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page).to have_content("Custom Rich Text")
    end

    scenario "Promotional Module", :js do
      within("#add_modules") do
        click_link "Promocionales"
      end
      find('button.close-button').click
      within(".promotional-module") do
        fill_in "Título 1", with: "Promo Title One"
        within(".tabs-content") do
          attach_file "Imagen 1", Rails.root.join("spec/fixtures/files/custom_map.jpg")
        end
        fill_in_ckeditor 'promo_description_one_', with: 'Promo One Text'
        fill_in "Enlace 1", with: "https://decide.madrid.es"
        click_link "Promocional 2"
        fill_in "Título 2", with: "Promo Title Two"
        within(".tabs-content") do
          attach_file "Imagen 2", Rails.root.join("spec/fixtures/files/logo_header.jpg")
        end
        fill_in_ckeditor 'promo_description_two_', with: 'Promo Two Text'
        fill_in "Enlace 2", with: "https://decide.madrid.es"
        click_link "Promocional 3"
        fill_in "Título 3", with: "Promo Title Three"
        within(".tabs-content") do
          attach_file "Imagen 3", Rails.root.join("spec/fixtures/files/clippy.jpg")
        end
        fill_in_ckeditor 'promo_description_three_', with: 'Promo Three Text'
        fill_in "Enlace 3", with: "https://decide.madrid.es"

      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page).to have_content(@custom_page.custom_page_modules.first.promo_title_one)
      expect(page).to have_css("img[src*='custom_map.jpg']")
      expect(page).to have_content("Promo One Text")
      expect(page).to have_content(@custom_page.custom_page_modules.first.promo_title_two)
      expect(page).to have_css("img[src*='logo_header.jpg']")
      expect(page).to have_content("Promo Two Text")
      expect(page).to have_content(@custom_page.custom_page_modules.first.promo_title_three)
      expect(page).to have_css("img[src*='clippy.jpg']")
      expect(page).to have_content("Promo Three Text")
    end

    scenario "List Module", :js do
      within("#add_modules") do
        click_link "Listado"
      end
      find('button.close-button').click
      within(".list-module") do
        fill_in "Título 1", with: "List Title One"
        within(".tabs-content") do
          attach_file "Icono 1", Rails.root.join("spec/fixtures/files/custom_map.jpg")
        end
        fill_in_ckeditor 'list_description_one_', with: 'List One Text'
        
        click_link "Ítem 2"
        fill_in "Título 2", with: "List Title Two"
        within(".tabs-content") do
          attach_file "Icono 2", Rails.root.join("spec/fixtures/files/logo_header.jpg")
        end
        fill_in_ckeditor 'list_description_two_', with: 'List Two Text'
        
        click_link "Ítem 3"
        fill_in "Título 3", with: "List Title Three"
        within(".tabs-content") do
          attach_file "Icono 3", Rails.root.join("spec/fixtures/files/clippy.jpg")
        end
        fill_in_ckeditor 'list_description_three_', with: 'List Three Text'
        
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page).to have_content(@custom_page.custom_page_modules.first.list_title_one)
      expect(page).to have_css("img[src*='custom_map.jpg']")
      expect(page).to have_content("List One Text")
      expect(page).to have_content(@custom_page.custom_page_modules.first.list_title_two)
      expect(page).to have_css("img[src*='logo_header.jpg']")
      expect(page).to have_content("List Two Text")
      expect(page).to have_content(@custom_page.custom_page_modules.first.list_title_three)
      expect(page).to have_css("img[src*='clippy.jpg']")
      expect(page).to have_content("List Three Text")

    end

    scenario "JS Snippet Module", :js do
      within("#add_modules") do
        click_link "Javascript"
      end
      find('button.close-button').click
      within(".js_snippet-module") do
        find('.custom_page_module-js_snippet').set( "document.getElementsByClassName('custom-h2')[0].textContent='Changed Title';")
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      page.evaluate_script(@custom_page.custom_page_modules.first.js_snippet)
      expect(page).to have_content('Changed Title')
    end

    scenario "Disabled module is not displayed", :js do
      within("#add_modules") do
        click_link "Subtítulo"
      end
      find('button.close-button').click
      within(".subtitle-module") do
        fill_in "Subtítulo", with: "Subtitle text"
        find(:css, '.custom_page_module-disabled').set(true)
      end
      find('.submit_form').click

      visit "/#{@custom_page.slug}"
      expect(page).not_to have_content(@custom_page.custom_page_modules.first.subtitle)
    end

  end

  def fill_in_ckeditor(id, with:)
    within_frame find("#cke_#{id} iframe") do
      find('body').base.send_keys with
    end
  end
end