testBoard0 = [ 0, 0, 0; 0, 0, 0; 0, 0, 0] % should result in 8 for both players

% We know that every board is a 3x3 grid composed of the following:
%  1 represents "naughts"
% -1 representes "crosses"
%  0 represents empty spaces
function score = scoreBoard( board )
	score = 0;

	score = score + checkThreeLength( board( 1, 1:3 ) );
	score = score + checkThreeLength( board( 2, 1:3 ) );
	score = score + checkThreeLength( board( 3, 1:3 ) );

	score = score + checkThreeLength( board( 1:3, 1 ) );
	score = score + checkThreeLength( board( 1:3, 2 ) );
	score = score + checkThreeLength( board( 1:3, 3 ) );

	diagonalOne = [ board( 1, 1 ), board( 2, 2 ), board( 3, 3 ) ];
	score = score + checkThreeLength( diagonalOne );

	diagonalTwo = [ board( 1, 3 ), board( 2, 2 ), board( 3, 1 ) ];
	score = score + checkThreeLength( diagonalTwo );
end

function score = checkThreeLength( threeLength )
	threeLengthsWithNaughts = ( threeLength == 1 );

	threeLengthsWithCrosses  = ( threeLength ==  -1 );

	if ~threeLengthsWithCrosses && ~threeLengthsWithNaughts
		% empty threeLength
		score  = 0;
	elseif ~threeLengthsWithNaughts
		% at least one cross and no naughts
		score = 1;
	elseif ~threeLengthsWithCrosses
		% at least one naught and no crosses
		score = -1;
	else
		% at least one naught and one cross
		score = 0;
  end
end

scoreBoard( testBoard0 )

testBoard1 = [ 1, 0, 0; 0, 0, 0; 0, 0, 0 ];
scoreBoard( testBoard1 )

testBoard2 = [ 1, 0, 0; 0, 0, 0; 0, 0, -1 ];
scoreBoard( testBoard2 )

testBoard3 = [ -1, 0, -1; 0, 0, 0; 1, 0, 1 ];
scoreBoard( testBoard3 )

testBoard4 = [ 1, -1, 0; 0, 1, 0; 0, -1, 0 ];
scoreBoard( testBoard4 )

testBoard5 = [ -1, 0, 0; 0, -1, 0; -1, 0, -1 ];
scoreBoard( testBoard5 )


