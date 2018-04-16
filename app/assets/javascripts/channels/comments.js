var ready = function () {
  var $questionId = $('#question').data('id');
  App.cable.subscriptions.create({channel: 'CommentChannel', id: $questionId}, {
    connected: function () {
      this.perform('follow');
    },
    received: function (data) {
      if (data.comment.commented_type == 'Question') {
        $('#question').find('.comment').append("<p>"+data.comment.body+"</p>");
      } else {
        $("#answer-id-"+data.comment.commented_id).find('.comment').append("<p>"+data.comment.body+"</p>");
      }
    }
  })
};

$(document).on('turbolinks:load', ready);


