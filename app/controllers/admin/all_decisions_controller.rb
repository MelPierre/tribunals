class Admin::AllDecisionsController < Admin::RestrictedController
  before_filter -> { require_tribunal(params[:tribunal_code]) }

  def index
    set_cache_control(decisions_relation.maximum(:updated_at))
    @order_by = 'decision_date'
    @sort_options = [["Date of decision", "decision_date"], ["Date of update", "last_updatedtime"]]
    params[:search] ||= {}
    if params[:search].present?
       @order_by = params[:search][:sort] || @order_by
    end
    @date_column_title = (@order_by == 'decision_date') ? 'Date of decision' : 'Date of update'
    @categories_title = 'Categories: '
    @decisions = decisions_relation.ordered.paginate(:page => params[:page], :per_page => 30)
    @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    @decision = decisions_relation.find(params[:id])
    set_cache_control(@decision.updated_at)
  end

  def create
    @decision = decisions_relation.new(decision_params)
    if @decision.save
      @decision.process_doc
      redirect_to admin_ftt_decision_path
    else
      render new_admin_ftt_decision_path
    end
  end

  def new
    @decision ||= decisions_relation.new
  end

  def edit
    @decision = self.class.scope.find(params[:id])
  end

  def update
    @decision = self.class.scope.find(params[:id])
    @decision.update_attributes!(decision_params)
    redirect_to admin_ftt_decision_path
  rescue
    redirect_to edit_admin_ftt_decision_path(@decisions)
  end

  def destroy
    @decision = self.class.scope.find(params[:id])
    @decision.destroy
    redirect_to admin_decisions_path
  end

  def current_tribunal
    Tribunal.find_by_code(params[:tribunal_code])
  end

  def decisions_relation
    current_tribunal.all_decisions
  end
end
