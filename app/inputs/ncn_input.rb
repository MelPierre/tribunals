class NcnInput < SimpleForm::Inputs::Base
  def input
    template.content_tag(:div, class: 'input-group ncn form_ncn') do
      template.concat @builder.select(attribute_name, ['Year', 2015, 2014, 2013, 2012])
      template.concat @builder.text_field(attribute_name, input_html_options)
    end
  end
end