class NcnInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:span, class: "input string optional #{attribute_name}", style: "margin-left:125px") do
      template.concat @builder.select(attribute_name, year_range)
      template.concat @builder.text_field(attribute_name, input_html_options.merge({value: 'UKUT'}))
      template.concat @builder.text_field(attribute_name, number_field_html_options)
      template.concat @builder.text_field(attribute_name, input_html_options.merge({value: 'AAC'}))
      template.concat @builder.check_box(attribute_name, input_html_options.merge({value: 'AAC'}))
    end
  end

  private

    def input_html_options
       {id: 'ncn', size: '5px', style:'width:50px;margin:5px;min-width:0'}
    end

    def number_field_html_options
       input_html_options.merge({type: :number, placeholder: '000'})
    end

    def year_range
      year = Time.new.year
      (year-4..year+1).to_a.reverse.insert(0, 'Year')
    end
end