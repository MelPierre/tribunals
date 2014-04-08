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

    $scope.addCategory = ->
      $scope.decision.category_decisions.push {}

    $scope.removeCategory = (idx) ->
      $scope.decision.category_decisions.splice(idx,1)

    $scope.save = ->
      if $scope.decision.id
        Api.Decision.update $scope.decision, $saveSuccess, $saveError
      else
        Api.Decision.save $scope.decision, $saveSuccess, $saveError

    $saveSuccess = (data) ->
      $scope.decision = data
      if $scope.decision.errors
        # This probably makes sense to use a directive to render forms to ensure we display validation errors
        console.log('display errors')
      else
        window.location = '/' + gon.tribunal_id + '/' + $scope.decision.file_number

    $saveError = (data) ->


  ]