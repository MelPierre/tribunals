module GenericHelper
  def display_categories(decision, separator = " / ")
    prefix = decision.class.name.split(/(?=[A-Z])/)[0].downcase
    categories = []

    decision.send("#{prefix}_subcategories").each do |subcat|
      category = begin
                   subcat.send("#{prefix}_category").name
                 rescue NoMethodError
                   nil
                 end

      categories << join_display_strings([category, subcat.name], separator)
    end

    categories.join(', ')
  end

  def display_parties(decision, separator = " vs ")
    join_display_strings([decision.claimant, decision.respondent], separator)
  end

  def join_display_strings(strings_array, separator)
    strings_array.reject(&:blank?).join(separator)
  end
end
