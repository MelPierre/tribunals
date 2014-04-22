MoJ Tribunals
=============

[![Build Status](https://travis-ci.org/ministryofjustice/tribunals.png?branch=master)](https://travis-ci.org/ministryofjustice/tribunals)

About
-----
A Ruby on Rails application for giving public access to UK Tribunal decisions.

Live at https://tribunalsdecisions.service.gov.uk/

Installation
------------

Clone the repo & cd into it. Then

    gem install bundler
    bundle install

If you don't have Qt installed (capybara gem will let you know, as it
will fail building), you'll need to install it. On OS X:

    brew install qt

If you don't have libxml2 installed (nokogiri gem will let you know, as it
will fail building), you'll need to install it. On OS X:

    brew install libxml2

On **OS X**: install http://postgresapp.com/ After installation, click the
elephant icon in the task bar and select **open psql**.

In the terminal window that opens, type:

    bundle exec rake db:create

            or

    create database tribunals_development;

After a brief pause, it should say **CREATE DATABASE**. Quit **psql**.

Then

    bundle exec rake db:migrate

Then
    bundle exec rake db:seed
    bundle exec rake data:seed_tribunals

Run

    ./bin/passwd db/password.hash

to generate a password for the web admin.

This application requires 'soffice', a binary that comes with Libre
Office. See the **section below** on how to install Libre Office for
the appropriate OS.

Then start the app:

    rails s

Configuration
-------------

In order to upload decisions in the development environment, please
configure the CarrierWave uploaders to use the local file system by
including the line 'storage :file' instead of 'storage :fog' in the
files: app/uploaders/doc_file_uploader.rb and
app/uploaders/pdf_file_uploader.rb.

Installing libreoffice on OSX
-----------------------------

Download and install the standard LibreOffice application. You will
need to add the binaries to your path though. Simply add this line:

    export PATH="$PATH:/Applications/LibreOffice.app/Contents/MacOS"

to the bottom of your ~/.bash_profile and then re-read your config for
the change to take effect:

    source ~/.bash_profile


Installing libreoffice on Ubuntu
--------------------------------

    sudo apt-get update
    sudo apt-get install libreoffice

Importing from legacy system
----------------------------

In the import rake namespace are the scripts to scrape the exisiting
sites. They will not process the word documents though, and that needs
to be done with `rake import:import_word_docs_from_urls`.

### Importing AAC decisions data

Run the following sequence of rake tasks:

    rake import:aac:decisions
    rake import:aac:decision_categories
    rake import:aac:decision_subcategories
    rake import:aac:judges
    rake import:aac:decisions_judges_mapping

### Importing EAT data export

Run the following task:

    rake import:eat:all

If you need to find out the individual tasks, run the following
command to get the listing:

    rake -T import:eat

### Generating friendly_slugs for migrated decisions

To support the history of the permanent links for the decisions, we use history feature of friendly_id gem. To make it work with data that has been migrated, it needs to re-save all the decisions, to create the history entry in the table "friendly_id_slugs". You can run the task:

    rake data:generate_friendly_slugs


Tips
----

* On OS X, having LibreOffice open whilst processing docs will fail the processing

Deployment notes
---------------

### 1. db:migrate

### 2. data:seed_tribunals
Will create the current tribunals

### 3. data:convert:all
Will convert all old format data to new format data

