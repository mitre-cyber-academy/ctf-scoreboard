# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->
  ids = window.location.href.split('#')
  if ids.length > 1
    id = ids.pop(1)
    $("#summaryTabs a[href=\"##{id}\"]").tab('show')

  $('#summaryTabs').on 'click', 'li', (event) ->
    activeTab = $(this).find('a').attr('href')
    base = window.location.href.split('#')[0]
    window.location.href = base + activeTab
