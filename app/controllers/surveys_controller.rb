# frozen_string_literal: true

class SurveysController < ApplicationController
  def create
    @survey = Survey.new(survey_params)
    if(@survey.save)
      return redirect_to '/game', notice: I18n.t('surveys.submitted')
    else
      return redirect_to '/game', notice: @survey.errors.full_messages
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:difficulty, :realism, :interest, :comment, :submitted_flag_id, :team_id)
  end
end
