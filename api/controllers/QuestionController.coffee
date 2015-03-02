 # QuestionController
 #
 # @description :: Server-side logic for managing Questions
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
	# POST method -- Verb to make a new brand-new question.
	create: (req, res) ->
		params = req.params.all()
		console.log "New question '#{params.wording}'"
		Question.create(wording: params.wording).exec (err, created) ->
			unless err?
				FlashService.success(req, "You asked, '#{created.wording}'")
				res.redirect "/questions/answer"
			else @handleError err

	# GET method -- will send the user the right form to POST to QuestionController.create.
	# Retrieve a highly-rated question as an example
	new: (req, res) ->
		Question.getRandomQuestion(null, (err, theQuestion) ->
			unless err?
				res.view "pages/homepage", 
					title: "Ask a question"
					example_question: theQuestion.wording
			else
				@handleError err
		)

	# GET method -- will send the user the form to POST to AnswerController.create
	# Retrieves one question at random from the database.
	# TODO: Model should ensure that User did not ask the question, and has not answered it already.
	answer: (req, res) ->
		async.parallel([
			(callback) -> 
				Question.getRandomQuestion(null, (err, theQuestion) ->
					callback(err, theQuestion)		
				)
			(callback) ->
				Answer.getRandomAnswer(null, (err, theAnswer) ->
					callback(err, theAnswer)
				)]
			(err, results) ->
				unless err?
					res.view "pages/homepage-answers",
						the_question: results[0].wording,
						the_questions_id: results[0].id,
						example_answer: results[1].wording
				else
					@handleError err
		)
	
	getCurrentPage: -> "/"  #TODO: switch view based on user logged in or not

	handleError: (err) ->
		console.log "ERROR: '#{err}"
		FlashService.error(req, err)
		res.view @getCurrentPage