class Admin::CategoriesController < Admin::ResitrictedController

  respond_to :json

  def index
    respond_with current_tribunal.categories.order('name')
  end

  protected

    def current_tribunal
      @current_tribunal ||= Tribunal.find_by_code(params[:tribunal_code])
    end
end