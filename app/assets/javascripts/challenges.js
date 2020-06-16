// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Purpose: Provides show and hide feature to a clickable element with "toggler" class
// Date: 6/16/2020

$(document).ready(function() {
    $(".toggler").click(function(e) {
        e.preventDefault();
      $(".hide").toggle("hide");
    });
  });
