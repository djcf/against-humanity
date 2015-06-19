# Provides services relating to the RNG

module.exports =

  # taken from: https://gist.github.com/robwormald/d4ce538e8ba8a6d87bfc
  getRandomInt: (max, min = 0) ->
    Math.floor(Math.random() * (max - min)) + min

  # Actually shuffle the items now they are in one big array.
  # Using Fisher-Yates (Knuff) for unbiased, speedy-shuffling, via CS Cookbook
  # Uniqify them first, also via CS Cookbook
  shuffle: (array) ->
    # Arrays with < 2 elements do not shuffle well. Instead make it a noop.
    return array unless array.length >= 2
    # From the end of the list to the beginning, pick element `index`.
    for index in [array.length-1..1]
      # Choose random element `randomIndex` to the front of `index` to swap with.
      randomIndex = Math.floor Math.random() * (index + 1)
      #randomIndex = RandomService.getRandomInt(index + 1)
      # Swap `randomIndex` with `index`, using destructured assignment
      [array[index], array[randomIndex]] = [array[randomIndex], array[index]]
    return array