function product = multiplyScalarVelocity(scalar, velocity)
	nSwaps = size(velocity, 1);
	nSwapsNext = round(scalar * nSwaps);

	if scalar < 1
		product = velocity(1:nSwapsNext, :); % Remove numModification entries from velocity
	elseif scalar > 1
		product = zeros(0, 2);
		for i = 0:nSwapsNext - 1
			product = [product; velocity(mod(i, nSwaps) + 1, :)];
		endfor
	else
		product = velocity;
	end