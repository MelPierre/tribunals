module AacDecisionsHelper
  #TODO: Add page_title helper which does not conflict with other helpers
  def category_name(aac_decision)
    if aac_decision.aac_decision_subcategory && aac_decision.aac_decision_subcategory.aac_decision_category
        aac_decision.aac_decision_subcategory.aac_decision_category.name
    end
  end

  def subcategory_name(aac_decision)
    aac_decision.aac_decision_subcategory.name if aac_decision.aac_decision_subcategory
  end

  def judge_names(aac_decision)
    aac_decision.judges.pluck(:name).join(", ")
  end

  def display_ncn(aac_decision)
    aac_decision.ncn || "(unknown)"
  end

  def display_parties(aac_decision)
    if aac_decision.claimant && aac_decision.respondent
      "#{aac_decision.claimant} vs #{aac_decision.respondent}"
    else
      aac_decision.claimant || aac_decision.respondent
    end
  end

  def link_label(aac_decision)
    aac_decision.file_number || aac_decision.ncn || aac_decision.reported_number
  end
end
