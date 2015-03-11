# Provides services relating to error reporting

module.exports =

  handleError: (req, err, nextLocation) ->
    console.log "ERROR: '#{err}"
    FlashService.error(req, err)
    res.redirect nextLocation