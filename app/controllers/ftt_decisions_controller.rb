class FttDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(FttDecision.maximum(:updated_at))
    @order_by = 'decision_date'
    @sort_options = [["Date of decision", "decision_date"], ["Date of update", "last_updatedtime"]]
    params[:search] ||= {}
    if params[:search].present?
       @order_by = params[:search][:sort] || @order_by
    end
    @date_column_title = (@order_by == 'decision_date') ? 'Date of decision' : 'Date of update'
    @categories_title = 'Categories: '
    @decisions = FttDecision.ordered.paginate(:page => params[:page], :per_page => 30)
    @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    @ftt_decision = FttDecision.find(params[:id])
    set_cache_control(@ftt_decision.updated_at)
  end
end
