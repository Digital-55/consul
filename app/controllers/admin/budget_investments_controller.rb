class Admin::BudgetInvestmentsController < Admin::BaseController
  include FeatureFlags
  include CommentableActions

  feature_flag :budgets

  has_orders %w{oldest}, only: [:show, :edit]
  has_filters(%w{all without_admin without_valuator under_valuation
                 valuation_finished winners},
                 only: [:index, :toggle_selection])

  before_action :load_budget
  before_action :load_investment, only: [:show, :edit, :update, :toggle_selection]
  before_action :load_ballot, only: [:show, :index]
  before_action :parse_valuation_filters
  before_action :load_investments, only: [:index, :toggle_selection]

  def index
    respond_to do |format|
      format.html
      format.js
      format.csv do
        send_data Budget::Investment::Exporter.new(@investments).to_csv,
                  filename: "budget_investments.csv"
      end
    end
  end

  def show
    load_comments
  end

  def edit
    load_admins
    load_valuators
    load_valuator_groups
    load_tags
  end

  def update
    if @investment.update(budget_investment_params)
      redirect_to admin_budget_budget_investment_path(@budget,
                                                      @investment,
                                                      Budget::Investment.filter_params(params).to_h),
                  notice: t("flash.actions.update.budget_investment")
    else
      load_admins
      load_valuators
      load_valuator_groups
      load_tags
      render :edit
    end
  end

  def toggle_selection
    @investment.toggle :selected
    @investment.save
    load_investments
  end

  private

    def load_comments
      @commentable = @investment
      @comment_tree = CommentTree.new(@commentable, params[:page], @current_order, valuations: true)
      set_comment_flags(@comment_tree.comments)
    end

    def resource_model
      Budget::Investment
    end

    def resource_name
      resource_model.parameterize(separator: "_")
    end

    def load_investments
      @investments = Budget::Investment.scoped_filter(params, @current_filter)
                                       .order_filter(params)
      @investments = @investments.page(params[:page]) unless request.format.csv?
    end

    def budget_investment_params
      params.require(:budget_investment)
            .permit(:title, :description, :external_url, :heading_id, :administrator_id, :tag_list,
                    :organization_name, :label, :incompatible, :selected, :valuation_tag_list,
                    :visible_to_valuators, valuator_ids: [], valuator_group_ids: [])
    end

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:budget_id]
    end

    def load_investment
      @investment = @budget.investments.find(params[:id])
    end

    def load_admins
      @admins = Administrator.includes(:user).all
    end

    def load_valuators
      @valuators = Valuator.includes(:user).all.order(description: :asc).order("users.email ASC")
    end

    def load_valuator_groups
      @valuator_groups = ValuatorGroup.all.order(name: :asc)
    end

    def load_tags
      @tags = Budget::Investment.by_budget(@budget).tags_on(:valuation).order(:name).distinct
    end

    def load_ballot
      query = Budget::Ballot.where(user: current_user, budget: @budget)
      @ballot = @budget.balloting? ? query.first_or_create : query.first_or_initialize
    end

    def parse_valuation_filters
      if params[:valuator_or_group_id]
        model, id = params[:valuator_or_group_id].split("_")

        if model == "group"
          params[:valuator_group_id] = id
        else
          params[:valuator_id] = id
        end
      end
    end
end
