 # AnswerController
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
 # @description :: Server-side logic for managing Answers
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 
  create: (req, res) ->
    params = req.params.all()
    console.log "New answer '#{params.wording}'"
    Answer.create(wording: params.wording, question: params.question_id).exec (err, created) ->
      unless err?
        req.session.questionsAnswered = (req.session.questionsAnswered ? 0) + 1 # initialize or increment the number of questions answered
        FlashService.notify(req, "'#{params.the_question}' You answered, '#{params.wording}'")
        sails.controllers.answer.new(req, res)
      else @handleError req, err

  # Let the user pick the best answer for their question if it has more than some number of answers and if the user
  # has answered more than some number of questions.
  isReadyToModerateQuestion: (req, res, cb) ->
    # Has the user answered enough questions? Have we managed to remember what their original question was? Have we managed to keep track of how many they've answered?
    console.log "Let's see if they're ready to moderate their original question yet.."
    if not req.session.myQuestion? # We seemed to have managed to lose track of their original question. Just let them ask another, it'll be fine.
      console.log "We seem to have managed to lose track of their original question."
      res.redirect('/questions/ask')
      cb false;
    else
      # Find all [recently-added] answers for the users original question; store it in session.
      Answer.count(question: req.session.myQuestion.id).exec((err, count) -> 
        console.log "Number of answers for question id #{req.session.myQuestion.id}: #{count}. User has answered #{req.session.questionsAnswered} questions so far."
        cb(
          (req.session.questionsAnswered >= sails.config.appConfig.numberOfAnswersBeforeChoosingBest) and
          (count >= sails.config.appConfig.minAnswersPerQuestion)
        )
      )

  # GET method -- will send the user the form to POST to AnswerController.create
  # Retrieves one question at random from the database.
  # TODO: Model should ensure that User did not ask the question, and has not answered it already.
  new: (req, res) ->
    console.log "AnswerController.new"
    @isReadyToModerateQuestion(req, res, (readyToModerate) ->
      unless readyToModerate
        async.parallel([
          (callback) -> 
            Question.getOneRandomQuestion(null, (err, theQuestion) ->
              callback(err, theQuestion)    
            )
          (callback) ->
            Answer.getOneRandomAnswer(null, (err, theAnswer) ->
              callback(err, theAnswer)
            )]
          (err, results) ->
            unless err?
              res.view "pages/homepage-answers",
                the_question: results[0].wording,
                the_questions_id: results[0].id,
                example_answer: results[1].wording,
                questions_asked: req.session.questions_asked
            else
              @handleError req, err
        )
      else
        # Apparently, they are ready to do the moderation thing.
        console.log "sending user to moderator"
        res.redirect "/questions/choose-answer"
    )

  # Now we let the user choose the best answer for their question.
  moderate: (req, res) ->
    console.log "AnswerController.moderate"
    @isReadyToModerateQuestion(req, res, (readyToModerate) ->
      if readyToModerate
        Answer.find(question: req.session.myQuestion.id).exec((err, answers) ->
          unless err?
            res.view "pages/homepage-moderate",
              the_question: req.session.myQuestion.wording,
              possible_answers: answers
          else
            @handleError req, err
        )
      else
        FlashService.warning(req, "You need to answer some more questions before you can choose the best answers.")
        res.redirect "/questions/answer"
    )

  # POST -- saves the best answer for this question or (TODO: votes for this answer)
  saveBestAnswer: (req, res) ->
    params = req.params.all()
    Answer.update(
      { id: params.best_answer },
      { bestAnswer: true }
    ).exec(err, updated) ->
      @handleError(req, err) if err?
      req.session.myQuestion = null
      res.redirect "/questions/ask"

  handleError: (req, err) ->
    console.log "ERROR: '#{err}"
    FlashService.error(req, err)
    res.redirect "/questions/answer"