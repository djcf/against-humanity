 # QuestionController
 #
 # @description :: Server-side logic for managing Questions
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
	# Makes a new brand-new question.
	create: (req, res) ->
		params = req.params.all()
		if params.wording?
			console.log "New question '#{params.wording}'"
			Question.create(wording: params.wording).exec (err, created) ->
				unless err?
					req.flash "You asked, '#{created.wording}'"
					res.redirect "/questions/answer"
				else @handleError err
		else
			res.redirect @getCurrentPage

	# Retrieves one question at random from the database.
	# TODO: Model should ensure that User did not ask the question, and has not answered it already.
	answer: (req, res) ->
		Question.getRandomQuestion(null, (err, the_q) -> 
			console.log "User wants to answer a question. Sending question '#{the_q.wording}'"
			unless err?
				res.json the_q.wording
			else @handleError err
		)

	getCurrentPage: -> "/"  #TODO: switch view based on user logged in or not

	handleError: (err) ->
		console.log err
		req.flash = err: err
		res.view @getCurrentPage