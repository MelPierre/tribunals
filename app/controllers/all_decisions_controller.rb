class AllDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(AllDecision.maximum(:updated_at))
    @order_by = 'created_at'
    params[:search] ||= {}

    @tribunal = Tribunal.find_by_code(params[:tribunal])
    @decisions = @tribunal.all_decisions.paginate(page: params[:page], per_page: 30)
    # @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    @decision = AllDecision.find(params[:id])
    set_cache_control(@decision.updated_at)
  end
end
