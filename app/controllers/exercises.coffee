Spine = require('spine')
Exercise = require('models/exercise')

class Exercises extends Spine.Controller
	events:
		'click #spinner':'spin'
		'click #addNew':'addNew'
		'submit #create':'create'
		'click #remove':'list'
		'click a.delete':'destroy'
		'click button.back':'render'
	
	elements:
		'#currentReps':'currentReps'
		'#currentExercise':'currentExercise'
		'#exerciseData':'exerciseData'
		'form #create':'createForm'
	
	constructor: ->
		super
		Exercise.fetch()
		@render()
	
	render: (e)->
		e?.preventDefault()
		@html require('views/main')
	
	spin: (e)->
		e.preventDefault()
		#@log 'spin!!!'
		eCount = Exercise.count()
		if eCount
			# pick random exercise
			randomInt = @getRandomInt(0,eCount-1)
			#@log randomInt
			@items = Exercise.all()
			randomExercise = @items[randomInt]
			#@log randomExercise
			e = 0
			ei = setInterval ( =>
				if e <= randomReps
					try
						@currentExercise.text @items[e].name
					catch err
						@currentExercise.text randomExercise.name
					e++
			), 56
			# from that exercise pick random between it's 'minReps and maxReps
			randomReps = @getRandomInt(parseInt(randomExercise.minReps,10), parseInt(randomExercise.maxReps,10))
			i = 0
			ri = setInterval ( =>
				if i <= randomReps
					@currentReps.text i 
					i++
			), 24
			setTimeout ( =>
					clearInterval(ei)
					@currentExercise.text randomExercise.name
					clearInterval(ri)
					@currentReps.text randomReps
			), 1000
		else
			alert 'better add some exercises'
			if confirm 'want to use a default set?'
				Exercise.loadDefaults()
	
	addNew: (e)->
		e.preventDefault()
		@html require('views/exerciseForm')
	
	create: (e)->
		e?.preventDefault()
		exercise = Exercise.fromForm($('#create'))
		exercise.save()
		@html "<h3>Saved #{exercise.name}!</h3>"
		# delay to give feedback that exercise was added
		setTimeout ( =>
			@render()
		), 800
	
	list: (e)->
		e?.preventDefault()
		@items = Exercise.all()
		@html require('views/list')
		$('#itemList').html require('views/listItem')(@items)
	
	destroy: (e)->
		e.preventDefault()
		item = $(e.target)
		itemId = item.data('id')
		#@log itemId
		Exercise.find(itemId).destroy()
		item.parent().slideUp()
		#since we slide the item out of view there is no need to re-render the list.
		#@list()
		
	getRandomInt: (min, max)->
		Math.floor(Math.random() * (max - min + 1)) + min
	
module.exports = Exercises
