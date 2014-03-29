# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#products').imagesLoaded ->
    $('#products').masonry
      itemSelector: '.box'
      isFitWidth: true


if $('.pagination').length
        $(window).scroll ->
            url = $('.pagination .next_page a').attr('href')
            if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
                # What to do at the bottom of the page
                $('.pagination').text("Fetching more items...")
                $.getScript(url)
            $(window).scroll()
