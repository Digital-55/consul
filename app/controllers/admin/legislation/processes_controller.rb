class Admin::Legislation::ProcessesController < Admin::Legislation::BaseController
  include Translatable
  include ImageAttributes

  has_filters %w[active all], only: :index

  load_and_authorize_resource :process, class: "Legislation::Process"

  before_action :load_geozones, only: [:new, :create, :edit, :update]

  def index
    @processes = ::Legislation::Process.send(@current_filter).order(start_date: :desc)
                 .page(params[:page])
  end

  def create
    if @process.save
      link = legislation_process_path(@process).html_safe
      notice = t("admin.legislation.processes.create.notice", link: link)
      redirect_to edit_admin_legislation_process_path(@process), notice: notice
    else
      flash.now[:error] = t("admin.legislation.processes.create.error")
      render :new
    end
  end

  def update
    if @process.update(process_params)
      set_tag_list

      link = legislation_process_path(@process).html_safe
      redirect_back(fallback_location: (request.referrer || root_path),
                    notice: t("admin.legislation.processes.update.notice", link: link))
    else
      flash.now[:error] = t("admin.legislation.processes.update.error")
      render :edit
    end
  end

  def destroy
    @process.destroy
    notice = t("admin.legislation.processes.destroy.notice")
    redirect_to admin_legislation_processes_path, notice: notice
  end

  private

    def process_params
      params.require(:legislation_process).permit(allowed_params)
    end

    def allowed_params
      [
        {categories_attributes: [:id, :name, :tag, :_destroy]},
        :start_date,
        :end_date,
        :debate_start_date,
        :debate_end_date,
        :draft_start_date,
        :draft_end_date,
        :draft_publication_date,
        :allegations_start_date,
        :allegations_end_date,
        :proposals_phase_start_date,
        :proposals_phase_end_date,
        :result_publication_date,
        :debate_phase_enabled,
        :draft_phase_enabled,
        :allegations_phase_enabled,
        :proposals_phase_enabled,
        :other_proposals_enabled,
        :draft_publication_enabled,
        :result_publication_enabled,
        :permit_text_proposals,
        :permit_proposals_top_relevance,
        :permit_hiden_proposals,
        :permit_like_proposals,
        :published,
        :geozone_restricted,
        :custom_list,
        :film_library_limit,
        :film_library_admin,
        :background_color,
        :font_color,
        :proposals_title,
        translation_params(::Legislation::Process),
        geozone_ids: [],
        documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy],
        image_attributes: image_attributes
      ]
    end

    def load_geozones
      @geozones = Geozone.all.order(:name)
    end

    def set_tag_list
      @process.set_tag_list_on(:customs, process_params[:custom_list])
      @process.save
    end

    def resource
      @process || ::Legislation::Process.find(params[:id])
    end
end
