module.exports =
  notify: (req, message) ->
    req.session.messages['notify'].push message
    return
  warning: (req, message) ->
    req.session.messages['warning'].push message
    return
  error: (req, message) ->
    req.session.messages['error'].push message
    return