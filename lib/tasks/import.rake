require 'csv_importer'

namespace :import do

  namespace :aac do
    task all: [:judges, :subcategories, :decisions, :decisions_judges]

    task decisions: :environment do
      CSVImporter.new('data/aac', 'utaac').import_decisions
    end

    task categories: :environment do
      CSVImporter.new('data/aac', 'utaac').import_categories
    end

    task subcategories: :categories do
      CSVImporter.new('data/aac', 'utaac').import_subcategories
    end

    task judges: :environment do
      CSVImporter.new('data/aac', 'utaac').import_judges
    end

    task decisions_judges: :environment do
      CSVImporter.new('data/aac', 'utaac').update_decisions_judges
    end

    task process_docs: [:environment] do
      Tribunal.utaac.all_decisions.find_each do |d|
        d.add_doc_file
        d.process_doc
      end
    end
  end
end
