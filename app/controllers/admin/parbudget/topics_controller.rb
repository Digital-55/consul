class Admin::Parbudget::TopicsController < Admin::Parbudget::BaseController
  respond_to :html, :js, :csv
  before_action :load_resource, only: [:update_topic,:destroy]

  def index
    search(params)
    @topics = @topics.page(params[:page]).per(20)
  end

  def create_topic
    topic=  @model.new
    if topic.save(validate: false)
      redirect_to admin_parbudget_topics_path,  notice: I18n.t("admin.parbudget.topic.create_success")
    else
      flash[:error] =I18n.t("admin.parbudget.topic.create_error")
      redirect_to admin_parbudget_topics_path(errors: topic.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.topic.create_error")
    redirect_to admin_parbudget_topics_path
  end

  def update_topic
    if @topic.update(topic_strong_params)
      redirect_to admin_parbudget_topics_path,  notice: I18n.t("admin.parbudget.topic.update_success")
    else
      flash[:error] = I18n.t("admin.parbudget.topic.update_error")
      redirect_to admin_parbudget_topics_path(errors: @topic.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.topic.update_error")
    redirect_to admin_parbudget_topics_path    
  end

  def destroy
    if @topic.destroy
      redirect_to admin_parbudget_topics_path,  notice: I18n.t("admin.parbudget.topic.destroy_success")
    else
      flash[:error] = I18n.t("admin.parbudget.topic.destroy_error")
      redirect_to admin_parbudget_topics_path(errors: @topic.errors.full_messages)
    end
  rescue
    flash[:error] = I18n.t("admin.parbudget.topic.destroy_error")
    redirect_to admin_parbudget_topics_path
  end

  private 

  def get_model
    @model = ::Parbudget::Topic
  end

  def topic_strong_params
    params.require(:parbudget_topic).permit(:name)
  end

  def load_resource
    @topic = ::Parbudget::Topic.find(params[:id])
  rescue
    @topic = nil
  end

  def search(parametrize = {})
    @topics = @model.all
    @filters = []

    if !parametrize[:search_topic].blank?
      @filters.push("#{I18n.t('admin.parbudget.topic.search_topic')}: #{parametrize[:search_topic]}")
      @topics = @topics.where("translate(UPPER(cast(name as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast('%#{parametrize[:search_topic]}%' as varchar)), 'ÁÉÍÓÚ', 'AEIOU')")
    end
  end
end
