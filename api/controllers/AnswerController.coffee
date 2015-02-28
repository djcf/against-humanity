 # AnswerController
 #
 # @description :: Server-side logic for managing Answers
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 
	create: (req, res) ->
		params = req.params.all()
		console.log "New answer '#{params.wording}'"
		Answer.create(wording: params.wording).exec (err, created) ->
			unless err?
				req.flash "You asked, '#{created.wording}'"
				res.redirect "AnswerController.create"
			if err
				console.log err;
				req.flash = err: err
