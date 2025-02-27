require "rails_helper"

describe "Users" do

  context "Regular authentication" do
    context "Sign up" do

      scenario "Success" do
        message = "You have been sent a message containing a verification link. Please click on this link to activate your account."
        visit "/"
        click_link "Register"

        fill_in "user_username",              with: "Manuela Carmena"
        fill_in "user_email",                 with: "manuela@consul.dev"
        fill_in "user_password",              with: Rails.application.secrets.password_hidden
        fill_in "user_password_confirmation", with: Rails.application.secrets.password_hidden
        check "user_terms_of_service"

        click_button "Register"

        expect(page).to have_content message

        confirm_email

        expect(page).to have_content "Your account has been confirmed."
      end

      scenario "Errors on sign up" do
        visit "/"
        click_link "Register"
        click_button "Register"

        expect(page).to have_content error_message
      end

      scenario "Sign up on Landing" do
        visit new_user_registration_path(landing: "change-your-city")

        expect(page).to have_css("body.landing-change-your-city")
      end

    end

    context "Sign in" do

      scenario "sign in with email" do
        create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden)

        visit "/"
        click_link "Sign in"
        fill_in "user_login",    with: "manuela@consul.dev"
        fill_in "user_password", with: Rails.application.secrets.password_hidden
        click_button "Enter"

        expect(page).to have_content "You have been signed in successfully."
      end

      scenario "Sign in with username" do
        create(:user, username: "👻👽👾🤖", email: "ash@nostromo.dev", password: "xenomorph")

        visit "/"
        click_link "Sign in"
        fill_in "user_login",    with: "👻👽👾🤖"
        fill_in "user_password", with: "xenomorph"
        click_button "Enter"

        expect(page).to have_content "You have been signed in successfully."
      end

      scenario "Avoid username-email collisions" do
        u1 = create(:user, username: "Spidey", email: "peter@nyc.dev", password: "greatpower")
        u2 = create(:user, username: "peter@nyc.dev", email: "venom@nyc.dev", password: "symbiote")

        visit "/"
        click_link "Sign in"
        fill_in "user_login",    with: "peter@nyc.dev"
        fill_in "user_password", with: "greatpower"
        click_button "Enter"

        expect(page).to have_content "You have been signed in successfully."

        visit account_path

        expect(page).to have_link "My content", href: user_path(u1)

        visit "/"
        click_link "Sign out"

        expect(page).to have_content "You have been signed out successfully."

        click_link "Sign in"
        fill_in "user_login",    with: "peter@nyc.dev"
        fill_in "user_password", with: "symbiote"
        click_button "Enter"

        expect(page).not_to have_content "You have been signed in successfully."
        expect(page).to have_content "Invalid Email or username or password."

        fill_in "user_login",    with: "venom@nyc.dev"
        fill_in "user_password", with: "symbiote"
        click_button "Enter"

        expect(page).to have_content "You have been signed in successfully."

        visit account_path

        expect(page).to have_link "My content", href: user_path(u2)
      end

      scenario "counts failed attempts" do
        user = create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden)
        expect(user.failed_attempts).to be 0

        visit user_session_path
        fill_in "user_login",    with: "manuela@consul.dev"
        fill_in "user_password", with: "wrong_password"
        click_button "Enter"

        expect(page).to have_content "Invalid Email or username or password."
        expect(user.reload.failed_attempts).to be 1
      end

      scenario "resets failed attempts after successful login" do
        user = create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden, failed_attempts: 3)

        visit user_session_path
        fill_in "user_login",    with: "manuela@consul.dev"
        fill_in "user_password", with: Rails.application.secrets.password_hidden
        click_button "Enter"

        expect(page).to have_content "You have been signed in successfully."
        expect(user.reload.failed_attempts).to be 0
      end

      scenario "never shows recaptcha by default" do
        create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden, failed_attempts: 1000)

        visit user_session_path
        fill_in "user_login",    with: "manuela@consul.dev"
        fill_in "user_password", with: Rails.application.secrets.password_hidden

        expect(page).not_to have_css ".recaptcha"
      end

      context "with recaptcha" do

        before do
          Setting["feature.captcha"] = true
        end

        scenario "shows recaptcha only after consecutive failed attempts", :js do
          create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden, failed_attempts: 4)

          visit new_user_session_path

          fill_in "user_login",    with: "manuela@consul.dev"
          fill_in "user_password", with: "wrong_password"

          expect(page).not_to have_css ".recaptcha"

          click_button "Enter"
          expect(page).to have_content "Invalid Email or username or password."

          fill_in "user_login",    with: "manuela@consul.dev"
          fill_in "user_password", with: "wrong_password"

          expect(page).to have_css ".recaptcha"
        end

        scenario "unchecked recaptcha with correct login details", :js do
          allow_any_instance_of(Users::SessionsController).to receive(:verify_recaptcha).and_return false
          create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden, failed_attempts: 5)

          visit new_user_session_path

          fill_in "user_login",    with: "manuela@consul.dev"
          fill_in "user_password", with: Rails.application.secrets.password_hidden

          click_button "Enter"
          expect(page).to have_content "reCAPTCHA human verification is missing. please try again."
        end

        scenario "checked recaptcha with incorrect login details", :js do
          create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden, failed_attempts: 5)

          visit new_user_session_path

          fill_in "user_login",    with: "manuela@consul.dev"
          fill_in "user_password", with: "wrong_password"

          click_button "Enter"
          expect(page).to have_content "Invalid Email or username or password."
        end

        scenario "checked recaptcha with correct login details", :js do
          create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden, failed_attempts: 5)

          visit new_user_session_path

          fill_in "user_login",    with: "manuela@consul.dev"
          fill_in "user_password", with: Rails.application.secrets.password_hidden

          click_button "Enter"
          expect(page).to have_content "You have been signed in successfully."
        end
      end
    end
  end

  context "OAuth authentication" do
    context "Twitter" do

      let(:twitter_hash){ {provider: "twitter", uid: "12345", info: {name: "manuela"}} }
      let(:twitter_hash_with_email){ {provider: "twitter", uid: "12345", info: {name: "manuela", email: "manuelacarmena@example.com"}} }
      let(:twitter_hash_with_verified_email) do
        {
          provider: "twitter",
          uid: "12345",
          info: {
            name: "manuela",
            email: "manuelacarmena@example.com",
            verified: "1"
          }
        }
      end

      scenario "Sign up when Oauth provider has a verified email" do
        OmniAuth.config.add_mock(:twitter, twitter_hash_with_verified_email)

        visit "/"
        click_link "Register"

        click_link "Sign up with Twitter"

        expect_to_be_signed_in

        click_link "My account"
        expect(page).to have_field("account_username", with: "manuela")

        visit edit_user_registration_path
        expect(page).to have_field("user_email", with: "manuelacarmena@example.com")
      end

      scenario "Sign up when Oauth provider has an unverified email" do
        OmniAuth.config.add_mock(:twitter, twitter_hash_with_email)

        visit "/"
        click_link "Register"

        click_link "Sign up with Twitter"

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content "To continue, please click on the confirmation link that we have sent you via email"

        confirm_email
        expect(page).to have_content "Your account has been confirmed"

        visit "/"
        click_link "Sign in"
        click_link "Sign in with Twitter"
        expect_to_be_signed_in

        click_link "My account"
        expect(page).to have_field("account_username", with: "manuela")

        visit edit_user_registration_path
        expect(page).to have_field("user_email", with: "manuelacarmena@example.com")
      end

      scenario "Sign up, when no email was provided by OAuth provider" do
        OmniAuth.config.add_mock(:twitter, twitter_hash)

        visit "/"
        click_link "Register"
        click_link "Sign up with Twitter"

        expect(page).to have_current_path(finish_signup_path)
        fill_in "user_email", with: "manueladelascarmenas@example.com"
        click_button "Register"

        expect(page).to have_content "To continue, please click on the confirmation link that we have sent you via email"

        confirm_email
        expect(page).to have_content "Your account has been confirmed"

        visit "/"
        click_link "Sign in"
        click_link "Sign in with Twitter"
        expect_to_be_signed_in

        click_link "My account"
        expect(page).to have_field("account_username", with: "manuela")

        visit edit_user_registration_path
        expect(page).to have_field("user_email", with: "manueladelascarmenas@example.com")
      end

      scenario "Cancelling signup" do
        OmniAuth.config.add_mock(:twitter, twitter_hash)

        visit "/"
        click_link "Register"
        click_link "Sign up with Twitter"

        expect(page).to have_current_path(finish_signup_path)
        click_link "Cancel login"

        visit "/"
        expect_not_to_be_signed_in
      end

      scenario "Sign in, user was already signed up with OAuth" do
        user = create(:user, email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden)
        create(:identity, uid: "12345", provider: "twitter", user: user)
        OmniAuth.config.add_mock(:twitter, twitter_hash)

        visit "/"
        click_link "Sign in"
        click_link "Sign in with Twitter"

        expect_to_be_signed_in

        click_link "My account"
        expect(page).to have_field("account_username", with: user.username)

        visit edit_user_registration_path
        expect(page).to have_field("user_email", with: user.email)

      end

      scenario "Try to register with the username of an already existing user" do
        create(:user, username: "manuela", email: "manuela@consul.dev", password: Rails.application.secrets.password_hidden)
        OmniAuth.config.add_mock(:twitter, twitter_hash_with_verified_email)

        visit "/"
        click_link "Register"
        click_link "Sign up with Twitter"

        expect(page).to have_current_path(finish_signup_path)

        expect(page).to have_field("user_username", with: "manuela")

        click_button "Register"

        expect(page).to have_current_path(do_finish_signup_path)

        fill_in "user_username", with: "manuela2"
        click_button "Register"

        expect_to_be_signed_in

        click_link "My account"
        expect(page).to have_field("account_username", with: "manuela2")

        visit edit_user_registration_path
        expect(page).to have_field("user_email", with: "manuelacarmena@example.com")
      end

      scenario "Try to register with the email of an already existing user, when no email was provided by oauth" do
        create(:user, username: "peter", email: "manuela@example.com")
        OmniAuth.config.add_mock(:twitter, twitter_hash)

        visit "/"
        click_link "Register"
        click_link "Sign up with Twitter"

        expect(page).to have_current_path(finish_signup_path)

        fill_in "user_email", with: "manuela@example.com"
        click_button "Register"

        expect(page).to have_current_path(do_finish_signup_path)

        fill_in "user_email", with: "somethingelse@example.com"
        click_button "Register"

        expect(page).to have_content "To continue, please click on the confirmation link that we have sent you via email"

        confirm_email
        expect(page).to have_content "Your account has been confirmed"

        visit "/"
        click_link "Sign in"
        click_link "Sign in with Twitter"
        expect_to_be_signed_in

        click_link "My account"
        expect(page).to have_field("account_username", with: "manuela")

        visit edit_user_registration_path
        expect(page).to have_field("user_email", with: "somethingelse@example.com")
      end

      scenario "Try to register with the email of an already existing user, when an unconfirmed email was provided by oauth" do
        create(:user, username: "peter", email: "manuelacarmena@example.com")
        OmniAuth.config.add_mock(:twitter, twitter_hash_with_email)

        visit "/"
        click_link "Register"
        click_link "Sign up with Twitter"

        expect(page).to have_current_path(finish_signup_path)

        expect(page).to have_field("user_email", with: "manuelacarmena@example.com")
        fill_in "user_email", with: "somethingelse@example.com"
        click_button "Register"

        expect(page).to have_content "To continue, please click on the confirmation link that we have sent you via email"

        confirm_email
        expect(page).to have_content "Your account has been confirmed"

        visit "/"
        click_link "Sign in"
        click_link "Sign in with Twitter"
        expect_to_be_signed_in

        click_link "My account"
        expect(page).to have_field("account_username", with: "manuela")

        visit edit_user_registration_path
        expect(page).to have_field("user_email", with: "somethingelse@example.com")
      end
    end
  end

  scenario "Sign out" do
    user = create(:user)
    login_as(user)

    visit "/"
    click_link "Sign out"

    expect(page).to have_content "You have been signed out successfully."
  end

  scenario "Reset password" do
    create(:user, email: "manuela@consul.dev")

    visit "/"
    click_link "Sign in"
    click_link "Forgotten your password?"

    fill_in "user_email", with: "manuela@consul.dev"
    click_button "Send instructions"

    expect(page).to have_content "If your email address is in our database, in a few minutes "\
                                 "you will receive a link to use to reset your password."

    action_mailer = ActionMailer::Base.deliveries.last.body.to_s
    sent_token = /.*reset_password_token=(.*)".*/.match(action_mailer)[1]
    visit edit_user_password_path(reset_password_token: sent_token)

    fill_in "user_password", with: "new password"
    fill_in "user_password_confirmation", with: "new password"
    click_button "Change my password"

    expect(page).to have_content "Your password has been changed successfully."
  end

  scenario "Reset password with unexisting email" do
    visit "/"
    click_link "Sign in"
    click_link "Forgotten your password?"

    fill_in "user_email", with: "fake@mail.dev"
    click_button "Send instructions"

    expect(page).to have_content "If your email address is in our database, in a few minutes "\
                                 "you will receive a link to use to reset your password."

  end

  scenario "Re-send confirmation instructions" do
    create(:user, email: "manuela@consul.dev")

    visit "/"
    click_link "Sign in"
    click_link "Haven't received instructions to activate your account?"

    fill_in "user_email", with: "manuela@consul.dev"
    click_button "Re-send instructions"

    expect(page).to have_content "If your email address is in our database, in a few minutes you "\
                                 "will receive an email containing instructions on how to reset "\
                                 "your password."
  end

  scenario "Re-send confirmation instructions with unexisting email" do
    visit "/"
    click_link "Sign in"
    click_link "Haven't received instructions to activate your account?"

    fill_in "user_email", with: "fake@mail.dev"
    click_button "Re-send instructions"

    expect(page).to have_content "If your email address is in our database, in a few minutes you "\
                                 "will receive an email containing instructions on how to reset "\
                                 "your password."
  end

  scenario "Sign in, admin with password expired" do
    user = create(:user, password_changed_at: Time.current - 1.year)
    admin = create(:administrator, user: user)

    login_as(admin.user)
    visit root_path

    expect(page).to have_content "Your password is expired"

    fill_in "user_current_password", with: "judgmentday"
    fill_in "user_password", with: "123456789"
    fill_in "user_password_confirmation", with: "123456789"

    click_button "Change your password"

    expect(page).to have_content "Password successfully updated"
  end

  scenario "Sign in, admin without password expired" do
    user = create(:user, password_changed_at: Time.current - 360.days)
    admin = create(:administrator, user: user)

    login_as(admin.user)
    visit root_path

    expect(page).not_to have_content "Your password is expired"
  end

  scenario "Sign in, user with password expired" do
    user = create(:user, password_changed_at: Time.current - 1.year)

    login_as(user)
    visit root_path

    expect(page).not_to have_content "Your password is expired"
  end

  scenario "Admin with password expired trying to use same password" do
    user = create(:user, password_changed_at: Time.current - 1.year, password: "123456789")
    admin = create(:administrator, user: user)

    login_as(admin.user)
    visit root_path

    expect(page).to have_content "Your password is expired"

    fill_in "user_current_password", with: "judgmentday"
    fill_in "user_password", with: "123456789"
    fill_in "user_password_confirmation", with: "123456789"
    click_button "Change your password"

    expect(page).to have_content "must be different than the current password."
  end

end
