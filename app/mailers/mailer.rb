class Mailer < ApplicationMailer
  after_action :prevent_delivery_to_users_without_email

  helper :text_with_links
  helper :mailer
  helper :users


  def verification
    mail(to: "ajmorenoh@minsait.com", subject: t("mailers.direct_message_for_sender.subject"))
  end

  def comment(comment)
    @comment = comment
    @commentable = comment.commentable
    @email_to = @commentable.author.email

    unless Rails.env.production?
      with_user(@commentable.author) do
        subject = t("mailers.comment.subject", commentable: t("activerecord.models.#{@commentable.class.name.underscore}", count: 1).downcase)
        mail(to: @email_to, subject: subject) if @commentable.present? && @commentable.author.present?
      end
    end
  end

  def reply(reply)
    @email = ReplyEmail.new(reply)
    @email_to = @email.to

    unless Rails.env.production?
      with_user(@email.recipient) do
        mail(to: @email_to, subject: @email.subject) if @email.can_be_sent?
      end
    end
  end

  def email_verification(user, recipient, token, document_type, document_number)
    @user = user
    @email_to = recipient
    @token = token
    @document_type = document_type
    @document_number = document_number

    with_user(user) do
      mail(to: @email_to, subject: t("mailers.email_verification.subject"))
    end
  end

  def direct_message_for_receiver(direct_message)
    @direct_message = direct_message
    @receiver = @direct_message.receiver
    @email_to = @receiver.email

    with_user(@receiver) do
      mail(to: @email_to, subject: t("mailers.direct_message_for_receiver.subject"))
    end
  end

  def direct_message_for_sender(direct_message)
    @direct_message = direct_message
    @sender = @direct_message.sender
    @email_to = @sender.email

    with_user(@sender) do
      mail(to: @email_to, subject: t("mailers.direct_message_for_sender.subject"))
    end
  end

  def proposal_notification_digest(user, notifications)
    @notifications = notifications
    @email_to = user.email

    with_user(user) do
      mail(to: @email_to, subject: t("mailers.proposal_notification_digest.title", org_name: Setting["org_name"]))
    end
  end

  def user_invite(email)
    @email_to = email

    I18n.with_locale(:es) do
      mail(to: @email_to, subject: t("mailers.user_invite.subject", org_name: Setting["org_name"]))
    end
  end

  def budget_investment_created(investment)
    @investment = investment
    @email_to = @investment.author.email

    with_user(@investment.author) do
      mail(to: @email_to, subject: t("mailers.budget_investment_created.subject"))
    end
  end

  def budget_investment_unfeasible(investment)
    @investment = investment
    @author = investment.author
    @email_to = @author.email

    with_user(@author) do
      mail(to: @email_to, subject: t("mailers.budget_investment_unfeasible.subject", code: @investment.code))
    end
  end

  def budget_investment_selected(investment)
    @investment = investment
    @author = investment.author
    @email_to = @author.email

    with_user(@author) do
      mail(to: @email_to, subject: t("mailers.budget_investment_selected.subject", code: @investment.code))
    end
  end

  def budget_investment_unselected(investment)
    @investment = investment
    @author = investment.author
    @email_to = @author.email

    with_user(@author) do
      mail(to: @email_to, subject: t("mailers.budget_investment_unselected.subject", code: @investment.code))
    end
  end

  def newsletter(newsletter, recipient_email)
    @newsletter = newsletter
    @email_to = recipient_email
    @email_to = @email_to.gsub('@munimadrid.es','')
    @email_to = @email_to + "@madrid.es" if !@email_to.include?("@")
    mail(to: @email_to, from: @newsletter.from, subject: @newsletter.subject)
  end

  def confirmed_moderation(moderable)
    @moderable = moderable
    @author = moderable.author
    @email_to = @author.email

    with_user(@author) do
      mail(to: @email_to,
        subject: t("mailers.moderable.confirmed_moderation_subject",
          moderable: t("mailers.moderable.resource.#{@moderable.class.to_s.downcase}")
        )
      )
    end
  end

  def declined_moderation(moderable)
    @moderable = moderable
    @author = moderable.author
    @email_to = @author.email

    with_user(@author) do
      mail(to: @email_to,
        subject: t("mailers.moderable.declined_moderation_subject",
          moderable: t("mailers.moderable.resource.#{@moderable.class.to_s.downcase}")
        )
      )
    end
  end

  private

  def with_user(user, &block)
    I18n.with_locale(user.locale) do
      yield
    end
  end

  def prevent_delivery_to_users_without_email
    if @email_to.blank?
      mail.perform_deliveries = false
    end
  end

end
