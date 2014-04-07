'use strict'
angular.module('Tribunals')
  .factory 'Api', ['$resource',($resource) ->
    {
      Decision: $resource('/admin/:tribunal_id/:id.json', {id: '@id', tribunal_id: gon.tribunal_id}),
      Category: $resource('/admin/:tribunal_id/categories/:id.json', {id: '@id', tribunal_id: gon.tribunal_id}),
      Subcategory: $resource('/admin/:tribunal_id/subcategories/:id.json', {id: '@id', tribunal_id: gon.tribunal_id}),
      Judge: $resource('/admin/:tribunal_id/judges/:id.json', {id: '@id', tribunal_id: gon.tribunal_id})
    }
  ]
  