angular.module('Tribunals',['ngResource', 'ngSanitize', 'ngQuickDate'])
  .config ($httpProvider) ->
    authToken = $('meta[name="csrf-token"]').attr('content')
    console.log('auth token' + authToken)
    $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = authToken
    $httpProvider.defaults.headers.common['Content-Type'] = 'application/json'

