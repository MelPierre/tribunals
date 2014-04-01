class AllDecision < ActiveRecord::Base
  include DecisionSearch
  has_many :category_decisions
  has_many :subcategories, through: :category_decisions
  has_many :categories, through: :category_decisions
  has_and_belongs_to_many :all_judges, join_table: :decisions_judges
  belongs_to :tribunal

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    if !file_number.blank?
      file_number
    else
      "decision-#{id}"
    end
  end

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader


  scope :ftt, ->{ where(tribunal_id: Tribunal.ftt.id) } 
  scope :utaac, ->{ where(tribunal_id: Tribunal.utaac.id) } 
  scope :eat, ->{ where(tribunal_id: Tribunal.eat.id) } 
  scope :viewable, ->{ t = self.arel_table; where(t[:reported].eq(true).or(t[:promulgation_date].gteq(Date.new(2013, 6, 1)))) }
  scope :reported, ->{ where(reported: true) }

  scope :ordered, -> (tribunal) { order("#{tribunal.sort_by.first["name"]} DESC")  }

  # def self.filtered(filter_hash)
  #   by_judge(filter_hash[:judge]).by_category(filter_hash[:category])
  #   .by_subcategory(filter_hash[:subcategory]).by_party(filter_hash[:party])
  #   .search(filter_hash[:query])
  # end
end