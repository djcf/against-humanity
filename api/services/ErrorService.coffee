# Provides services relating to error reporting

module.exports =

  handleError: (req, err, nextLocation) ->
    console.warn "ERROR: '#{err}"
    FlashService.error(req, err)
    res.redirect nextLocation

  noMoreAnswers: ->
    console.error "No more answers?!"
    return { "wording": "The arrogance that can only come from a person who has seen all the answers.", "id": -1 }

  noMoreQuestions: ->
    console.error "No more questions?!"
    return { "wording": "The only thing better than the simple, quiet bliss of knowing there are no more questions.", "id": -1 }