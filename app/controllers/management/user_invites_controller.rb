class Management::UserInvitesController < Management::BaseController

  def new
  end

  def create
    @emails = params[:emails].split(",").map(&:strip)
    @emails.each do |email|
      ahoy.track(:user_invite, email: email) rescue nil
      begin
        Mailer.user_invite(email).deliver_now!
      rescue => e
        begin
          Rails.logger.error("ERROR-MAILER: #{e}")
        rescue
        end
      end
    end
  end

end