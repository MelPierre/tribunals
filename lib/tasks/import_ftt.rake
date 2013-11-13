require 'ftt_importer'

namespace :import do
  namespace :ftt do

    def find_doc id
      FttDecision.where("file_no_1 like :q or file_no_2 like :q or file_number like :q", q:"%#{id}%")
    end

    def munge_doc(decision, file_path)
      decision.add_doc file_path
      decision.process_doc
    end

    def sieve_files(dir, files, doc_type="doc_file")
      file_type = doc_type.gsub('_', ' ')

      puts "Looking at #{file_type}s"

      if files.count > 0
        files.each do |file|
          word_file_name = file.split('/').last
          file_name = word_file_name.split('.').first
          puts "  file found: #{file_name}"
          result = find_doc "#{file_name}"

          if result.count == 1
            puts "  Decision: #{result.first.id} matches with #{file_name} !"
            if result.first.send("#{doc_type}").blank?
              full_path = "#{ENV['DOCS']}/#{dir}/#{file_name}.#{file_type}"
              puts "  OK: #{result.first.id} doesn't have a #{file_type} so #{full_path} can be used"
              munge_doc(result.first, full_path) if file_type == "doc"
            else
              decision = result.first
              found_file = decision.doc_file.file.path.split('/').last
              puts "  WARRNING: #{decision.id} already has a doc file #{found_file}"
            end

          elsif result.count > 1
            puts "Match found for #{dir}/#{file_name}, but there are multiple decisions matching"
            puts "Multiple IDs: #{result.map(&:id)}"
          elsif result.count == 0
            puts "  #{file_name} unmatched"
          end
        end
      else
        puts "  no #{file_type}s found"
      end
    end

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
