class Dashboard::MailingController < Dashboard::BaseController
  def index
    authorize! :manage_mailing, proposal
  end

  def new
    authorize! :manage_mailing, proposal
  end

  def create
    authorize! :manage_mailing, proposal

    begin
      Dashboard::Mailer.forward(proposal).deliver_now!
    rescue => e
      begin
        Rails.logger.error("ERROR-MAILER: #{e}")
      rescue
      end
    end
    redirect_to new_proposal_dashboard_mailing_path(proposal),
                flash: { notice: t("dashboard.mailing.create.sent") }
  end
end
