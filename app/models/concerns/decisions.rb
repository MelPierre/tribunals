module Decisions
  extend ActiveSupport::Concern
  included do
    has_many :import_errors
    def process_doc
      if doc_file.present?
        Dir.mktmpdir do |tmp_html_dir|
          Dir.chdir(tmp_html_dir) do
            doc_rel_filename = File.basename(self.doc_file.file.path)
            doc_abs_filename = File.join(tmp_html_dir, doc_rel_filename)
            File.open(doc_abs_filename, 'wb') do |f|
              f.write(doc_file.sanitized_file.read)
            end
            [:pdf, "txt:text"].map do |type|
              system("soffice --headless --convert-to #{type} --outdir . '#{doc_rel_filename}'")
            end
            txt_filename = doc_abs_filename.gsub(/\.doc$/i, '.txt')
            pdf_filename = doc_abs_filename.gsub(/\.doc$/i, '.pdf')
            self.text = File.open(txt_filename, 'r:bom|utf-8').read
            self.set_html_from_text
            self.pdf_file = File.open(pdf_filename)
            self.save!
          end
        end
      end
    rescue StandardError => e
      puts e
      self.import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
    end

    def set_html_from_text(cache={})
      if self.text
        # line breaks
        self.html = self.text.gsub(/\n/, '<br/>')

        # references to other decisions
        citation_pattern = /\[[0-9]{4}\]\s*[0-9]*\s+[A-Z]+\s*[A-Za-z\.]*\s*[0-9]*/ # (see http://ox.libguides.com/content.php?pid=141334&sid=1205598)

        self.html = self.html.gsub(citation_pattern) do |citation|
          normalised_citation = citation.gsub(/\s+0+([1-9])/, ' \1')
          decision = cache[normalised_citation] || Decision.find_by(appeal_number: normalised_citation) || (next citation)
          decision_url = Tribunals::Application.routes.url_helpers.decision_path(decision)
          "<a href='"+decision_url+"'>"+citation+"</a>"
        end
      end
    end
  end
end