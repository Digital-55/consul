class Admin::Sures::ActuationsController < Admin::Sures::BaseController
  include Translatable

  before_action :load_resources, only: [:new,:edit,:create,:update]
  before_action :load_districts, only: [:new,:edit,:create,:update]
  has_filters %w[all study tramit process fhinish], only: :index

  load_and_authorize_resource :actuation, class: "Sures::Actuation"
  
  def index
    @actuations = ::Sures::Actuation.send(@current_filter).order(proposal_title: :desc)
                  .page(params[:page])
  end

  def create
    #@actuation.geozone = Proposal.find_by(comunity_hide: :true, title: @actuation.borought).try(:geozone)
    if @actuation.save
      notice = t("admin.sures.actuations.create.notice", link: actuation_sure_path(@actuation).html_safe)
      redirect_to edit_admin_sures_actuation_path(@actuation), notice: notice
    else
      flash.now[:error] = t("admin.sures.actuations.create.error")
      render :new
    end
  end

  def update
    if @actuation.update(actuation_params)
      #@actuation.geozone = Proposal.find_by(comunity_hide: :true, title: @actuation.borought).try(:geozone)
      @actuation.save
      notice = t("admin.sures.actuations.update.notice", link: actuation_sure_path(@actuation).html_safe)
      redirect_to edit_admin_sures_actuation_path(@actuation), notice: notice
    else
      flash.now[:error] = t("admin.sures.actuations.update.error")
      render :edit
    end
  end

  def destroy
    @actuation.destroy
    notice = t("admin.sures.actuations.destroy.notice")
    redirect_to admin_sures_actuations_path, notice: notice
  end

  private

    def actuation_params
      params.require(:sures_actuation).permit(allowed_params, :actuations_multi_years_attributes => [:id, :annos, :values, :_destroy])
    end

    def allowed_params
      [
        :proposal_title,
        :proposal_objective,
        :territorial_scope,
        :location_performance,
        :technical_visibility,
        :action_taken,
        :status,
        :financig_performance,
        :check_anno,
        :check_multianno,
        :annos,
        :tracking,
        :other,
        :borought,
        :project,
        translation_params(::Sures::Actuation),
        :geozones => []
      ]
    end

    def resource
      @actuation || ::Sures::Actuation.find(params[:id])
    end

    def load_resources
      @boroughts = {}
      Proposal.all.where(comunity_hide: :true).each do |borought|
        @boroughts.merge!({"#{borought.title} (#{borought.try(:geozone).try(:name)})" => borought.title })
      end
    end

    def load_districts
      @districts ={}
      @districts.merge!({"SURES(Todos)" => Geozone.find_by(name: "Toda la ciudad").id})
      Geozone.all.order(name: :asc).each do |g|
        @districts.merge!({g.name == "Toda la ciudad" ? "SURES(Todos)" : g.name => g.id}) if g.name != 'city' && g.name != "Toda la ciudad"
      end
    end
end
