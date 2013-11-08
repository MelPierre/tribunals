module EatDecisionsHelper
  #TODO: Add page_title helper which does not conflict with other helpers
  def link_label(eat_decision)
    eat_decision.file_number
  end

  def display_starred(eat_decision)
    eat_decision.starred ? "Yes" : "No"
  end

  def display_categories(eat_decision)
    categories = []

    eat_decision.eat_subcategories.each do |subcat|

      begin
        category = subcat.eat_category.name
      rescue NoMethodError
        category = ''
      end

      subcategory = (subcat.name || '')

      unless category.blank?
        categories << "#{subcat.eat_category.name}/#{subcat.name}"
      else
        categories << subcat.name
      end
    end

    categories.join(', ')
  end
end
