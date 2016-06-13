module UserHelper
  def check_if_user_on_team
    redirect_to current_user.team, alert: I18n.t('teams.already_on_team_join') if current_user.on_a_team?
  end

  def years_in_school
    [
      %w(9 9), %w(10 10), %w(11 11), %w(12 12),
      ['College - Freshman', '13'],
      ['College - Sophomore', '14'],
      ['College - Junior', '15'],
      ['College - Senior', '16'],
      ['Graduate Student', '0'],
      ['Not in School', '0']
    ]
  end

  # rubocop:disable Metrics/MethodLength
  def us_states
    [
      %w(Alabama AL),
      %w(Alaska AK),
      %w(Arizona AZ),
      %w(Arkansas AR),
      %w(California CA),
      %w(Colorado CO),
      %w(Connecticut CT),
      %w(Delaware DE),
      ['District of Columbia', 'DC'],
      %w(Florida FL),
      %w(Georgia GA),
      %w(Hawaii HI),
      %w(Idaho ID),
      %w(Illinois IL),
      %w(Indiana IN),
      %w(Iowa IA),
      %w(Kansas KS),
      %w(Kentucky KY),
      %w(Louisiana LA),
      %w(Maine ME),
      %w(Maryland MD),
      %w(Massachusetts MA),
      %w(Michigan MI),
      %w(Minnesota MN),
      %w(Mississippi MS),
      %w(Missouri MO),
      %w(Montana MT),
      %w(Nebraska NE),
      %w(Nevada NV),
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      %w(Ohio OH),
      %w(Oklahoma OK),
      %w(Oregon OR),
      %w(Pennsylvania PA),
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      %w(Tennessee TN),
      %w(Texas TX),
      %w(Utah UT),
      %w(Vermont VT),
      %w(Virginia VA),
      %w(Washington WA),
      ['West Virginia', 'WV'],
      %w(Wisconsin WI),
      %w(Wyoming WY),
      ['Outside US', 'NA']
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
