# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

answerEdit = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

$(document).on("turbolinks:load", answerEdit);


$ ->
  App.cable.subscriptions.create "AnswersChannel", {
    connected: ->
      @follow()

    follow: ->
      return unless gon.question_id
      @perform 'follow', id: gon.question_id

    received: (data) ->
      appendAnswer(data)
  }