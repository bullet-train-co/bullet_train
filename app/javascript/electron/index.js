$(document).on('turbolinks:load', function() {
  if (navigator.userAgent.toLocaleLowerCase().includes('electron')) {
    $('body').addClass('electron')
  }
})