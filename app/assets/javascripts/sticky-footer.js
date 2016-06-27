var stick = function () {
  $('body').css('margin-bottom', $('#page-footer').height() + 40);
}
$(document).ready(function () {
  stick();
});

$(window).resize(function () {
  stick();
});