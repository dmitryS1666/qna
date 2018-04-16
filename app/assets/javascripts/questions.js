$(document).on('turbolinks:load', function () {
  var $question = $('#question');
  $question.on('click', '#edit-question-button', function (e) {
    e.preventDefault();
    $(this).hide();
    //alert (id_edit)
    $('.edit_question').show();
  });
});

