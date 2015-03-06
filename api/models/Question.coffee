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

  getOneRandomQuestion: (options, cb) ->
    Question.count().then (count) ->
      Question.find(
        skip: RandomService.getRandomInt(0, count)
        limit: 1
      ).exec((err, recs) -> cb(err, recs[0]))