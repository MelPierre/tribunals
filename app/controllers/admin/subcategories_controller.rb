class Admin::SubcategoriesController < Admin::RestrictedController
  before_filter -> { require_tribunal(params.fetch(:tribunal_code)) }
  before_filter :load_subcategory, only: [:show,:edit,:update,:destroy]

  def index
    @subcategories = category.subcategories.paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def new
    @subcategory = category.subcategories.new 
  end

  def create
    @subcategory = category.subcategories.new(subcategory_params)
    if @subcategory.save
      flash[:notice] = 'Successfully created subcategory'
      redirect_to after_action_path
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @subcategory.update_attributes(subcategory_params)
      flash[:notice] = 'Successfully updated subcategory'
      redirect_to after_action_path
    else
      render 'edit'
    end
  end

  def destroy
    @subcategory.destroy
    flash[:notice] = "Successfully deleted subcategory"
    redirect_to after_action_path
  end

  protected

    def subcategory_params
      params.require(:subcategory).permit(:name)
    end

    def after_action_path
      admin_category_subcategories_path(category, trinbunal_code: params.fetch(:tribunal_code))
    end

    def category
      current_tribunal.categories.find(params.fetch(:category_id))
    end 

    def load_subcategory
      @subcategory = category.subcategories.find(params.fetch(:id))
    end

end