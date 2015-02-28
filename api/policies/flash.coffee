module.exports = (req, res, next) ->
	res.locals.flash = {}
	return next() unless req.session.flash

	res.locals.flash = _.clone(req.session.flash)
	req.session.flash = {}
	next()