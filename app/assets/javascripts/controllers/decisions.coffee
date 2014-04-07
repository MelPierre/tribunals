angular.module('Tribunals')
  .controller 'DecisionsController', ['$scope', 'Api', ($scope, Api) ->
    $scope.judges = Api.Judge.query()
    $scope.categories = Api.Category.query()
    
    if gon.decision_id
       Api.Decision.get id: gon.decision_id, (data) ->
        $scope.decision = data 
    else
      $scope.decision = new Api.Decision()

    $scope.addJudge = ->
      if $scope.new_judge
        $scope.decision.all_judges.push $scope.new_judge
        $scope.new_judge = null

    $scope.removeJudge = (idx) ->
      $scope.decision.all_judges.splice(idx, 1)

  ]