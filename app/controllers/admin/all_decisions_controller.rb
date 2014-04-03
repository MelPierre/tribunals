class Admin::AllDecisionsController < Admin::RestrictedController
  before_filter -> { require_tribunal(params[:tribunal_code]) }
  before_filter :set_view_path

  helper_method :current_tribunal, :tribunal_form_view_path, :tribunal_common_view_path

  def index
    set_cache_control(decisions_relation.maximum(:updated_at))
    @tribunal = current_tribunal
    @order_by = 'decision_date'
    @sort_options = [["Date of decision", "decision_date"], ["Date of update", "last_updatedtime"]]
    params[:search] ||= {}
    if params[:search].present?
       @order_by = params[:search][:sort] || @order_by
    end
    @date_column_title = (@order_by == 'decision_date') ? 'Date of decision' : 'Date of update'
    @categories_title = 'Categories: '
    @decisions = @tribunal.all_decisions.paginate(:page => params[:page], :per_page => 30)
    # @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    @tribunal = current_tribunal
    @decision = decisions_relation.find_by_file_number(params[:id])
    set_cache_control(@decision.updated_at)
    # render 'admin/all_decisions/show'
  rescue
    redirect_to admin_all_decisions_path
  end

  def create
    @decision = decisions_relation.new(decision_params)
    if @decision.save
      @decision.process_doc
      redirect_to admin_all_decisions_path
    else
      render new_admin_all_decision_path
    end
  end

  def new
    @tribunal = current_tribunal
    @decision ||= decisions_relation.new
  end

  def edit
    @tribunal = current_tribunal
    @decision = decisions_relation.find_by_file_number(params[:id])
  end

  def update
    @decision = decisions_relation.find_by_file_number(params[:id])
    @decision.update_attributes!(decision_params)
    redirect_to admin_all_decision_path
  rescue
    redirect_to edit_admin_all_decision_path(@decision)
  end

  def destroy
    @decision = decisions_relation.find_by_file_number(params[:id])
    @decision.destroy
    redirect_to admin_all_decisions_path
  end

  protected

    def current_tribunal
      @current_tribunal ||= Tribunal.find_by_code(params[:tribunal_code])
    end

    def tribunal_view_path
      "/admin/all_decisions/"
    end

    def tribunal_form_view_path
      tribunal_view_path + 'forms/' + current_tribunal.code.underscore
    end

    def tribunal_common_view_path
      tribunal_view_path + 'common/'
    end

    def decisions_relation
      current_tribunal.all_decisions
    end

  private
    def decision_params
      params.require(:all_decision).permit( :doc_file,
                                            :tribunal_id,
                                            :file_number,
                                            :claimant,
                                            :respondent,
                                            :all_judge_ids,
                                            :decision_date,
                                            :upload_date,
                                            :publication_date,
                                            :category_ids,
                                            :subcategory_ids,
                                            :notes
                                            )

    end

    def set_view_path
      prepend_view_path "#{Rails.root}/app/views/admin/all_decisions"
    end
end
