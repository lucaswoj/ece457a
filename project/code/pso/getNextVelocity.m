function velocity = getNextVelocity(r1, r2, position, positionLbest, positionGbest, velocityPrevious)

  w = 0.792;
  c1 = 1.4944;
  c2 = 1.4944;

  velocityLength = size(velocityPrevious, 1);

  velocity0 = multiplyScalarVelocity(w, velocityPrevious);
  velocity1 = multiplyScalarVelocity(r1 * c1, subtractPositions(positionLbest, position));
  velocity2 = multiplyScalarVelocity(r2 * c2, subtractPositions(positionGbest, position));

  velocity = cat(1, velocity0, velocity1, velocity2);