function position = addVelocityPosition(velocity, position)
  assert(size(velocity, 2) == 2);

  for i = 1:size(velocity,1)
    swap = velocity(i, :);
    position(swap) = position(fliplr(swap));
  endfor