class Admin::JudgesController < Admin::RestrictedController

  respond_to :html, :json

  def index
    respond_with current_tribunal.all_judges.order('name')
  end

  protected

    def current_tribunal
      @current_tribunal ||= Tribunal.find_by_code(params[:tribunal_code])
    end

end