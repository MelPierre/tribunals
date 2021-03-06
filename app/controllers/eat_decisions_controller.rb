class EatDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(EatDecision.maximum(:updated_at))
    @order_by = 'hearing_date'
    @sort_options = [["Date of hearing", "hearing_date"], ["Date of update", "upload_date"]]
    params[:search] ||= {}
    if params[:search].present?  
       @order_by = params[:search][:sort] || @order_by
    end
    @date_column_title = (@order_by == 'hearing_date') ? 'Date of hearing' : 'Date of update'
    @categories_title = 'Topics: '
    @decisions = EatDecision.ordered(@order_by).paginate(:page => params[:page], :per_page => 30)
    @decisions = @decisions.filtered(params[:search]) if params[:search].present?        
  end

  def show
    @eat_decision = EatDecision.find(params[:id])
    set_cache_control(@eat_decision.updated_at)
  end
end
