function position = addVelocityPosition(velocity, position)
  for i = 1:size(velocity, 1)
    swap = velocity(i, :);
    position(swap) = position(fliplr(swap));
  endfor
