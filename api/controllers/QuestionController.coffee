 # QuestionController
 # 
 # The Q/A Loop and programe control for this section is now described.
 # 1. START: GET /questions/ask or /
 # QuestionController.new
 # Retrieve an existing question to serve as an example. Present it to the user. Tell them to create one like it.
 #
 # 2. STORE the new question: POST /questions/ask
 # QuestionController.create
 # Redirect to /questions/answer
 #
 # 3. GET /questions/answer
 # AnswerController.new
 # Retrieve original question. Has the user answered enough questions yet? Are there enough answers for them to moderate their existing 
 # Retrieve an existing question for them to answer.
 # Retrieve an existing answer to serve as an example. Present it to the user. Tell them to create one like it.
 #
 # 4. STORE the new answer. POST /questions/answer
 # AnswerController.create 
 # GOTO 3 or 5
 # 
 # 5. MODERATE original question: GET /questions/choose-answer
 # AnswerController.moderate
 # Retrieve all answers for their original question.
 #
 # 6. STORE the best one: POST /questions/choose-answer
 # AnswerController.saveBestAnswer
 # GOTO 1.
 #
 # @description :: Server-side logic for managing Questions
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
	# POST method -- Verb to make a new brand-new question.
	create: (req, res) ->
		params = req.params.all()
		console.log "#{req.sessionID}: New question '#{params.wording}'"
		Question.create({ wording: params.wording, byAuthor: req.sessionID }).exec (err, created) ->
			unless err?
				req.session.myQuestion = created
				FlashService.notify(req, "You asked, '#{created.wording}'")
				res.redirect "/questions/answer"
			else ErrorService.handleError(req, err, "/")

	# GET method -- will send the user the right form to POST to QuestionController.create.
	# Retrieve a highly-rated question as an example
	new: (req, res) ->
		if req.session.myQuestion? # Check that they don't already have a question in the queue. (Object must be nulled before restarting the Q/A loop.)
			FlashService.notify(req, "Please answer some more questions before trying to answer another one.")
			res.redirect "/questions/answer"
		Question.getOneRandomQuestion( { notByAuthor : req.sessionID } , (err, theQuestion) ->
			unless err?
				res.view "pages/homepage", 
					title: "Ask a question"
					example_question: theQuestion.wording
			else ErrorService.handleError(req, err, "/")
		)

	getCurrentPage: -> "/"  #TODO: switch view based on user logged in or not