# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

questionEdit = ->
  $('body').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-question').show();



action_cable_question = ->
  questionsList = $(".questions-list")

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionsList.append data
  })


$(document).on("turbolinks:load", questionEdit);
$(document).on("turbolinks:load", action_cable_question);
