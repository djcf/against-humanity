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
    if options? and options.notByAuthor?
      filter = options.notByAuthor
    else
      filter = ""
    Answer.count(byAuthor: { '!' : [filter] }).then (count) ->
      Answer.find(
        byAuthor: { '!' : [filter] },
        skip: RandomService.getRandomInt(0, count)
        limit: 1
      ).exec((err, recs) -> cb(err, recs[0]))
