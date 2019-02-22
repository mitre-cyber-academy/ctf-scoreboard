# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->
  ids = window.location.href.split('#')
  if ids.length > 1
    id = ids.pop(1)
    console.log 'here' #summaryTabs a[href="##{profile}"]'
    $("#summaryTabs a[href=\"##{id}\"]").tab('show')
