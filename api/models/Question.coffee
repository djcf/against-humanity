# Question.coffee
#
# @description :: TODO: You might write a short summary of how this model works and what it represents here.
# @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  autoCreatedAt: true

  attributes:
    wording:
      type: 'string'
      required: true
      #unique: true
    answers:
      collection: 'answer'
      via: 'question'
    byAuthor: # Stores sessionID
      type: 'string'
#    author: # Not implemented yet
#      model: 'user'
#    votesAgainst: # (Fewer is better) Not implemented yet
#     type: 'integer'
#     defaultsTo: 0

  getOneRandomQuestion: (options, cb) ->
    if not options?
      options = { }
      options.wasEmpty = true
    if not options.notByAuthor?
      options.notByAuthor = [ ]
    else
      options.notByAuthor = [ options.notByAuthor ]
    if not options.isNot?
      options.isNot = [ ]

    Question.count(
      byAuthor: { '!' : options.notByAuthor }
      id: { '!' : options.isNot }
    ).then (numberOfQuestions) ->
      if numberOfQuestions is 0 # We need to make sure we return *something* to prevent the programme from crashing.
        if options.wasEmpty? # The database must be empty. Return a pre-programmed default and log the error. (Not strictly nessessary since the second pass will have an empty options array.)
          cb(null, ErrorService.noMoreQuestions()) # We could decide to return an error here instead.
        else # The database wasn't empty, we've just exhausted all possible options due to user intervention. Return any one at random since that's better than none at all.
           # We'll just go thru this again with an empty options array. 
           # Then have the callback pass the result to the callback.
          Question.getOneRandomQuestion(null, (err, theQuestion) -> cb(err, theQuestion))
      else
        Question.find(
          byAuthor: { '!' : options.notByAuthor },
          id: { '!' : options.isNot }
          skip: RandomService.getRandomInt(numberOfQuestions),
          limit: 1
        ).exec((err, recs) -> cb(err, recs[0]))

  # An active question is a bit more complicated than just getting one random question.
  # We want to get:
  #   the most recently asked question  (TODO: how to tell?)
  #   which has < x answers
  #   and was not asked by this user
  #   and which this user has not already answered
  # If in doubt, then we can default to returning a random question instead.
  getOneActiveQuestion: (options, cb) ->
    # TODO: All of the above.
    Question.getOneRandomQuestion(options, (err, results) -> cb(err, results) )

  beforeCreate: (newQuestion, cb) ->
    newQuestion.wording = AnswerService.reduceUnderscores(newQuestion.wording)
    cb()