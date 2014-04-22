class NcnInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:span, class: "input string optional #{attribute_name}", style: "margin-left:125px") do
      template.concat @builder.select(attribute_name, year_range, {include_blank: false}, {name: "#{attribute_name}[#{column.name}][]"})
      template.concat @builder.text_field(attribute_name, input_html_options.merge({value: 'UKUT'}))
      template.concat @builder.text_field(attribute_name, number_field_html_options)
      template.concat @builder.text_field(attribute_name, input_html_options.merge({value: 'AAC'}))
      template.concat check_box_label
    end
  end

  private

    def check_box_label
      template.content_tag(:span, class: "input string optional #{attribute_name}", style: "width:250px;margin-left:155px;display:block") do
        template.concat @builder.check_box(attribute_name, check_box_html_options)
        template.concat @builder.label(attribute_name, 'I haven\'t got an NCN number')
      end
    end

    def input_html_options
      model = @builder.object_name
      name = "#{model}[#{column.name}][]"
      {name: "#{name}", size: '5px', style:'width:50px;margin:5px;min-width:0'}
    end

    def number_field_html_options
      input_html_options.merge({type: :number, placeholder: '000'})
    end

    def check_box_html_options
      {style:"min-width:0;margin:5px"}
    end

    def year_range
      year = Time.new.year
      (year-4..year+1).to_a.reverse.insert(0, 'Year')
    end
end