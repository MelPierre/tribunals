class Tribunal < ActiveRecord::Base
  validates :name, :code, presence: true, uniqueness: true

  has_and_belongs_to_many :users
  has_many :all_judges
  has_many :all_decisions
  
  has_many :categories
  has_many :subcategories, through: :categories


  def filters
    config[:filters]
  end

  def sort_by
    config[:sort_by]
  end
 
  def results_columns
    config[:results_columns]
  end

  def form_fields
    config[:form_fields]
  end

  def display_fields
    config[:display_fields]
  end

  def label_for(field)
    form_fields[field]
  end

  class << self

    def method_missing(m, *args, &block)
      if tribunal = where(code: m.to_s.gsub('_','-')).first
        tribunal
      else
        super
      end
    end
  
  end

  protected

    def config
      @config ||= YAML.load_file(Rails.root.join('config/tribunals.yml')).with_indifferent_access[code]
    end

end
