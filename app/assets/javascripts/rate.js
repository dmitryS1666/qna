$(document).on('turbolinks:load', function () {
  var $question = $('#question');
  var $answers = $('.answers');

  var idItem = function ($parent){
    return $parent.data('id');
  };

  var afterVote = function ($parent, data){
    $parent.find('.vote_score').text(data.rating);
    $parent.find('#vote-reset-btn').toggle();
    $parent.find('#vote-up-btn').toggle();
    $parent.find('#vote-down-btn').toggle();
  };
//questions
  $question.on('click', '#vote-reset-btn', function (e) {
    e.preventDefault();
    $parent = $(this).closest('.vote');
    $.post('/questions/' + idItem($parent) + '/vote_reset')
    .done(function(data) {
      afterVote($parent, data)
    })
  });

  $question.on('click', '#vote-up-btn', function (e) {
    e.preventDefault();
    $parent = $(this).closest('.vote');
    $.post('/questions/' + idItem($parent) + '/vote_up')
    .done(function(data) {
      afterVote($parent, data)
    })
  });

  $question.on('click', '#vote-down-btn', function (e) {
    e.preventDefault();
    $parent = $(this).closest('.vote');
    $.post('/questions/' + idItem($parent) + '/vote_down')
    .done(function(data) {
      afterVote($parent, data)
    })
  });
//answers
  $answers.on('click', '#vote-up-btn', function (e) {
    e.preventDefault();
    $parent = $(this).closest('.vote');
    $.post('/answers/' + idItem($parent) + '/vote_up')
    .done(function(data) {
      afterVote($parent, data)
    })
  });

  $answers.on('click', '#vote-down-btn', function (e) {
    e.preventDefault();
    $parent = $(this).closest('.vote');
    $.post('/answers/' + idItem($parent) + '/vote_down')
    .done(function(data) {
      afterVote($parent, data)
    })
  });

  $answers.on('click', '#vote-reset-btn', function (e) {
    e.preventDefault();
    $parent = $(this).closest('.vote');
    $.post('/answers/' + idItem($parent) + '/vote_reset')
    .done(function(data) {
      afterVote($parent, data)
    })
  });
});
