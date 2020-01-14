# frozen_string_literal: true

module CertModule
  class CompletionPdf < Prawn::Document
    def initialize(options)
      set_fallback_fonts
      tempfile = Tempfile.new('template')
      tempfile.write(Game.instance.completion_certificate_template.read.force_encoding('UTF-8'))
      tempfile.close
      options[:background] ||= tempfile.path
      options[:margin] ||= 0
      super(options)
    end

    def set_fallback_fonts
      font_families.update(
        'Helvetica-Bold' => { normal: Rails.root.join('lib/assets/fonts/Helvetica-Bold.ttf') },
        'TwitterColorEmoji' => { normal: Rails.root.join('lib/assets/fonts/TwitterColorEmoji.ttf') },
        'SourceHanSans' => { normal: Rails.root.join('lib/assets/fonts/SourceHanSans.ttf') }
      )
    end

    def fallback_fonts
      %w[TwitterColorEmoji SourceHanSans]
    end
  end
end
