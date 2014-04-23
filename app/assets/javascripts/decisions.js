/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.decisions = (function() {
  "use strict";

  var $form,
      $fs,
      $adv,
      $resetBtns;

  var init = function() {
    cacheEls();
    bindEvents();
  };

  var cacheEls = function() {
    $form = $('.search_form').eq(0);
    $fs = $('#advanced_search');
    $resetBtns = $('button[type=reset]', $form);
    $adv = $('#search_reported_only', $form);
  };

  var bindEvents = function() {
    $('input:radio', $fs).on('change', searchToggle);

    $($form).on('change', '.js-submit-onChange', submitForm);
    $('.add_text_field').on('click', addNewTextField);
    $('select', $fs).mojAutocomplete();

    $($resetBtns).on('click', function (e) {
      e.preventDefault();
      resetFilters();
    });

    $form.submit(function (e) {
      if(typeof ga != 'undefined')
        ga('send', 'event', 'Search', 'Top', $('#search_query').val());
    });

    $('a.pdf-file').click(function (e) {
      if(typeof ga != 'undefined')
        ga('send', 'event', 'Download', 'PDF', $(this).attr('href'));
    });

    $('a.doc-file').click(function (e) {
      if(typeof ga != 'undefined')
        ga('send', 'event', 'Download', 'DOC', $(this).attr('href'));
    });
  };

  var addNewTextField = function(event){
    event.preventDefault();
    var parent = $(event.target).parent();
    var memoInput = parent.find('input:last').clone();
    var splitIdElements = memoInput.attr('id').split('_');
    var position = splitIdElements.length - 1;
    memoInput.addClass('dynamically-added-input-field');
    splitIdElements[position] = (parseInt(splitIdElements[position]) + 1);
    memoInput = memoInput.attr('id', splitIdElements.join('_'));
    parent.append(memoInput)
  };

  var resetFilters = function() {
    $form.find('input[type=text], select').val('');
    $('#search_reported_all').trigger('click');
    $adv.show();
  };

  var searchToggle = function() {
    $adv.toggle(!$('#search_reported_false').is(':checked'));
  };

  var submitForm = function() {
    $form.submit();
  };

  // public

  return {
    init: init
  };
}());
