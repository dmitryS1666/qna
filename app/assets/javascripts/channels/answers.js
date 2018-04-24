var ready = function () {
  var $questionId = $('#question').data('id');
 
  App.cable.subscriptions.create({channel: 'AnswersChannel', id: $questionId}, {
    connected: function () {
      this.perform('follow');
    },

    received: function (data) {
      if (data.answer.user_id != gon.user_id) {
        $('.answers').append(JST["templates/answer"](data));
      }
    }
  })
};



$(document).on('turbolinks:load', ready);