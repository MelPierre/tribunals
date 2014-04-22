/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.init();


(function(){

  $('a[data-disabled]:not([data-disabled="false"])').on('click', function(e){
    e.preventDefault();
  });
  
}());
