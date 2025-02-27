require "rails_helper"

describe "Probe options" do

  context "Plaza probe" do
    before do
      @probe = Probe.create(codename: "plaza")
      @probe_option = @probe.probe_options.create(code: "01", name: "mas o menos")
      logout
    end

    context "Show" do
      scenario "Option info is visible" do
        visit probe_probe_option_path(probe_id: "plaza", id: @probe_option.id)

        expect(page).to have_content "mas o menos"
        expect(page).to have_content "(REF. #{@probe_option.code})"

        expect(page).to have_link("Memoria (#{@probe_option.file_size('memoria', 'pdf')})")
        expect(page).to have_link("Imágenes (#{@probe_option.file_size('dossier', 'pdf')})")
      end

      scenario "Voting info is visible only if selecting allowed" do
        @probe.update(selecting_allowed: false)

        visit probe_probe_option_path(probe_id: "plaza", id: @probe_option.id)
        expect(page).not_to have_content "Vote"

        @probe.update(selecting_allowed: true)

        visit probe_probe_option_path(probe_id: "plaza", id: @probe_option.id)
        expect(page).to have_content "Vote"
      end

      scenario "User needs permission to select" do
        visit probe_probe_option_path(probe_id: "plaza", id: @probe_option.id)

        expect(page).to have_content "You must Sign in or Sign up to participate"
        expect(page).to have_content "mas o menos"
        expect(page).not_to have_css("#probe_option_#{@probe_option.id}_form")

        login_as(create(:user))

        visit probe_path(id: @probe.codename)

        expect(page).to have_content "To participate in this process you need to verify your account"
        expect(page).to have_content "mas o menos"
        expect(page).not_to have_css("#probe_option_#{@probe_option.id}_form")
      end

      scenario "User selects this option" do
        login_as(create(:user, :level_two))
        visit probe_probe_option_path(probe_id: "plaza", id: @probe_option.id)

        within("#probe_option_#{@probe_option.id}_form") do
          click_button "Vote"
        end

        expect(page).to have_content "Tu voto ha sido recibido"
        expect(page).to have_content "Has votado el proyecto: #{@probe_option.name}"
      end

      scenario "User has voted for this options" do
        user = create(:user, :level_two)
        ProbeSelection.create!(user: user, probe_option: @probe_option, probe: @probe)

        login_as(user)
        visit probe_probe_option_path(probe_id: "plaza", id: @probe_option.id)

        expect(page).to have_content "Has votado este proyecto"
        expect(page).not_to have_button "Vote"
      end

      scenario "User has voted for another option" do
        user = create(:user, :level_two)
        @probe_option1 = @probe.probe_options.create(code: "69", name: "archipielago")
        @probe_option2 = @probe.probe_options.create(code: "70", name: "flow")

        ProbeSelection.create!(user: user, probe_option: @probe_option1, probe: @probe)

        login_as(user)
        visit probe_probe_option_path(probe_id: "plaza", id: @probe_option2.id)

        expect(page).to have_content "Has votado el proyecto #{@probe_option1.name}"
        expect(page).to have_button "Vote"
      end

      context "Discard" do

        scenario "Discard option", :js do
          visit probe_path(id: "plaza")

          within("#probe_option_#{@probe_option.id}") do
            click_link "Ocultar este proyecto"
          end

          expect(page).not_to have_content @probe_option.name
        end

        scenario "Display all discarded options", :js do
          visit probe_path(id: "plaza")

          within("#probe_option_#{@probe_option.id}") do
            click_link "Ocultar este proyecto"
          end
          expect(page).not_to have_content @probe_option.name

          click_link "Volver a mostrar los proyectos ocultos"
          expect(page).to have_content @probe_option.name
        end

        scenario "Do not display link if there are no discarded options", :js do
          visit probe_path(id: "plaza")

          expect(page).not_to have_link "Volver a mostrar los proyectos ocultos"
        end

        scenario "Keep track of discarded options during session", :js do
          @probe_option1 = @probe.probe_options.create(code: "37", name: "dentro")
          @probe_option2 = @probe.probe_options.create(code: "02", name: "parkin")

          visit probe_path(id: "plaza")

          within("#probe_option_#{@probe_option1.id}") do
            click_link "Ocultar este proyecto"
          end

          expect(page).not_to have_content @probe_option1.name
          expect(page).to     have_content @probe_option2.name

          visit proposals_path
          visit probe_path(id: "plaza")

          expect(page).not_to have_content @probe_option1.name
          expect(page).to     have_content @probe_option2.name
          expect(page).to     have_link "Volver a mostrar los proyectos ocultos"
        end

      end
    end
  end
end
