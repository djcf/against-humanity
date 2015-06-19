 # Answer.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  autoCreatedAt: true

  attributes:
    wording:
      type: 'string'
      required: true
    question:
      model: 'question'
    bestAnswer: # Is this answer the best answer as chosen by the user who asked the question?
      type: 'boolean'
      defaultsTo: false
    byAuthor: # Stores sessionID
      type: 'string'
    answerParts: # Stores number of parts of the answer for multipart answers
      type: 'integer'
      defaultsTo: 1
#    author: # Not implemented yet
#      model: 'user'
#    votes: # (More is better) Not implemented yet
#     type: 'integer'
#     defaultsTo: 0

  getRandomAnswers: (number, options, cb) ->
    count = 0
    Results = Array()
    async.until(
      -> (count == number)
      (callback) -> #call callback when this fn completes
        Answer.getOneRandomAnswer(options, (err, record) -> 
          Results.push record
          callback err
        )
        count++
      (err) -> cb(err, Results)
    )

  getOneRandomAnswer: (options, cb) ->
    if not options?
      options = { }
      options.wasEmpty = true
    if not options.notByAuthor?
      options.notByAuthor = [ ]
    else
      options.notByAuthor = [ options.notByAuthor ]
    if not options.isNot?
      options.isNot = [ ]

    Answer.count(
        byAuthor: { '!' : options.notByAuthor } # Don't forget to add the list.
        id: { '!' : options.isNot }
    ).then (numberOfAnswers) ->
      if numberOfAnswers is 0 # We need to make sure we return *something* to prevent the programme from crashing.
        if options.wasEmpty? # The database must be empty. Return a pre-programmed default and log the error. (Not strictly nessessary since the second pass will have an empty options array.)
          cb(null, ErrorService.noMoreAnswers()) # We could decide to return an error here instead.
        else # The database wasn't empty, we've just exhausted all possible options due to user intervention. Return any one at random since that's better than none at all.
          # We'll just go thru this again with an empty options array. 
          # Then have the callback pass the result to the callback.
          Answer.getOneRandomAnswer(null, (err, theAnswer) -> cb(err, theAnswer))
      else
        Answer.find(
          byAuthor: { '!' : options.notByAuthor }
          id: { '!' : options.isNot }
          skip: RandomService.getRandomInt(numberOfAnswers)
          limit: 1
        ).exec((err, recs) -> cb(err, recs[0]))

  beforeValidate: (newAnswer, cb) ->
    console.log "beforeValidate"
    console.log newAnswer.wording
    if newAnswer.wording instanceof Array
      console.log "Was array of " + newAnswer.wording.length
      newAnswer.answerParts = newAnswer.wording.length
    cb()