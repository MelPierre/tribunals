module GenericHelper
  def display_categories(decision)
    prefix = decision.class.name.split(/(?=[A-Z])/)[0].downcase
    categories = []

    decision.send("#{prefix}_subcategories").each do |subcat|

      begin
        category = subcat.send("#{prefix}_category").name
      rescue NoMethodError
        category = ''
      end

      subcategory = (subcat.name || '')

      unless category.blank?
        categories << "#{category}/#{subcategory}"
      else
        categories << subcat.name
      end
    end

    categories.join(', ')
  end
end
