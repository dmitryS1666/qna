$(document).on('turbolinks:load', function () {
  var $answers = $('.answers');

  $answers.on('click', '#edit-answer-button', function (e) {
    e.preventDefault();
    var answerId = $(this).data('edit-id');
    $(this).hide();
    $('#edit_answer_' + answerId).show();
  });
});


