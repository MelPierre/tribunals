module AllDecisionsHelper
  #TODO: Add page_title helper which does not conflict with other helpers
  def all_link_label(decision)
    decision.try(:file_number) || "Unknown title"
  end

  def all_display_file_number(decision)
    decision.file_number || "Unkown"
  end

  def all_display_categories(decision, separator = " / ")
    # prefix = decision.class.name.split(/(?=[A-Z])/)[0].downcase
    categories = ["Category, Sub-category"]

    # decision.send("#{prefix}_subcategories").each do |subcat|
    #   category = begin
    #                subcat.send("#{prefix}_category").name
    #              rescue NoMethodError
    #                nil
    #              end

    #   categories << join_display_strings([category, subcat.name], separator)
    # end

    categories.join(', ')
  end

  def all_display_parties(decision, separator = " v ")
    join_display_strings([decision.claimant, decision.respondent], separator)
  end

  def join_display_strings(strings_array, separator)
    strings_array.reject(&:blank?).join(separator)
  end

  def error_messages_for(object, field)
    '<span class="validation-message">' + object.errors.messages[field.to_sym].first + '</span>'
  end

  def input_for(form, filter, html_options={})
    if filter['type'] == "radio"
      s = ""
      filter['options'].each do |option|
        s += "<label class='checkbox inline'><input type= #{filter['type']} 
                name=#{filter['name']} value=#{option['value']} 
                #{'checked=checked' if option['checked']} /> #{option['label']}</label>"
      end
      raw s
    else
      # raw(form.send("#{filter[:type]}_field".to_sym, filter[:label], html_options))      
      raw("<input type=#{filter['type']} placeholder='#{filter['placeholder']}'  />")
    end
  end

  def Xinput_for(form, label, options = {}, html_options = {}, &block)
    options = {:type => "text"}.merge(options)
    errors_present = form.object.errors.messages[label.to_sym].present?
    s = "<div>"
    if options[:label_override] != false
      s << form.label(label, :id => "#{label}_label") do
        x = options[:label_override] ? options[:label_override] : label.humanize
        x << error_messages_for(form.object, label) if errors_present
        raw(x)
      end
    else
      html_options[:class] = "#{html_options[:class]} push".strip
    end
    if block_given?
      s << raw(capture(&block))
    else
      s << raw(form.send("#{options[:type]}_field".to_sym, label, html_options))
    end
    s << '</div>'
    raw s
  end

  end
