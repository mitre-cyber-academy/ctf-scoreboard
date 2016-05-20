window.hidePrizesCheckbox = (elem) ->
  if elem.value == "0" or elem.value == "NA"
    $('#compete-for-prizes').hide()
    $('#user_compete_for_prizes').prop("checked", false);
  else
    $('#compete-for-prizes').show()   
