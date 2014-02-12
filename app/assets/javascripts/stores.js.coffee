# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#sales_price_selector").change ->
    if $("#sales_price_selector").is(':checked') == false
      $(".price_selector").hide()
    else
      $(".price_selector").show()
  return
