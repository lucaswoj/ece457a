function velocity = velocity(position, v0, lbest, gbest, w, r1, r2, c1, c2)

  inertia = multiplyScalarVelocity(w, v0)
  lbest_ = c1 * r1 * subtractPositions(lbest, position)
  gbest_ = c2 * r2 * subtractPositions(gbest, position)

  velocity = addVelocityPosition(inertia, lbest_ + gbest_)

function product = multiplyScalarVelocity(scalar, velocity)

function difference = subtractPositions(position0, position1)

function sum = addVelocityPosition(velocity, position)


