require 'csv_importer'

namespace :import do
  task :all => [:csv]

  task :csv => :environment do
    CSVImporter.new('data').run
  end

  namespace :aac do
    task :decisions => :environment do
      CSVImporter.new('data/aac').import_decisions
    end

    task :decision_categories => :environment do
      CSVImporter.new('data/aac').import_categories
    end

    task :decision_subcategories => :environment do
      CSVImporter.new('data/aac').import_subcategories
    end

    task :judges => :environment do
      CSVImporter.new('data/aac').import_judges
    end

    task :decisions_judges_mapping => :environment do
      CSVImporter.new('data/aac').import_decisions_judges_mapping
    end

    task :process_docs => [:environment] do
      AacDecision.find_each do |d|
        d.add_doc_file
        d.process_doc
      end
    end

    desc "Process pdf files for AacDecision"
    task :process_pdf, [:pdf_dir] => :environment do |t, args|
      pdf_dir = args[:pdf_dir]
      if Dir.exists?(pdf_dir)
        Dir["#{pdf_dir}/**/*.pdf"].each do |pdf_file_path|
          decision_id = File.dirname(pdf_file_path).split('/').last.gsub(/[^0-9]+/, '').to_i
          decision = FttDecision.find_by_id(decision_id)
          DocProcessor.process_pdf_file(decision, pdf_file_path) if decision.present?
        end
      else
        puts 'This directory does not exist'
      end
    end
  end
end
