require "rails_helper"

describe "Results" do

  let(:budget)  { create(:budget, :finished) }
  let(:group)   { create(:budget_group, budget: budget) }
  let(:heading) { create(:budget_heading, group: group, price: 1000) }

  let!(:investment1) { create(:budget_investment, :selected, heading: heading, price: 200, ballot_lines_count: 900) }
  let!(:investment2) { create(:budget_investment, :selected, heading: heading, price: 300, ballot_lines_count: 800) }
  let!(:investment3) { create(:budget_investment, :incompatible, heading: heading, price: 500, ballot_lines_count: 700) }
  let!(:investment4) { create(:budget_investment, :selected, heading: heading, price: 600, ballot_lines_count: 600) }

  before do
    Budget::Result.new(budget, heading).calculate_winners
  end

  scenario "No links to budget results with results disabled" do
    budget.update(results_enabled: false)

    visit budgets_path

    expect(page).not_to have_link "See results"

    visit budget_path(budget)

    expect(page).not_to have_link "See results"

    visit budget_executions_path(budget)

    expect(page).not_to have_link "See results"
  end

  scenario "Diplays winner investments" do
    create(:budget_heading, group: group)

    visit budget_path(budget)
    click_link "See results"

    expect(page).to have_selector("a.is-active", text: budget.headings.first.name)

    within("#budget-investments-compatible") do
      expect(page).to have_content investment1.title
      expect(page).to have_content investment2.title
      expect(page).not_to have_content investment3.title
      expect(page).not_to have_content investment4.title

      expect(investment1.title).to appear_before(investment2.title)
    end
  end

  scenario "Show non winner & incomaptible investments", :js do
    visit budget_path(budget)
    click_link "See results"
    click_link "Show all"

    within("#budget-investments-compatible") do
      expect(page).to have_content investment1.title
      expect(page).to have_content investment2.title
      expect(page).to have_content investment4.title

      expect(investment1.title).to appear_before(investment2.title)
      expect(investment2.title).to appear_before(investment4.title)
    end

    within("#budget-investments-incompatible") do
      expect(page).to have_content investment3.title
    end
  end

  scenario "Does not raise error if budget (slug or id) is not found" do
    visit budget_results_path("wrong budget")

    within(".budgets-stats") do
      expect(page).to have_content "Results"
    end

    visit budget_results_path(0)

    within(".budgets-stats") do
      expect(page).to have_content "Results"
    end
  end

  scenario "Loads budget and heading by slug" do
    visit budget_results_path(budget.slug, heading_id: heading.slug)

    expect(page).to have_selector("a.is-active", text: heading.name)

    within("#budget-investments-compatible") do
      expect(page).to have_content investment1.title
    end
  end

  scenario "Load city heading if not specified" do
    city_heading = create(:budget_heading, group: group)
    city_investment = create(:budget_investment, :winner, heading: city_heading)

    other_heading = create(:budget_heading, group: group)
    other_investment = create(:budget_investment, :winner, heading: other_heading)

    allow_any_instance_of(Budget).to receive(:city_heading).and_return(city_heading)

    visit budget_results_path(budget)

    within("#budget-investments-compatible") do
      expect(page).to have_content city_investment.title
      expect(page).not_to have_content other_investment.title
    end
  end

  scenario "Load first budget heading if not specified and city heading does not exist" do
    other_heading = create(:budget_heading, group: group)
    other_investment = create(:budget_investment, :winner, heading: other_heading)

    allow_any_instance_of(Budget).to receive(:city_heading).and_return(nil)

    visit budget_results_path(budget)

    within("#budget-investments-compatible") do
      expect(page).to have_content investment1.title
      expect(page).not_to have_content other_investment.title
    end
  end

  scenario "No incompatible investments", :js do
    investment3.incompatible = false
    investment3.save

    visit budget_path(budget)
    click_link "See results"

    expect(page).not_to have_content "Incompatibles"
  end

  context "Index" do

    scenario "Display links to finished budget results" do
      (Budget::Phase::PHASE_KINDS - ["finished"]).each do |phase|
        budget = create(:budget, phase: phase)
        expect(page).not_to have_css("#budget_#{budget.id}_results", text: "See results")
      end

      finished_budget1 = create(:budget, :finished)
      finished_budget2 = create(:budget, :finished)
      finished_budget3 = create(:budget, :finished)

      visit budgets_path

      expect(page).to have_css("#budget_#{finished_budget1.id}_results", text: "See results")
      expect(page).to have_css("#budget_#{finished_budget2.id}_results", text: "See results")
      expect(page).to have_css("#budget_#{finished_budget3.id}_results", text: "See results")
    end
  end

  context "Show" do

    it "is not accessible to normal users if phase is not 'finished'" do
      budget.update(phase: "reviewing_ballots")

      visit budget_results_path(budget.id)
      expect(page).to have_content "You do not have permission to carry out the action "\
                                   "'read_results' on budget."
    end

    it "is accessible to normal users if phase is 'finished'" do
      budget.update(phase: "finished")

      visit budget_results_path(budget.id)
      expect(page).to have_content "Results"
    end

    it "is accessible to administrators when budget has phase 'reviewing_ballots'" do
      budget.update(phase: "reviewing_ballots")

      login_as(create(:administrator).user)

      visit budget_results_path(budget.id)
      expect(page).to have_content "Results"
    end

    context "headings" do

      scenario "Displays headings ordered by name with city heading first" do
        allow_any_instance_of(Budget::Heading).to receive(:city_heading?) do |heading|
          heading.name == "City of New York"
        end

        budget.update(phase: "finished")

        city_group = create(:budget_group, budget: budget)
        district_group = create(:budget_group, budget: budget)

        create(:budget_heading, group: district_group, name: "Brooklyn")
        create(:budget_heading, group: district_group, name: "Queens")
        create(:budget_heading, group: district_group, name: "Manhattan")

        create(:budget_heading, group: city_group, name: "City of New York")

        visit budget_results_path(budget)

        within("#headings") do
          expect("City of New York").to appear_before("Brooklyn")
          expect("Brooklyn").to appear_before("Manhattan")
          expect("Manhattan").to appear_before("Queens")
        end
      end
    end

  end
end
