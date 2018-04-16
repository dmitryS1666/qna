var ready = function () {
   App.cable.subscriptions.create('QuestionChannel', {
    connected: function () {
      this.perform('follow');
    },

    received: function (data) {
      var $question_list = $('table.question_list');
      $question_list.append(data);
    }
  })
};

$(document).on('turbolinks:load', ready);