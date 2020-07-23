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
  
  foundTypo = false
  extracted = []
  phrases = []
  whitelist = %w[create_admin href https mitre cyber ctf github starttime challengename full_name
                 fullname team_name teamname team_size messagetitle CTF Gameboard start_time
                 end_time contact_url Didn]
  I18n.load_path.each do |localization|
    data = YAML.load_file(localization) if localization.include?(Rails.root.to_s)
    extract_strings(data, extracted) if localization.include?(Rails.root.to_s)
  end

  extracted.each do |item|
    phrases << item.split(/\W+/)
  end

  FFI::Hunspell.dict('en_US') do |dict|
    phrases.each do |phrase|
      phrase.each do |word|
        unless whitelist.include? word
          if dict.check?(word) == false then
            puts "Is i18n '#{word}' correct? Did you mean: #{dict.suggest(word)}"
            foundTypo = true
          end
        end
      end
    end
  end
  exit(1) if foundTypo
end
