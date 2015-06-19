# flash.js policy

module.exports = (req, res, next) ->
  # Make sure a viewed object exists in the session
  if not req.session.viewed?
    req.session.viewed =
      questions: Array()
      answers: Array()

  # TODO: Automatically adjust parameters of play depending on number of users
  next()
