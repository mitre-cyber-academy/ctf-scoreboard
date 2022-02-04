# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->
  $('.copy-contents-btn').click (event) =>
    navigator.clipboard.writeText(event.currentTarget.nextElementSibling.value)

