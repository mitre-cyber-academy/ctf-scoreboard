showHideState = () ->
  if $('#countries_select').val() == "US"
    $('#state').show()
  else
    $('#state').hide()

filterifficShowHideState = () ->
  if $('#filterrific_country').val() == "US"
    $('#state').show()
  else
    $('#filterrific_state').val('')
    document.getElementById("filterrific_state")
            .dispatchEvent(new Event("change"))
    $('#state').hide()

window.runOnPageLoad = () ->
  showHideState()
  # filterifficShowHideState()
  $('#filterrific_country').change(filterifficShowHideState)
  $('#countries_select').change(showHideState)
  if $('#user_state').val() == "NA" or $('#user_year_in_school').val() == "0"
    $('#compete-for-prizes').hide()
    $('#user_compete_for_prizes').prop("checked", false)
  else
    $('#compete-for-prizes').show()
$(document).ready(window.runOnPageLoad)
$(document).on('page:load', window.runOnPageLoad)
