require "rails_helper"

describe "System Emails" do

  let(:admin) { create(:administrator) }

  before do
    login_as(admin.user)
  end

  context "Index" do

    let(:system_emails_with_preview) { %w[proposal_notification_digest] }
    let(:system_emails) do
      %w[proposal_notification_digest budget_investment_created budget_investment_selected
         budget_investment_unfeasible budget_investment_unselected comment reply
         direct_message_for_receiver direct_message_for_sender email_verification user_invite]
    end

    context "System emails" do

      scenario "have 'View' button" do
        visit admin_system_emails_path

        system_emails.each do |email_id|
          within("##{email_id}") do
            expect(page).to have_link("View", href: admin_system_email_view_path(email_id))
          end
        end
      end

    end

    context "System emails with preview" do

      scenario "have 'Preview Pending' and 'Send pending' buttons" do
        visit admin_system_emails_path

        system_emails_with_preview.each do |email_id|
          within("##{email_id}") do
            expect(page).to have_link("Preview Pending",
                                      href: admin_system_email_preview_pending_path(email_id))
            expect(page).to have_link("Send pending",
                                      href: admin_system_email_send_pending_path(email_id))

            expect(page).not_to have_content "You can edit this email in"
            expect(page).not_to have_content "app/views/mailer/#{email_id}.html.erb"
          end
        end
      end

    end

    context "System emails with info" do

      scenario "have information about how to edit the email templates" do
        visit admin_system_emails_path

        system_emails_with_info = system_emails - system_emails_with_preview
        system_emails_with_info.each do |email_id|
          within("##{email_id}") do
            expect(page).to have_content "You can edit this email in"
            expect(page).to have_content "app/views/mailer/#{email_id}.html.erb"

            expect(page).not_to have_link "Preview Pending"
            expect(page).not_to have_link "Send pending"
          end
        end
      end
    end

  end

  context "View" do

    let(:user)    { create(:user, :level_two, username: "John Doe") }
    let(:budget)  { create(:budget, name: "Budget for 2019") }
    let(:group)   { create(:budget_group, budget: budget) }
    let(:heading) { create(:budget_heading, group: group) }

    scenario "#proposal_notification_digest" do
      proposal_a = create(:proposal, title: "Proposal A")
      proposal_b = create(:proposal, title: "Proposal B")
      proposal_notification_a = create(:proposal_notification, proposal: proposal_a,
                                                               title: "Proposal A Title",
                                                               body: "Proposal A Notification Body")
      proposal_notification_b = create(:proposal_notification, proposal: proposal_b,
                                                               title: "Proposal B Title",
                                                               body: "Proposal B Notification Body")
      create(:notification, notifiable: proposal_notification_a)
      create(:notification, notifiable: proposal_notification_b)

      visit admin_system_email_view_path("proposal_notification_digest")

      expect(page).to have_content("Proposal notifications in")
      expect(page).to have_link("Proposal A Title", href: proposal_url(proposal_a,
                                                    anchor: "tab-notifications"))
      expect(page).to have_link("Proposal B Title", href: proposal_url(proposal_b,
                                                    anchor: "tab-notifications"))
      expect(page).to have_content("Proposal A Notification Body")
      expect(page).to have_content("Proposal B Notification Body")
    end

    scenario "#budget_investment_created" do
      investment = create(:budget_investment, title: "Cleaner city", heading: heading, author: user)

      visit admin_system_email_view_path("budget_investment_created")

      expect(page).to have_content "Thank you for creating an investment!"
      expect(page).to have_content "John Doe"
      expect(page).to have_content "Cleaner city"
      expect(page).to have_content "Budget for 2019"

      expect(page).to have_link "Participatory Budgets", href: budgets_url

      share_url = budget_investment_url(budget, investment, anchor: "social-share")
      expect(page).to have_link "Share your project", href: share_url
    end

    scenario "#budget_investment_selected" do
      investment = create(:budget_investment, title: "Cleaner city", heading: heading, author: user)

      visit admin_system_email_view_path("budget_investment_selected")

      expect(page).to have_content "Your investment project '#{investment.code}' has been selected"
      expect(page).to have_content "Start to get votes, share your investment project"

      share_url = budget_investment_url(budget, investment, anchor: "social-share")
      expect(page).to have_link "Share your investment project", href: share_url
    end

    scenario "#budget_investment_unfeasible" do
      investment = create(:budget_investment, title: "Cleaner city", heading: heading, author: user)

      visit admin_system_email_view_path("budget_investment_unfeasible")

      expect(page).to have_content "Your investment project '#{investment.code}' "
      expect(page).to have_content "has been marked as unfeasible"
      expect(page).to have_content "believe that the rejected investment meets the requirements"
      expect(page).to have_content "you can communicate this"
      expect(page).to have_content "Including the code #{investment.code} in the subject"
    end

    scenario "#budget_investment_unselected" do
      investment = create(:budget_investment, title: "Cleaner city", heading: heading, author: user)

      visit admin_system_email_view_path("budget_investment_unselected")

      expect(page).to have_content "Your investment project '#{investment.code}' "
      expect(page).to have_content "has not been selected"
      expect(page).to have_content "Thank you again for participating."
    end

    scenario "#comment" do
      debate = create(:debate, title: "Let's do...", author: user)

      commenter = create(:user)
      comment = create(:comment, commentable: debate, author: commenter)

      visit admin_system_email_view_path("comment")

      expect(page).to have_content "Someone has commented on your Debate"
      expect(page).to have_content "Hi John Doe,"
      expect(page).to have_content "There is a new comment from #{commenter.name}"
      expect(page).to have_content comment.body

      expect(page).to have_link "Let's do...", href: debate_url(debate)
    end

    scenario "#reply" do
      debate = create(:debate, title: "Let's do...", author: user)
      comment = create(:comment, commentable: debate, author: user)

      replier = create(:user)
      reply = create(:comment, commentable: debate, parent: comment, author: replier)

      visit admin_system_email_view_path("reply")

      expect(page).to have_content "Someone has responded to your comment"
      expect(page).to have_content "Hi John Doe,"
      expect(page).to have_content "There is a new response from #{replier.name}"
      expect(page).to have_content reply.body

      expect(page).to have_link "Let's do...", href: comment_url(reply)
    end

    scenario "#direct_message_for_receiver" do
      visit admin_system_email_view_path("direct_message_for_receiver")

      expect(page).to have_content "You have received a new private message"
      expect(page).to have_content "Message's Title"
      expect(page).to have_content "This is a sample of message's content."

      expect(page).to have_link "Reply to #{admin.user.name}", href: user_url(admin.user)
    end

    scenario "#direct_message_for_sender" do
      visit admin_system_email_view_path("direct_message_for_sender")

      expect(page).to have_content "You have sent a new private message to #{admin.user.name}"
      expect(page).to have_content "Message's Title"
      expect(page).to have_content "This is a sample of message's content."
    end

    scenario "#email_verification" do
      create(:user, confirmed_at: nil, email_verification_token: "abc")

      visit admin_system_email_view_path("email_verification")

      expect(page).to have_content "Confirm your account using the following link"

      expect(page).to have_link "this link", href: email_url(email_verification_token: "abc")
    end

    scenario "#user_invite" do
      visit admin_system_email_view_path("user_invite")

      expect(page).to have_content "Invitation to Decide Madrid"
      expect(page).to have_content "Thank you for applying to join Decide Madrid!"

      registration_url = new_user_registration_url(track_id: 172943750183759812)
      expect(page).to have_link "Complete registration", href: registration_url
    end

    scenario "show flash message if there is no sample data to render the email" do
      visit admin_system_email_view_path("budget_investment_created")
      expect(page).to have_content "There aren't any budget investment created."
      expect(page).to have_content "Some example data is needed in order to preview the email."

      visit admin_system_email_view_path("budget_investment_selected")
      expect(page).to have_content "There aren't any budget investment created."
      expect(page).to have_content "Some example data is needed in order to preview the email."

      visit admin_system_email_view_path("budget_investment_unfeasible")
      expect(page).to have_content "There aren't any budget investment created."
      expect(page).to have_content "Some example data is needed in order to preview the email."

      visit admin_system_email_view_path("budget_investment_unselected")
      expect(page).to have_content "There aren't any budget investment created."
      expect(page).to have_content "Some example data is needed in order to preview the email."

      visit admin_system_email_view_path("comment")
      expect(page).to have_content "There aren't any comments created."
      expect(page).to have_content "Some example data is needed in order to preview the email."

      visit admin_system_email_view_path("reply")
      expect(page).to have_content "There aren't any replies created."
      expect(page).to have_content "Some example data is needed in order to preview the email."
    end

    context "Moderated Content" do
      let(:vulgar) { create(:moderated_text, text: "vulgar") }
      let!(:comment) { create(:comment, body: "vulgar comment", author: user) }
      let!(:offense) { create(:moderated_content, moderable: comment, moderated_text: vulgar) }

      scenario "#confirmed_moderation" do
        visit admin_system_email_view_path("confirmed_moderation")

        expect(page).to have_content "Your comment has been deemed offensive to the community."
        expect(page).to have_content "Your comment has been deemed offensive to the community, and won't be shown publicly."
        expect(page).to have_content "vulgar"
      end

      scenario "#declined_moderation" do
        visit admin_system_email_view_path("declined_moderation")

        expect(page).to have_content "Your comment has been deemed not offensive to the community."
        expect(page).to have_content "Your comment has been deemed not offensive to the community, and will be shown publicly soon."
        expect(page).to have_content "vulgar"
      end
    end
  end

  context "Preview Pending" do
    scenario "#proposal_notification_digest" do
      proposal_a = create(:proposal, title: "Proposal A")
      proposal_b = create(:proposal, title: "Proposal B")
      proposal_notification_a = create(:proposal_notification, proposal: proposal_a,
                                                               title: "Proposal A Title",
                                                               body: "Proposal A Notification Body")
      proposal_notification_b = create(:proposal_notification, proposal: proposal_b,
                                                               title: "Proposal B Title",
                                                               body: "Proposal B Notification Body")
      create(:notification, notifiable: proposal_notification_a, emailed_at: nil)
      create(:notification, notifiable: proposal_notification_b, emailed_at: nil)

      visit admin_system_email_preview_pending_path("proposal_notification_digest")

      expect(page).to have_content("This is the content pending to be sent")
      expect(page).to have_link("Proposal A", href: proposal_url(proposal_a))
      expect(page).to have_link("Proposal B", href: proposal_url(proposal_b))
      expect(page).to have_link("Proposal A Title", href: proposal_url(proposal_a,
                                                    anchor: "tab-notifications"))
      expect(page).to have_link("Proposal B Title", href: proposal_url(proposal_b,
                                                    anchor: "tab-notifications"))
    end

    scenario "#moderate_pending" do
      proposal1 = create(:proposal, title: "Proposal A")
      proposal2 = create(:proposal, title: "Proposal B")
      proposal_notification1 = create(:proposal_notification, proposal: proposal1,
                                                               title: "Proposal A Title",
                                                               body: "Proposal A Notification Body")
      proposal_notification2 = create(:proposal_notification, proposal: proposal2)
      create(:notification, notifiable: proposal_notification1, emailed_at: nil)
      create(:notification, notifiable: proposal_notification2, emailed_at: nil)

      visit admin_system_email_preview_pending_path("proposal_notification_digest")

      within("#proposal_notification_#{proposal_notification1.id}") do
        click_on "Moderate notification send"
      end

      visit admin_system_email_preview_pending_path("proposal_notification_digest")

      expect(Notification.count).to equal(1)
      expect(Activity.last.actionable_type).to eq("ProposalNotification")
      expect(page).not_to have_content("Proposal A Title")
    end

    scenario "#send_pending" do
      proposal = create(:proposal)
      proposal_notification = create(:proposal_notification, proposal: proposal,
                                                              title: "Proposal A Title",
                                                              body: "Proposal A Notification Body")
      voter = create(:user, :level_two)
      create(:notification, notifiable: proposal_notification, user: voter, emailed_at: nil)
      create(:follow, user: voter, followable: proposal)

      visit admin_system_emails_path

      click_on "Send pending"

      email = open_last_email
      expect(email).to deliver_to(voter)
      expect(email).to have_body_text(proposal_notification.body)

      expect(page).to have_content("Pending notifications sent succesfully")
    end
  end

end
