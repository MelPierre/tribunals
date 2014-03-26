ENV['PATH'] += ':/opt/libreoffice4.0/program/'

# This should load from env, these are for defaults
ENV['DEVISE_SECRET'] ||= 'd7696803e3346cf1dc3feb240751ed3d80daac90ad52e9d8f5278b2417259db43f41eb4368ca330c2345fb214385a65cb0317e69ccae528b51d93ac886dd19e1'
ENV['DEVISE_SENDER'] ||= 'no-reply@tribunalsdecisions.service.gov.uk'

ENV['SMTP_HOST'] ||= 'tribunalsdecisions.service.gov.uk'