var ready = function () {
   App.cable.subscriptions.create('QuestionsChannel', {
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