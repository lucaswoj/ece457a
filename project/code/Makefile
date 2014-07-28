octave-build:
	docker build -t ece457a-project .

octave-bash: octave-build
	docker run \
		--rm \
		--tty \
		--interactive \
		ece457a-project
		bash

octave: octave-build
	docker run \
		--rm \
		--tty \
		--interactive \
		ece457a-project \
		bash -c "octave"

ALGORITHMS = aco ga pso sa ts

PROBLEMS = Reduced Medium Small

generateProblem = \
	docker run \
		--rm \
		--tty \
		ece457a-project \
		bash -c "octave --silent --path $* --eval \"loadRandomProblem($(2), $(3)); printProblem(\\\"$(1)\\\");\" " | \
	tee $@

runProblem = \
	docker run \
		--rm \
		--tty \
		ece457a-project \
		bash -c "octave --silent --path $* --eval \"load$(1)Problem(); solve($(2));\"" | \
	tee $@


$(addsuffix Reduced.csv, $(ALGORITHMS)): %Reduced.csv: %/solve.m octave-build loadReducedProblem.m
	$(call runProblem,Reduced,25)

$(addsuffix Small.csv, $(ALGORITHMS)): %Small.csv: %/solve.m octave-build loadSmallProblem.m
	$(call runProblem,Small,50)

$(addsuffix Medium.csv, $(ALGORITHMS)): %Medium.csv: %/solve.m octave-build loadMediumProblem.m
	$(call runProblem,Medium,100)

$(addsuffix Large.csv, $(ALGORITHMS)): %Large.csv: %/solve.m octave-build loadLargeProblem.m
	$(call runProblem,Large,1000)


loadLargeProblem.m: octave-build uneval.m loadRandomProblem.m
	$(call generateProblem,Large, 50, 15)

loadMediumProblem.m: octave-build uneval.m loadRandomProblem.m
	$(call generateProblem,Medium, 15, 5)

loadSmallProblem.m: octave-build uneval.m loadRandomProblem.m
	$(call generateProblem,Small, 5, 3)
