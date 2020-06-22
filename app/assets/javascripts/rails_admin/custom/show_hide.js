$( document ).ready(function() {
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

  // Show or hide sponsorship info based on sponsored tickbox
  function toggleSponsorField() {
      var elems = $('.sponsorship_fields_toggle')
      if ($('.sponsorship_fields_toggler').find('input')[1].checked) {
          elems.show()
      } else {
          elems.hide()
      }
  }

  // Show or hide completion certificates based on certificates tickbox
  function toggleCertAndPrizes() {
      if (document.getElementById('game_enable_completion_certificates').checked) {
          document.getElementById('game_completion_certificate_template_field').style.display = "";
      } else {
          document.getElementById('game_completion_certificate_template_field').style.display = "none";
      }
      if (document.getElementById('game_prizes_available').checked) {
        document.getElementById('game_prizes_text_field').style.display = "";
      } else {
        document.getElementById('game_prizes_text_field').style.display = "none";
    }
  }
});