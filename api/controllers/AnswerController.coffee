 # AnswerController
 #
 # @description :: Server-side logic for managing Answers
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 
  create: (req, res) ->
    params = req.params.all()
    console.log "New answer '#{params.wording}'"
    Question.findOne(params.question_id).exec((err, theQuestion) ->
      Answer.create(wording: params.wording, question: params.question_id).exec (err, created) ->
        unless err?
          FlashService.success(req, "'#{theQuestion.wording}' You answered, '#{params.wording}'")
          res.redirect "/questions/answer"
        else @handleError err
    )

  handleError: (err) ->
    console.log "ERROR: '#{err}"
    FlashService.error(req, err)
    res.view "/questions/answer"