function position = addVelocityPosition(velocity, position)
  assert(size(velocity, 1) == 2)

  for i = 1:length(velocity)
    swap = [velocity(i, 1), velocity(i, 2)]
    position(swap) = position(fliplr(swap))
  endfor