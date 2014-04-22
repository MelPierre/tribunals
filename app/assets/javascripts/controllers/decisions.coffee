angular.module('Tribunals')
  .controller 'DecisionsController', ['$scope', 'Api', ($scope, Api) ->
    $scope.judges = Api.Judge.query()
    $scope.categories = Api.Category.query()
    $scope.decision = new Api.Decision()

    if gon.decision_id
      $scope.decision = Api.Decision.get id: gon.decision_id, (data) ->
        console.log(data)
        $scope.decision = data 

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
        Api.Decision.update { id: $scope.decision.id, all_decision: $scope.decision }, $saveSuccess, $saveError
      else
        Api.Decision.save { id: $scope.decision.id, all_decision: $scope.decision }, $saveSuccess, $saveError

    $saveSuccess = (data) ->
      $scope.decision = data.all_decision
      if $scope.decision.errors
        # This probably makes sense to use a directive to render forms to ensure we display validation errors
        console.log('display errors')
      else
        console.log(data)
        #window.location = '/admin/' + gon.tribunal_code + '/' + $scope.decision.file_number

    $saveError = (data) ->
      alert('Poop')

  ]