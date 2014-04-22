'use strict'
angular.module('Tribunals')
  .factory 'Api', ['$resource',($resource) ->
    {
      Decision: $resource('/admin/:tribunal_code/:id.json', {id: '@id', tribunal_code: gon.tribunal_code}, {
        update: { method: 'PUT' }
      }),
      Category: $resource('/admin/:tribunal_code/categories/:id.json', {id: '@id', tribunal_code: gon.tribunal_code}),
      Subcategory: $resource('/admin/:tribunal_code/subcategories/:id.json', {id: '@id', tribunal_code: gon.tribunal_code}),
      Judge: $resource('/admin/:tribunal_code/judges/:id.json', {id: '@id', tribunal_code: gon.tribunal_code})
    }
  ]
  