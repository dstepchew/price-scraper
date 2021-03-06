# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#pins').imagesLoaded ->
    $('#pins').masonry
      itemSelector: '.box'
      isFitWidth: true

$ ->
  $('#products').imagesLoaded ->
    $('#products').masonry
      itemSelector: '.box'
      isFitWidth: true
$ ->
  $('a.load-more-products').on 'inview', (e, visible) ->
    return unless visible

    $.getScript $(this).attr('href')
