class AacDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(decisions.maximum(:updated_at))
    @order_by = 'created_at'
    @sort_options = [["Date added", "created_at"], ["Date of decision", "decision_date"]]
    params[:search] ||= {}
    if params[:search].present?  
       @order_by = params[:search][:sort] || @order_by
    end
    @date_column_title = (@order_by == 'created_at') ? 'Date added' : 'Date of decision'
    @categories_title = 'Categories: '
    @decisions = decisions.ordered(@order_by).paginate(:page => params[:page], :per_page => 30)
    @decisions = @decisions.filtered(params[:search]) if params[:search].present?    
  end

  def show
    @aac_decision = decisions.find(params[:id])
    set_cache_control(@aac_decision.updated_at)
  end

  def tribunal
    Tribunal.utaac
  end

  def decisions
    tribunal.all_decisions
  end
end
