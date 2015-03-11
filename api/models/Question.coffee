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

  # TODO: options should be able to state e.g. not from a certain user/sessionID
  getOneRandomQuestion: (options, cb) ->
    if options? and options.notByAuthor?
      filter = options.notByAuthor
    else
      filter = ""
    Question.count(byAuthor: { '!' : [filter] }).then (count) ->
      Question.find(
        byAuthor: { '!' : [filter] },
        skip: RandomService.getRandomInt(0, count),
        limit: 1
      ).exec((err, recs) -> cb(err, recs[0]))