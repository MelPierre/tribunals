ENV['PATH'] += ':/opt/libreoffice4.0/program/'

# This should load from env, these are for defaults
ENV['DEVISE_SECRET'] ||= '12341241243124124124124124124124'
ENV['DEVISE_SENDER'] ||= 'no-reply@tribunalsdecisions.service.gov.uk'

ENV['SMTP_HOST']      ||= 'tribunalsdecisions.service.gov.uk'
ENV['SMTP_HOSTNAME']  ||= "localhost"
ENV['SMTP_USERNAME']  ||= ""
ENV['SMTP_PASSWORD']  ||= ""