class EatDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(EatDecision.maximum(:updated_at))
    
    params[:search] ||= {}
    @eat_decisions = EatDecision.ordered.paginate(:page => params[:page], :per_page => 30)
    @eat_decisions = @eat_decisions.filtered(params[:search]) if params[:search].present?        
  end

  def show
    @eat_decision = EatDecision.find(params[:id])
    set_cache_control(@eat_decision.updated_at)
  end
end
