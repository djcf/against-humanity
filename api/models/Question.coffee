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

  # taken from: https://gist.github.com/robwormald/d4ce538e8ba8a6d87bfc
  getRandomInt: (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

  getRandomQuestion: (options, cb) ->
    Question.count().then (count) ->
      Question.find(
        skip: Question.getRandomInt(0, count)
        limit: 1
      ).exec((err, recs) -> cb(err, recs[0]))