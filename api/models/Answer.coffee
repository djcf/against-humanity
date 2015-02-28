 # Answer.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models
module.exports =

  connection: 'localDiskDb'
  autoCreatedAt: true

  attributes:
    wording:
      type: 'string'
      required: true