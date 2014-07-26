function velocity = getVelocity(position, v0, lbest, gbest, w, r1, r2, c1, c2)

  inertiaVelocity = multiplyScalarVelocity(w, v0)
  lbestVelocity = c1 * r1 * subtractPositions(lbest, position)
  gbestVelocity = c2 * r2 * subtractPositions(gbest, position)

  velocity = addVelocityPosition(inertia, lbest_ + gbest_)
