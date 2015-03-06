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
#    votes: # Not implemented yet
#     type: 'integer'
#     defaultsTo: false

  getOneRandomAnswer: (options, cb) ->
    Answer.count().then (count) ->
      Answer.find(
        skip: RandomService.getRandomInt(0, count)
        limit: 1
      ).exec((err, recs) -> cb(err, recs[0]))

  getRandomAnswers: (number, cb) ->
    count = 0
    Results = Array(number)
    async.until(
      -> (count == number)
      (callback) -> #call callback when this fn completes
        Answer.getOneRandomAnswer(null, (err, record) -> 
          Results.push record
          callback err
        )
        count++
      (err) -> cb(err, Results)
    )
