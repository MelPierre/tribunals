class AllDecisionsController < ApplicationController
  before_filter :enable_varnish
  before_filter :load_decision, only: [:show]

  helper_method :current_tribunal


   def index
    set_cache_control(decisions_relation.maximum(:updated_at))
    @order_by = 'created_at'
    @sort_options = [["Date of decision", "decision_date"], ["Date of update", "last_updatedtime"]]
    params[:search] ||= {}
    if params[:search].present?
       @order_by = params[:search][:sort] || @order_by
    end
    @date_column_title = (@order_by == 'decision_date') ? 'Date of decision' : 'Date of update'
    @categories_title = 'Categories: '
    @decisions = current_tribunal.all_decisions.paginate(page: params[:page], per_page: 30)
    # @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    if @decision.present?
      set_cache_control(@decision.updated_at)
    else
      flash.keep[:notice] = "Decision not found #{params[:id]}"
      redirect_to admin_all_decisions_path
    end
  end

  protected
    def current_tribunal
      @tribunal ||= Tribunal.find_by_code(params[:tribunal_code])
    end

    def decisions_relation
      current_tribunal.all_decisions
    end

    def load_decision
      slug = params.fetch(:id).downcase
      @decision = decisions_relation.friendly_id.find(slug)
    rescue ActiveRecord::RecordNotFound => e
      @decision = nil
    end
end
