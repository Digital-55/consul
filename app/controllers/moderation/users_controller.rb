class Moderation::UsersController < Moderation::BaseController

  before_action :load_users, only: :index

  load_and_authorize_resource

  def index
  end

  def hide_in_moderation_screen
    block_user
    redirect_to moderation_users_path(params_strong), notice: I18n.t("moderation.users.notice_hide")
   end

  def hide
    block_user

    redirect_to debates_path
  end

  private
    def params_strong
      params.permit(:name_or_email)
    end

    def load_users
      @users = User.with_hidden.search(params[:name_or_email]).page(params[:page]).for_render
    end

    def block_user
      @user.block
      Activity.log(current_user, :block, @user)
    end

end
