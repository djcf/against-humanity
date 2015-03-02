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

  # taken from: https://gist.github.com/robwormald/d4ce538e8ba8a6d87bfc
  getRandomInt: (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

  getRandomAnswer: (options, cb) ->
    Answer.count().then (count) ->
      Answer.find(
        skip: Answer.getRandomInt(0, count)
        limit: 1
      ).exec((err, recs) -> cb(err, recs[0]))