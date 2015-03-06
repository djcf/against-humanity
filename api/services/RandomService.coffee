# Provides services relating to the RNG

module.exports =

  # taken from: https://gist.github.com/robwormald/d4ce538e8ba8a6d87bfc
  getRandomInt: (min, max) ->
    Math.floor(Math.random() * (max - min)) + min