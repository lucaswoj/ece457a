function product = multiplyScalarVelocity(scalar, velocity)
	numSwaps = size(velocity, 1);
	newNumSwaps = scalar * numSwaps;

	if scalar < 1
		product = velocity(1:newNumSwaps, :); % Remove numModification entries from velocity
	elseif scalar > 1
		product = zeros(newNumSwaps, 2);
		for i = 0:newNumSwaps-1
			product(i+1, :) = velocity(mod(i, numSwaps)+1, :);
		endfor
	else
		product = velocity;
	end