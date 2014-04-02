require 'csv_importer'

namespace :import do
  task :all => [:judges, :subcategories, :decisions]


  namespace :aac do
    task :decisions => :environment do
      CSVImporter.new('data/aac', 'utaac').import_decisions
    end

    task :categories => :environment do
      CSVImporter.new('data/aac', 'utaac').import_categories
    end

    task :subcategories => :categories do
      CSVImporter.new('data/aac', 'utaac').import_subcategories
    end

    task :judges => :environment do
      CSVImporter.new('data/aac', 'utaac').import_judges
    end

    # task :decisions_judges_mapping => :environment do
    #   CSVImporter.new('data/aac', 'utaac').import_decisions_judges_mapping
    # end

    task :process_docs => [:environment] do
      Tribunal.find_by_code('utaac').all_decisions.find_each do |d|
        d.add_doc_file
        d.process_doc
      end
    end
  end
end
