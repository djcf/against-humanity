# Provides utility services

module.exports =
  # Reduces any number of groups of ___ underscores into one, the better for counting and storing.
  reduceUnderscores: (answer) -> answer.replace(/_{2,}/g, "_")

  # Strictly counts the number of parts of a given answer (i.e. number of regex groups of single underscore characters) -- not guaranteed
  # to return a sensible result if the input contains no underscores.
  # Should only be used by AnswerService -- other parts of the program should always call countAnswerParts below.
  countAnswerPartsStrict: (answer) -> AnswerService.reduceUnderscores(answer).match(/\_/g)?.length

  # You cannot have a 0-part answer. Will ensure that we always return 1 or > 1 to the question "how many parts does this answer have?"
  countAnswerParts: (answer) ->
    count = AnswerService.countAnswerPartsStrict(answer)
    if count > 1 then return count else return 1

  # Increases the number of underscores from 1 to 3 for prettifying the view
  increaseUnderscores: (answer) -> answer.replace(/\_/g, "___")

  prettifyResponse: (question, answer) ->
    count = AnswerService.countAnswerPartsStrict(question)
    if not count?
      return "'#{question}' You answered, '#{answer}'"
    else if count is 1
      return "You answered, '" + question.replace(/.?\_.?/, " <u>&nbsp;#{answer}&nbsp;</u> ") + "'."
    else
      question = question.replace(/\_/, "<u>&nbsp;#{part}&nbsp;</u>") for part in answer
      return question