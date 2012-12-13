require('lib/setup')

Spine = require('spine')
Exercises = require('controllers/exercises')

class App extends Spine.Controller
	constructor: ->
		super
		
		exercises = new Exercises
		@html exercises

module.exports = App
