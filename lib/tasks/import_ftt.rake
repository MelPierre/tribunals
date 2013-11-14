require 'ftt_importer'
require 'ftt_edge_case_docs'

namespace :import do
  namespace :ftt do
    desc "match docs with judgments - expect DOCS env var with the documents"
    task :docs2judgments => :environment do
      abort "DOCS env var required, exiting..." if ENV['DOCS'].blank?
      Dir.chdir("#{ENV['DOCS']}") do
        Dir.glob("[^j]*").each do |dir|
          Dir.chdir dir do
            puts '>' * 80

            puts "for dir: #{dir}"
            wordfiles = Dir.glob("*doc")
            pdfs = Dir.glob("*pdf")

            if wordfiles.count > 0
              sieve_files(dir, wordfiles, doc_type="doc_file")
              sieve_files(dir, pdfs, doc_type="pdf_file")
            elsif (wordfiles.count == 0) && (pdfs.count > 0)
              sieve_files(dir, pdfs, doc_type="pdf_file")
            else
              puts "EEEEK: no files found in #{dir}"
            end

            puts '<' * 80
          end
        end
      end
    end

    desc "run all the tasks for the import:eat namespace"
    task :all => [:judgments, :categories, :subcategories, :assign_subcategories_to_decisions, :judges, :judges_judgments_mapping]

    dir = 'data/ftt'
    task :judgments => :environment do
      FTTImporter.new(dir).import_judgments
    end

    task :categories => :environment do
      FTTImporter.new(dir).import_categories
    end

    task :subcategories => :environment do
      FTTImporter.new(dir).import_subcategories
    end

    task :assign_subcategories_to_decisions => :environment do
      FttDecision.find_each do |d|
        begin
          d.ftt_subcategories.destroy_all
          d.ftt_subcategories << FttSubcategory.find(d.old_main_subcategory_id) if d.old_main_subcategory_id
          d.ftt_subcategories << FttSubcategory.find(d.old_sec_subcategory_id) if d.old_sec_subcategory_id
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        end
      end
    end

    task :judges => :environment do
      FTTImporter.new(dir).import_judges
    end

    task :judges_judgments_mapping => :environment do
      FTTImporter.new(dir).import_judges_judgments_mapping
    end

    task :process_docs => [:environment] do
      FttDecision.find_each do |d|
        puts "Processing docs for FttDecision id #{d.id}"
        d.add_doc
        d.process_doc
      end
    end
  end
end
