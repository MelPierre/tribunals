require 'csv_importer'

namespace :import do

  namespace :aac do

    desc "Import all aac data  [:judges, :subcategories, :decisions, :decisions_judges]"
    task all: [:judges, :subcategories, :decisions, :decisions_judges]

    desc "Import aac decisions data"
    task decisions: :environment do
      CSVImporter.new('data/aac', 'utaac').import_decisions
    end

    desc "Import aac categories data"
    task categories: :environment do
      CSVImporter.new('data/aac', 'utaac').import_categories
    end

    desc "Import aac subcategories data"
    task subcategories: :categories do
      CSVImporter.new('data/aac', 'utaac').import_subcategories
    end

    desc "Import aac judges data"
    task judges: :environment do
      CSVImporter.new('data/aac', 'utaac').import_judges
    end

    desc "Import aac decisions_judges data"
    task decisions_judges: :environment do
      CSVImporter.new('data/aac', 'utaac').update_decisions_judges
    end

    desc "Process aac decisions documents"
    task process_docs: [:environment] do
      Tribunal.utaac.all_decisions.find_each do |d|
        d.add_doc_file
        d.process_doc
      end
    end
  end

  namespace :ftt do

    desc "Import all ftt data [:judges, :subcategories, :decisions, :decisions_judges]"
    task all: [:judges, :subcategories, :decisions, :decisions_judges]

    desc "Import ftt decisions data"
    task decisions: :environment do
      CSVImporter.new('data/ftt', 'ftt_tax').import_decisions
    end

    desc "Import ftt categories data"
    task categories: :environment do
      CSVImporter.new('data/ftt', 'ftt_tax').import_categories
    end

    desc "Import ftt subcategories data"
    task subcategories: :categories do
      CSVImporter.new('data/ftt', 'ftt_tax').import_subcategories
    end

    desc "Import ftt judges data"
    task judges: :environment do
      CSVImporter.new('data/ftt', 'ftt_tax').import_judges
    end

    desc "Import ftt decisions_judges data"
    task decisions_judges: :environment do
      CSVImporter.new('data/ftt', 'ftt_tax').update_decisions_judges
    end

    desc "Process ftt decisions documents"
    task process_docs: [:environment] do
      Tribunal.ftt_tax.all_decisions.find_each do |d|
        d.add_doc_file
        d.process_doc
      end
    end
  end

end
