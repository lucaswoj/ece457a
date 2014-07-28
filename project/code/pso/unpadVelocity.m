function velocity = unpadVelocity(velocity)
  velocity(~any(velocity, 2), :) = [];