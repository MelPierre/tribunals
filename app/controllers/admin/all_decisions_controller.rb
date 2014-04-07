class Admin::AllDecisionsController < Admin::RestrictedController
  before_filter -> { require_tribunal(params[:tribunal_code]) }

  respond_to :html, :json

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
    respond_with do |format|
      format.html do
        gon.decision_id = params[:id]
        gon.tribunal_id = current_tribunal.code
      end
      format.json do
        @tribunal = current_tribunal
        @decision = decisions_relation.find_by('upper(slug) = ?', params[:id].upcase)
        respond_with @decision
      end
    end
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
    respond_with do |format|
      format.html do
        gon.decision_id = params[:id]
        gon.tribunal_id = current_tribunal.code
      end
      format.json do
        @tribunal = current_tribunal
        @decision = decisions_relation.find_by('upper(slug) = ?', params[:id].upcase)
        respond_with @decision
      end
    end
  end

  def update
    @tribunal = current_tribunal
    slug = params.fetch(:id).upcase
    @decision = decisions_relation.find_by('upper(slug) = ?', slug)
    update_status = @decision.update_attributes!(decision_params)
    if update_status
      redirect_to admin_all_decision_path(tribunal_code: @tribunal.code, id: @decision.slug)
    else
      render 'edit'
    end
  end

  def destroy
    slug = params.fetch(:id).upcase
    @decision = decisions_relation.find_by('upper(slug) = ?', slug)
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
end
