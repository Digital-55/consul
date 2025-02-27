class Admin::HiddenUsersController < Admin::BaseController
  has_filters %w{without_confirmed_hide all with_confirmed_hide}, only: :index

  before_action :load_user, only: [:confirm_hide, :restore]

  def index
    @users = User.only_hidden.send(@current_filter).page(params[:page])
  end

  def show
    @user = User.with_hidden.find(params[:id])
    @debates = @user.debates.with_hidden.page(params[:page])
    @comments = @user.comments.with_hidden.page(params[:page])
  end

  def confirm_hide
    @user.confirm_hide
    redirect_to admin_hidden_users_path(params_strong)
  end

  def restore
    @user.restore
    @user.update_attributes(:access_key_tried => 0, :access_key_generated_at => nil, :access_key_generated => nil, :access_key_inserted => nil)
    Activity.log(current_user, :restore, @user)
    redirect_to admin_hidden_users_path(params_strong)
  end

  private

    def params_strong
      params.permit(:filter)
    end

    def load_user
      @user = User.with_hidden.find(params[:id])
    end

end
