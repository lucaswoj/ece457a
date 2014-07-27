function swaps = subtractPositions(p2, p1)
  assert(length(p1) == length(p2))
  pLength = length(p1)

  % Create a "directory" of mismatched elements
  p1Indicies = find(p1 ~= p2)
  p2Indicies = p1Indicies

  % Allocate space for the answer
  swaps = zeros(pLength - 1, 2)
  swapsIndex = 1

  while length(p1Indicies) > 0

    p1Index = p1Indicies(1)
    p1IndexStart = p1Index

    while true

      p2Index = 0
      for i = 1:length(p2Indicies)
        if p1(p1Index) == p2(p2Indicies(i))
          p2Index = p2Indicies(i);
          break
        endif
      endfor

      assert(p2Index ~= 0)

      p1Indicies = p1Indicies(p1Indicies != p1Index)
      p2Indicies = p2Indicies(p2Indicies != p2Index)

      if p2Index == p1IndexStart
        break;
      endif

      swaps(swapsIndex, :) = [p1Index, p2Index]
      swapsIndex = swapsIndex + 1

      p1Index = p2Index

    endwhile

  endwhile

