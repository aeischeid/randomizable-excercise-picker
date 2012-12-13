Spine = require('spine')

class Exercise extends Spine.Model
	@configure 'Exercise', 'name', 'minReps', 'maxReps'
	@extend Spine.Model.Local
	
	defaultSet = [
		{'name':'Burpees','minReps':3,'maxReps':10},
		{'name':'Push-ups','minReps':10,'maxReps':30},
		{'name':'Lunges','minReps':10,'maxReps':30},
		{'name':'Squats','minReps':15,'maxReps':30},
		{'name':'Single leg deadlift','minReps':5,'maxReps':15},
		{'name':'Box step overs','minReps':5,'maxReps':15},
		{'name':'Step ups','minReps':15,'maxReps':30},
		{'name':'Dips','minReps':15,'maxReps':30},
		{'name':'Get ups','minReps':3,'maxReps':10},
		{'name':'Jump Lunges','minReps':5,'maxReps':10},
		{'name':'Rocket Launchers','minReps':5,'maxReps':10},
		{'name':'Reverse crunches','minReps':15,'maxReps':30},
		{'name':'Crunches','minReps':20,'maxReps':50},
		{'name':'Full body crunches','minReps':5,'maxReps':20},
		{'name':'Mountain climbers','minReps':10,'maxReps':20},
		{'name':'Military press','minReps':10,'maxReps':20},
		{'name':'Flys / Reverse flys','minReps':10,'maxReps':20}
	]
	
	@loadDefaults: ->
		for exercise in defaultSet
			newOne = new Exercise(exercise)
			newOne.save()
		alert "sweet, loaded #{defaultSet.length} items!"
			
module.exports = Exercise
