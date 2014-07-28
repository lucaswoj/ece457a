function velocity = padVelocity(velocity, length)
  velocity = cat(1, velocity, zeros(length - size(velocity, 1), size(velocity, 2)));
