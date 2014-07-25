function difference = subtractPositions(position1, position2)
  assert(length(position1) == length(position2))

  % Find the indicies of all nonmatching elements in the positions
  positionIndicies = find(position1 ~= position2)

  % Allocate a matrix to store the difference
  assert(mod(length(positionIndicies), 2) == 0)
  difference = zeros(positionIndicies / 2)'
  differenceNextIndex = 1

  for i = 1:length(positionIndicies)
    for j = (i + 1):length(positionIndicies)

      if positionIndicies(j) == 0
        continue
      endif

      if position1(positionIndicies(j)) == position2(positionIndicies(i)) && position2(positionIndicies(j)) == position1(positionIndicies(i))

        difference(differenceNextIndex) = [i, j]
        differenceNextIndex = differenceNextIndex + 1

        positionIndicies(j) = 0

        break

      endif
    endfor
  endfor