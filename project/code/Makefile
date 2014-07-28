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


$(addsuffix Reduced.csv, $(ALGORITHMS)): %Reduced.csv: %/solve.m octave-build
	$(call runProblem,Reduced,25)
	cp $@ $(call basename, $@).`date +%s`.csv

$(addsuffix Small.csv, $(ALGORITHMS)): %Small.csv: %/solve.m octave-build
	$(call runProblem,Small,50)
	cp $@ $(call basename, $@).`date +%s`.csv

$(addsuffix Medium.csv, $(ALGORITHMS)): %Medium.csv: %/solve.m octave-build
	$(call runProblem,Medium,100)
	cp $@ $(call basename, $@).`date +%s`.csv

$(addsuffix Large.csv, $(ALGORITHMS)): %Large.csv: %/solve.m octave-build
	$(call runProblem,Large,1000)
	cp $@ $(call basename, $@).`date +%s`.csv

$(ALGORITHMS): %: %Reduced.csv %Small.csv %Medium.csv %Large.csv

all: $(ALGORITHMS)

clean:
	rm *.csv

# This shouldn't be regnereated unless absolutely nescessary
#
# loadLargeProblem.m: octave-build uneval.m loadRandomProblem.m
# 	$(call generateProblem,Large, 50, 15)

# loadMediumProblem.m: octave-build uneval.m loadRandomProblem.m
# 	$(call generateProblem,Medium, 15, 5)

# loadSmallProblem.m: octave-build uneval.m loadRandomProblem.m
# 	$(call generateProblem,Small, 5, 3)
