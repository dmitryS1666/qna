addVote = ->
  $('.vote').bind 'ajax:success', (e) ->
    $(this).parent().find('.rating').html(e.detail[0].rating)
  $('.vote').bind 'ajax:error', (e) ->
    $(this).parent().find('.errors').html(e.detail[0].error_message)

$(document).ready(addVote)
$(document).on('turbolinks:load', addVote)