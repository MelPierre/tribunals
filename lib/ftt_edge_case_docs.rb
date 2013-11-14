
def find_doc id
  FttDecision.where("file_no_1 like :q or file_no_2 like :q or file_number like :q", q:"%#{id}%")
end

def munge_doc(decision, file_path)
  decision.add_single_doc file_path
  decision.process_doc
end

def doc_absent?(decision, doc_type)
  decision.send("#{doc_type}").blank?
end

def found_file(decision)
  decision.doc_file.file.path.split('/').last
end

def negative_result(decision)
  puts "  WARRNING: #{decision.id} already has a doc file #{found_file(decision)}"
end

def run_doc(decision, file_type, full_path)
  puts "  OK: #{decision.id} doesn't have a #{file_type} so #{full_path} can be used"
  munge_doc(decision, full_path) if file_type == "doc"
end

def multiple_decisions(result, dir, file_name)
  puts "Match found for #{dir}/#{file_name}, but there are multiple decisions matching"
  puts "Multiple IDs: #{result.map(&:id)}"
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
        decision = result.first
        puts "  Decision: #{decision.id} matches with #{file_name} !"

        if doc_absent?(decision, doc_type)
          full_path = "#{ENV['DOCS']}/#{dir}/#{file_name}.#{file_type}"
          run_doc(decision, file_type, full_path)
        else
          negative_result(decision)
        end

      elsif result.count > 1
        multiple_decisions(result, dir, file_name)
      elsif result.count == 0
        puts "  #{file_name} unmatched"
      end
    end
  else
    puts "  no #{file_type}s found"
  end
end
