class Admin::AllDecisionsController < Admin::RestrictedController
  before_filter -> { require_tribunal(params[:tribunal_code]) }
  before_filter :load_decision, only: [:show, :edit, :destroy]

  helper_method :tribunal_form_view_path, :tribunal_common_view_path

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
    @decisions = @tribunal.all_decisions.paginate(page: params[:page], per_page: 30)
    # @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    configure_labels_for_show_action
    if @decision.present?
      set_cache_control(@decision.updated_at)
    else
      flash.keep[:notice] = "Decision not found #{params[:id]}"
      redirect_to admin_all_decisions_path
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
    @decision = decisions_relation.new
    @decision.category_decisions.build
    configure_labels_for_new_or_edit_actions
  end

  def edit
    @decision.category_decisions.build
    configure_labels_for_new_or_edit_actions
  end

  def update
    @decision = decisions_relation.find(params[:id])
    if @decision.update_attributes(decision_params)
      redirect_to edit_admin_all_decision_path(tribunal_code: @tribunal.code, id: @decision.slug)
    else
      render 'edit'
    end
  end

  def destroy
    @decision.destroy
    redirect_to admin_all_decisions_path
  end

  protected

    def current_tribunal
      @tribunal ||= Tribunal.find_by_code(params[:tribunal_code])
      @tribunal
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

    def load_decision
      slug = params.fetch(:id).upcase
      @decision = decisions_relation.find_by('upper(slug) = ?', slug)
    end

    def configure_labels_for_show_action
      I18n.locale = "en-#{@tribunal.code}-show"
      puts "using: #{I18n.locale}"
    end

    def configure_labels_for_new_or_edit_actions
      I18n.locale = "en-#{@tribunal.code}-edit"
      puts "using: #{I18n.locale}"
    end

  private
    def decision_params
      params.require(:all_decision).permit(
        :doc_file,
        :tribunal_id,
        :file_number,
        :starred,
        :published,
        :neutral_citation_number,
        :claimant,
        :respondent,
        :all_judge_ids,
        :decision_date,
        :upload_date,
        :publication_date,
        :hearing_date,
        :category_ids,
        :subcategory_ids,
        :notes,
        :new_judge_id,
        all_judges_attributes: [:id, :_destroy],
        category_decisions_attributes: [:id, :category_id, :subcategory_id, :_destroy]
      )
    end
end
