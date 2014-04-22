class DynamicTextFieldInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:span, class: "input string optional #{attribute_name}", style: "width:120px;margin-left:45px;") do
      template.concat @builder.text_field(attribute_name, input_html_options(0))
      template.concat link_text
    end
  end

  private

    def input_html_options(position)
      model = @builder.object_name
      name = "#{model}[#{column.name}][]"
      {id: "#{model}_#{position}", name: "#{name}", style:'width:390px;margin:5px; display:inline-block;'}
    end

    def link_text
      "<a href='#{}' id=add_#{column.name} class=add_text_field> Add another #{column.name}</a>".html_safe
    end
end