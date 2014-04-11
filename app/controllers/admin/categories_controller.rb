class Admin::CategoriesController < Admin::RestrictedController
  before_filter -> { require_tribunal(params[:tribunal_code]) }
  before_filter :load_category, only: [:show,:edit,:update,:destroy]

  def index
    @categories = current_tribunal.categories.paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def new
    @category = current_tribunal.category.new 
  end

  def create
    @category = current_tribunal.category.new(category_params)
    if @category.save
      flash[:notice] = 'Successfully created category'
      redirect_to after_action_path
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @category.update_attributes(category_params)
      flash[:notice] = 'Successfully updated category'
      redirect_to after_action_path
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = "Successfully deleted category"
    redirect_to after_action_path
  end

  protected

    def category_params
      params.require(:category).permit(:name)
    end

    def after_action_path
      admin_categories_path(trinbunal_code: params.fetch(:tribunal_code))
    end

    def load_category
      @category = current_tribunal.categories.find(params[:id])
    end

end