$(document).on('rails_admin.dom_ready', function() {

  // Run if we're in the challenge page
  if($('.sponsorship_fields_toggler').length){
    toggleSponsorField()
    $('.sponsorship_fields_toggler').find('input')[1].addEventListener('change', toggleSponsorField);
  }

  // Run if we're in the game page
  if($('.enable_completion_certificates_field').length){
      toggleCertAndPrizes();
      document.getElementById('game_enable_completion_certificates').addEventListener('change', toggleCertAndPrizes);
      document.getElementById('game_prizes_available').addEventListener('change', toggleCertAndPrizes);
  }

  // Wrapper for all showing/hiding of sponsors
  function toggleSponsorField() {
    var elements = $(".sponsorship_fields_toggle")
    var checkbox_id = $('.sponsorship_fields_toggler').find('input')[1].id
    elements.toArray().forEach(element => showOrHide(checkbox_id, element.id))
  }

  // Wrapper for all showing/hiding of game prizes/completion certificates
  function toggleCertAndPrizes() {
    showOrHide('game_enable_completion_certificates', 'game_completion_certificate_template_field')
    showOrHide('game_prizes_available', 'game_prizes_text_field')
  }

  // Show or hide based off a checkbox
  function showOrHide(checkboxId, fieldToToggle){
    if(document.getElementById(checkboxId).checked){
      document.getElementById(fieldToToggle).style.display = "";
    }
    else{
      document.getElementById(fieldToToggle).style.display = "none";
    }
  }
});
