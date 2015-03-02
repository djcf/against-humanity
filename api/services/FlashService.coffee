module.exports =
  success: (req, message) ->
    req.session.messages['success'].push message
    return
  warning: (req, message) ->
    req.session.messages['warning'].push message
    return
  error: (req, message) ->
    req.session.messages['error'].push message
    return