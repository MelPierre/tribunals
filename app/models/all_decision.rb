class AllDecision < ActiveRecord::Base
  include Concerns::Decision::Search
  include Concerns::Decision::DocProcessors

  attr_accessor :new_judge_id


  has_many :category_decisions
  has_many :subcategories, through: :category_decisions
  has_many :categories, through: :category_decisions
  has_and_belongs_to_many :all_judges, join_table: :decisions_judges
  belongs_to :tribunal

  validates_uniqueness_of :slug

  accepts_nested_attributes_for :all_judges, allow_destroy: true, reject_if: :reject_judges
  accepts_nested_attributes_for :category_decisions, allow_destroy: true, reject_if: :reject_categories

  before_save :update_search_text
  before_save :set_slug
  before_save :set_neutral_citation_number
  before_save :set_file_number
  before_save :add_new_judge

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  scope :ftt, ->{ where(tribunal_id: Tribunal.ftt_tax.id) }
  scope :utaac, ->{ where(tribunal_id: Tribunal.utaac.id) }
  scope :eat, ->{ where(tribunal_id: Tribunal.eat.id) }

  scope :viewable, ->{ t = self.arel_table; where(t[:reported].eq(true).or(t[:promulgation_date].gteq(Date.new(2013, 6, 1)))) }
  scope :reported, ->{ where(reported: true) }
  scope :legacy_id, ->(legacy_id) { where("other_metadata::json->>'legacy_id' = ?", legacy_id) }
  scope :ordered, -> (tribunal) { order("#{tribunal.sort_by.first["name"]} DESC")  }

  protected

    def reject_categories(attrs)
      attrs[:category_id].blank?
    end

    def reject_judges(attrs)
      attrs[:id].blank?
    end

    def add_new_judge
      if new_judge_id.present? && judge = AllJudge.find(new_judge_id)
        self.all_judges << judge unless all_judges.include?(judge)
      end
    end

    def set_neutral_citation_number
      begin
        if neutral_citation_number.nil? || neutral_citation_number.blank?
          values = other_metadata.with_indifferent_access.slice('ncn_year', 'ncn_code1','ncn_citation').values
          values[0] = "[#{values[0]}]" if values[0]
          self.neutral_citation_number = values.compact.join(' ')
        end
      rescue Exception => ex

      end
    end

    def set_file_number
      begin
        self.file_number ||= other_metadata.with_indifferent_access.slice('file_no_1', 'file_no_2', 'file_no_3').values.compact.join('/')
        self.appeal_number = file_number if file_number =~ /\A[A-Z]{2}\/[0-9]{5}\/[0-9]{4}\Z/
      rescue Exception => ex

      end
    end

  def self.filtered(filter_hash)
    by_judge(filter_hash[:judge])
    .by_reported(filter_hash[:reported])
    .by_party(filter_hash[:party])
    .by_country(filter_hash[:country])
    .by_category(filter_hash[:category])
    .by_subcategory(filter_hash[:subcategory])
    .by_country_guideline(filter_hash[:country_guideline])
    .search(filter_hash[:query])
    .group('all_decisions.id')
  end

  def self.by_country_guideline(country_guideline)
    if country_guideline.present?
      where("country_guideline = ?", country_guideline)
    else
      where("")
    end
  end

  def self.by_reported(reported)
    if reported.present?
      if reported == "all"
        where("reported IS NOT NULL")
      else
        where("reported = ?", reported)
      end
    else
      where("")
    end
  end

  def self.by_judge(judge_name)
    if judge_name.present?
      joins(:all_judges).where("? = all_judges.name", judge_name)
    else
      where("")
    end
  end

  def self.by_party(party_name)
    if party_name.present?
      where("? = claimant OR ? = respondent", party_name, party_name)
    else
      where("")
    end
  end

  def self.by_country(country)
    if country.present?
      where("? = country", country)
    else
      where("")
    end
  end


  def self.by_category(category_name)
    if category_name.present?
      joins(:categories).where("? = categories.name", category_name)
    else
      where("")
    end
  end

  def self.by_subcategory(subcategory_name)
    if subcategory_name.present?
      joins(:subcategories).where("? = subcategories.name", subcategory_name)
    else
      where("")
    end
  end

  def subcategory_names
    subcategories.pluck(:name).join(' ')
  end

  def category_names
    categories.pluck(:name).join(' ')
  end

  def judge_names
    all_judges.list.join(' ')
  end

  def update_search_text
    #TODO Make sure all fields are included
    self.search_text = [subcategory_names, category_names, judge_names, neutral_citation_number, file_number,
                          reported_number, appeal_number, country, case_name, claimant, respondent, other_metadata, notes, text]
                        .join(' ')

  end

  def set_slug
    if self.file_number.blank?
      self.slug = self.id.to_s
      return
    end

    file_number_slug = self.file_number.gsub("/","-").upcase
    decision_by_slug = AllDecision.find_by_slug(file_number_slug)
    if decision_by_slug && (decision_by_slug.id != self.id)
      self.slug = "#{file_number_slug}_#{self.id}"
    else
      self.slug = file_number_slug
    end
  end

end
