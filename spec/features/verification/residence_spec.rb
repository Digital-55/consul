require "rails_helper"

describe "Residence" do

  let!(:geozone) { create(:geozone) }

  scenario "Verify resident" do
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select_date "31-December-1980", from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "28013"
    check "residence_terms_of_service"
    click_button "Verify residence"

    expect(page).to have_content "Residence verified"
  end

  scenario "Residence form use min age to participate" do
    min_age = (Setting["min_age_to_participate"] = 16).to_i
    underage = min_age - 1
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    expect(page).to have_select("residence_date_of_birth_1i",
                                 with_options: [min_age.years.ago.year])
    expect(page).not_to have_select("residence_date_of_birth_1i",
                                     with_options: [underage.years.ago.year])
  end

  scenario "User document matches census API document" do
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    fill_in "residence_document_number", with: "000012345678Z"
    select "DNI", from: "residence_document_type"
    select_date "31-December-1980", from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "28013"
    check "residence_terms_of_service"
    click_button "Verify residence"

    expect(page).to have_content "Residence verified"
    expect(user.reload.document_number).to eq("12345678Z")

  end

  scenario "Initialize the redeemable code with the user redeemable code" do
    user = create(:user, redeemable_code: "abcde")
    login_as(user)

    visit account_path
    click_link "Verify my account"

    expect(page).to have_field "residence_redeemable_code", with: "abcde"
  end

  scenario "Verify a resident in Madrid with a redeemable code" do
    code = create(:redeemable_code)
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select_date "31-December-1980", from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "28013"
    fill_in "residence_redeemable_code", with: code.token

    check "residence_terms_of_service"

    click_button "Verify residence"

    expect(page).to have_content "Your account is already verified"
  end

  scenario "When trying to verify a deregistered account old votes are reassigned" do
    erased_user = create(:user, document_number: "12345678Z", document_type: "1", erased_at: Time.current)
    vote = create(:vote, voter: erased_user)
    new_user = create(:user)

    login_as(new_user)

    visit account_path
    click_link "Verify my account"

    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select_date "31-December-1980", from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "28013"
    check "residence_terms_of_service"

    click_button "Verify residence"

    expect(page).to have_content "Residence verified"

    expect(vote.reload.voter).to eq(new_user)
    expect(erased_user.reload.document_number).to be_blank
    expect(new_user.reload.document_number).to eq("12345678Z")
  end

  scenario "Error on verify" do
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    click_button "Verify residence"

    expect(page).to have_content(/\d errors? prevented the verification of your residence/)
  end

  scenario "Error on postal code not in census" do
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select "1997", from: "residence_date_of_birth_1i"
    select "January", from: "residence_date_of_birth_2i"
    select "1", from: "residence_date_of_birth_3i"
    fill_in "residence_postal_code", with: "12345"
    check "residence_terms_of_service"

    click_button "Verify residence"

    expect(page).to have_content "In order to be verified, you must be registered in "\
                                 "the municipality of Madrid"
  end

  scenario "Error on census" do
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select "1997", from: "residence_date_of_birth_1i"
    select "January", from: "residence_date_of_birth_2i"
    select "1", from: "residence_date_of_birth_3i"
    fill_in "residence_postal_code", with: "28013"
    check "residence_terms_of_service"

    click_button "Verify residence"

    expect(page).to have_content "The Madrid Census was unable to verify your information"
  end

  scenario "5 tries allowed" do
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    5.times do
      fill_in "residence_document_number", with: "12345678Z"
      select "DNI", from: "residence_document_type"
      select "1997", from: "residence_date_of_birth_1i"
      select "January", from: "residence_date_of_birth_2i"
      select "1", from: "residence_date_of_birth_3i"
      fill_in "residence_postal_code", with: "28013"
      check "residence_terms_of_service"

      click_button "Verify residence"
      expect(page).to have_content "The Madrid Census was unable to verify your information"
    end

    click_button "Verify residence"
    expect(page).to have_content "You have reached the maximum number of attempts. Please try again later."
    expect(page).to have_current_path(account_path)

    visit new_residence_path
    expect(page).to have_content "You have reached the maximum number of attempts. Please try again later."
    expect(page).to have_current_path(account_path)
  end
end
