class AllDecisionsController < ApplicationController
  before_filter :enable_varnish

  # def index
  #   set_cache_control(AllDecision.maximum(:updated_at))
  #   @order_by = 'created_at'
  #   params[:search] ||= {}

  #   @tribunal = Tribunal.find_by_code(params[:tribunal])
  #   @decisions = @tribunal.all_decisions.paginate(page: params[:page], per_page: 30)
  #   @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  # end

   def index
    # set_cache_control(decisions_relation.maximum(:updated_at))
    @order_by = 'created_at'
    @sort_options = [["Date of decision", "decision_date"], ["Date of update", "last_updatedtime"]]
    params[:search] ||= {}
    if params[:search].present?
       @order_by = params[:search][:sort] || @order_by
    end
    @date_column_title = (@order_by == 'decision_date') ? 'Date of decision' : 'Date of update'
    @categories_title = 'Categories: '
    @decisions = tribunal.all_decisions.paginate(page: params[:page], per_page: 30)
    # @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    @decision = AllDecision.find(params[:id])
    set_cache_control(@decision.updated_at)
  end


  protected
    def tribunal
      @tribunal ||= Tribunal.find_by_code(params[:tribunal_code])
    end




end
