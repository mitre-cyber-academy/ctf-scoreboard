window.runOnPageLoad = () ->
	$('input[type=file]').bootstrapFileInput()
	if $('#user_state').val() == "NA" or $('#user_year_in_school').val() == "0"
		$('#compete-for-prizes').hide()
		$('#user_compete_for_prizes').prop("checked", false)
	else
		$('#compete-for-prizes').show()
$(document).ready(window.runOnPageLoad)
$(document).on('page:load', window.runOnPageLoad)
