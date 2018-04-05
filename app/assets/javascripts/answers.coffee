# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

answerEdit = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();


action_cable_answer = ->
  answersList = $("#answers_list")

  appendAnswer = (data) ->
    console.log(data);
    return if $("#answer_#{data.id}")[0]?
    answersList.append App.utils.render('answer', data)

  App.cable.subscriptions.create "AnswersChannel", {
    connected: ->
#      @follow()
    connected: ->
      @perform 'follow'
    ,
#    follow: ->
#      return unless gon.question_id
#      @perform 'follow', id: gon.question_id

    received: (data) ->
      answersList.append data
#      appendAnswer(data)
  }

$(document).on("turbolinks:load", answerEdit);
$(document).on("turbolinks:load", action_cable_answer);
