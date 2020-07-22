# frozen_string_literal: true

class SurveysController < ApplicationController
  def create
    @survey = Survey.new(survey_params)

    redirect_to '/game', notice: I18n.t('surveys.submitted') if @survey.save
  end

  private

  def survey_params
    params.require(:survey).permit(:difficulty, :realism, :interest, :comment, :submitted_flag_id)
  end
end
