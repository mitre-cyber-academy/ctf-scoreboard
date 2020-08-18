# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

# Provides show and hide feature to a clickable element with "toggler" class

$(document).ready ->
	$('.toggler').click (e) ->
		$('#hiddenUntilToggle').toggleClass("d-none")
		e.preventDefault()
		return
	return
