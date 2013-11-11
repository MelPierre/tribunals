module AacDecisionsHelper
  #TODO: Add page_title helper which does not conflict with other helpers
  def category_name(aac_decision)
    if aac_decision.aac_subcategory && aac_decision.aac_subcategory.aac_category
        aac_decision.aac_subcategory.aac_category.name
    end
  end

  def subcategory_name(aac_decision)
    aac_decision.aac_subcategory.name if aac_decision.aac_subcategory
  end

  def judge_names(aac_decision)
    aac_decision.judges.pluck(:name).join(", ")
  end

  def display_ncn(aac_decision)
    aac_decision.ncn || "(unknown)"
  end

  def link_label(aac_decision)
    aac_decision.file_number || aac_decision.ncn || aac_decision.reported_number
  end
end
