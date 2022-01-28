$(document).on('rails_admin.dom_ready', function() {
  if($('.markdown-input').length && $('.markdown-output').length) {
    const input = $('.markdown-input')[0]
    const output = $('.markdown-output')[0]
    output.innerHTML = marked.parse(input.value)
    input.addEventListener('input', function(a,b) {
      output.innerHTML = marked.parse(input.value)
    })
  }
});