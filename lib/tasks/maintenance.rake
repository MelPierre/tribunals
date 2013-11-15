namespace :maintenance do
  task :assign_ncn => [:environment] do
    ActiveRecord::Base.connection.execute("UPDATE decisions SET ncn = appeal_number WHERE reported")
  end

  task :assign_appeal_number => [:environment] do
    Decision.where("reported = 'f' AND doc_file IS NOT NULL AND appeal_number IS NULL").find_each do |d|
      puts d.try_extracting_appeal_numbers
      d.save
    end
  end

  task :remove_judges_whitespace => :environment do
    Decision.where("judges IS NOT NULL").except(:text, :html).find_each do |d|
      unless d.judges.empty?
        d.judges = d.judges.map {|j| j.strip.squish }
        #Turn off validation while saving because some records have data missing for required fields
        d.save(validate: false)
      end
    end
  end

  namespace :aac do
    task :remove_judges_whitespace => :environment do
      Judge.find_each do |j|
        j.name = j.name.strip.squish
        #Turn off validation while saving because some records have data missing for required fields
        j.save(validate: false)
      end
    end

    task :assign_file_numbers => :environment do
      AacDecision.find_each do |d|
        if d.file_no_1.present? && d.file_no_2.present? && d.file_no_3.present?
          puts "Assigning file_number for AacDecision id #{d.id}"
          d.file_number = [d.file_no_1, d.file_no_2, d.file_no_3].join('/')
          d.save
        end
      end
    end

    task :assign_subcategories => :environment do
      AacDecision.find_each do |d|
        puts "Assigning subcategories for AacDecision id #{d.id}"
        d.aac_subcategories << AacSubcategory.find(d.aac_decision_subcategory_id) if d.aac_decision_subcategory_id
        d.aac_subcategories << AacSubcategory.find(d.old_sec_subcategory_id) if d.old_sec_subcategory_id    
        puts "Subcategories for AacDecision id #{d.id}: #{d.aac_subcategory_ids}"
        d.save!
      end
    end
  end

  namespace :eat do
    task :remove_judges_whitespace => :environment do
      EatDecision.find_each do |d|
        d.judges = d.judges.squish
        #Turn off validation while saving because some records have data missing for required fields
        d.save(validate: false)
      end
    end
  end

  namespace :ftt do
    task :assign_file_numbers => :environment do
      FttDecision.find_each do |d|
        d.update_attributes(file_number: [d.file_no_1,d.file_no_2].join(''))
      end
    end
  end
end
