# frozen_string_literal: true

require 'yaml'
require 'rubygems' # import gem package manager
require 'ffi/hunspell' # inject Hunspell class to Ruby namespace

def extract_strings(data, extracted, prefix = '')
  if data.is_a?(Hash)
    data.each do |key, value|
      extract_strings(value, extracted, prefix.empty? ? key : "#{prefix}.#{key}")
    end
  else
    extracted << data
  end
end

task spellcheck: :environment do
  data = YAML.load_file('config/locales/en.yml')
  
  extracted = []
  phrases = []
  whitelist = %w[aff create_admin github href https mitre cyber ctf starttime challengename full_name fullname team_name teamname team_size messagetitle CTF Gameboard start_time end_time contact_url]

  extract_strings(data, extracted)

  extracted.each do |item|
    phrases << item.split(/\W+/)
  end

  FFI::Hunspell.dict do |dict|
    phrases.each do |phrase|
      phrase.each do |word|
        unless whitelist.include? word
          puts "Is i18n '#{word}' correct? Did you mean: #{dict.suggest(word)}" if dict.check?(word) == false
        end
      end
    end
  end
end
