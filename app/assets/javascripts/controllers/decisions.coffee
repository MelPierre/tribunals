angular.module('Tribunals')
  .controller 'DecisionsController', ['$scope', 'Api', ($scope, Api) ->
    console.log(gon)
    if gon.decision_id
      $scope.decision = Api.Decision.get(id: gon.decision_id)
      console.log($scope.decision)
    else
      $scope.decision = new Api.Decision()


  ]