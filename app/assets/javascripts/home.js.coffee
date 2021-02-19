# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->
  clock = $('#time_remaining')
  updateClock(clock)
  setInterval(updateClock, 1000, clock)

countdown = (endTime) ->
  diff = endTime - new Date()

  diff = 0 if diff < 0
  days = Math.floor(diff/1000/60/60/24)
  diff -= days * 1000*60*60*24
  hours = Math.floor(diff/1000/60/60)
  diff -= hours * 1000*60*60
  minutes = Math.floor(diff/1000/60)
  diff -= minutes * 1000*60
  seconds = Math.floor(diff/1000)
  return {"days": days, "hours": hours, "minutes":minutes, "seconds":seconds}

updateClock = (clock_elem) ->
  t = countdown(new Date(parseFloat(clock_elem.data('endtime'))))
  clock_elem.text(
    'Time Remaining: ' +
    t.days + 'd ' +
    t.hours + 'h ' +
    t.minutes + 'm ' +
    t.seconds + 's'
  )
  if t.total <= 0
    clearInterval timeinterval
  return
