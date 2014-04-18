class MultipleTextFieldInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:span, class: "input string optional #{attribute_name}", style: "margin-left:107px") do
      template.concat @builder.text_field(attribute_name, input_html_options(0))
      template.concat @builder.text_field(attribute_name, input_html_options(1))
      template.concat @builder.text_field(attribute_name, input_html_options(2))
    end
  end

  private

    def input_html_options(position)
      model = @builder.object_name
      name = "#{model}[#{column.name}][]"
      {id: "#{model}_#{position}", name: "#{name}", size: '10px', style:'width:113px;margin:5px;min-width:0'}
    end
end