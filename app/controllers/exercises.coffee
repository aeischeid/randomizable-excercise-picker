Spine = require('spine')
Exercise = require('models/exercise')

class Exercises extends Spine.Controller
	events:
		'click #spinner'   :'spin'
		'click #addNew'    :'addNew'
		'submit #create'   :'create'
		'click #remove'    :'list'
		'click a.delete'   :'destroy'
		'click button.back':'render'
		'click #destroyAll':'destroyAll'
		'click #cancel'    :'list'
	
	elements:
		'#currentReps'    :'currentReps'
		'#currentExercise':'currentExercise'
		'#exerciseData'   :'exerciseData'
		'form #create'    :'createForm'
		'#itemList'       :'itemList'
	
	constructor: ->
		super
		Exercise.fetch()
		@render()
	
	render: (e)->
		e?.preventDefault()
		@html require('views/main')
	
	spin: (e)->
		e?.preventDefault()
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
			@currentReps.addClass('flipX')
			@currentExercise.addClass('flipX')
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
					@currentReps.removeClass('flipX')
					@currentExercise.removeClass('flipX')
			), 1000
		else
			@populate()
	
	populate: ->
		if confirm 'You do not have anything to spin through. Want to use a default set of excercises?'
			Exercise.one 'loadedDefaults', (count)=>
				alert "Sweet, loaded #{count} excercises, ready to get sweaty?"
				@spin()
			Exercise.loadDefaults(@spin)
	
	addNew: (e)->
		e.preventDefault()
		$('#adder').html require('views/exerciseForm')
	
	create: (e)->
		e?.preventDefault()
		exercise = Exercise.fromForm($('#create'))
		exercise.save()
		@list()
	
	list: (e)->
		e?.preventDefault()
		@html require('views/list')
		items = ''
		for item in Exercise.all()
			items += require('views/listItem')(item)
		@itemList.prepend items
	
	destroy: (e)->
		e.preventDefault()
		item = $(e.target)
		itemId = item.data('id')
		#@log itemId
		Exercise.find(itemId).destroy()
		item.parent().slideUp()
		#since we slide the item out of view there is no need to re-render the list.
		#@list()
	
	destroyAll: (e)->
		e.preventDefault()
		if confirm 'really?!'
			Exercise.destroyAll()
			@list()
		
	getRandomInt: (min, max)->
		Math.floor(Math.random() * (max - min + 1)) + min
	
module.exports = Exercises
