function position = addVelocityPosition(velocity, position)
  assert(size(velocity, 1) == 2)

  for i = 1:length(velocity)
    swap = velocity(i)
    position(swap) = position(fliplr(swap))
  endfor