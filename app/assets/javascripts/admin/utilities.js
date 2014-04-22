$(document).ready(function() {
  var memoInput = null;
  $('.add_text_field').click(function(event){
    event.preventDefault();
    parent = $(event.target).parent();
    memoInput = parent.find('input:last').clone();
    splitIdElements = memoInput.attr('id').split('_');
    position = splitIdElements.length - 1;
    splitIdElements[position] = (parseInt(splitIdElements[position]) + 1);
    memoInput = memoInput.attr('id', splitIdElements.join('_'));
    parent.append(memoInput)
  });
});