class Admin::OfficialsController < Admin::BaseController
  has_filters %w[users superadministrators administrators sures_administrators section_administrators 
    organizations officials moderators valuators managers consultants editors editors_parbudget readers_parbudget  ]

  def index
    @officials = User.officials.page(params[:page]).for_render
  end

  def search
    @users = User.search(params[:name_or_email]).page(params[:page]).for_render
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to admin_officials_path, notice: t("admin.officials.flash.official_updated")
  end

  def destroy
    @official = User.officials.find(params[:id])
    @official.remove_official_position!
    redirect_to admin_officials_path, notice: t("admin.officials.flash.official_destroyed")
  end

  private

    def user_params
      params.require(:user).permit(:official_position, :official_level)
    end

end