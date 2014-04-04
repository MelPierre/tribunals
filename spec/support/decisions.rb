def all_decision_hash(h={})
  {
    neutral_citation_number: '2013 UKUT 500 AAC',
    doc_file: sample_doc_file,
    decision_date: Date.today,
    claimant: 'John Smith',
    respondent: 'Partnerships in Care and Secrerary of State for Justice'
  }.merge(h)
end

def decision_hash(h={})
  {
    ncn: [2013, 'UKIT', rand(31337)].join(' '),
    doc_file: sample_doc_file,
    promulgated_on: Date.today,
    claimant: 'John Smith',
    reported: true,
    country: 'Gibraltar',
    country_guideline: false,
    judges: ['Judge Dredd']
  }.merge(h)
end

def aac_decision_hash(h={})
  {
    ncn: '2013 UKUT 500 AAC',
    doc_file: sample_doc_file,
    decision_date: Date.today,
    claimant: 'John Smith',
    respondent: 'Partnerships in Care and Secrerary of State for Justice',
    is_published: true,
    aac_decision_subcategory_id: 172
  }.merge(h)
end

def ftt_decision_hash(h={})
  {
    file_number: 'v18158',
    doc_file: sample_doc_file,
    decision_date: Date.today,
    claimant: 'Will Smith',
    respondent: 'Men in Black',
    is_published: true
  }.merge(h)
end

def eat_decision_hash(h={})
  {
    file_number: 'v18158',
    filename: 'EAT/123/45.doc',
    doc_file: sample_doc_file,
    decision_date: Date.today,
  }.merge(h)
end
