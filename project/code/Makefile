octave-build: Dockerfile *.m **/*.m
	boot2docker up
	docker build -t ece457a-project .

octave-bash: octave-build
	docker run \
		--tty \
		--interactive \
		ece457a-project
		bash

octave: octave-build
	docker run \
		--tty \
		--interactive \
		ece457a-project \
		bash -c "octave"

ALGORITHMS = aco ga pso sa ts

$(addsuffix -reduced.out, $(ALGORITHMS)): %-reduced.out: %.m octave-build
	docker run \
		--tty \
		ece457a-project \
		bash -c "octave --silent --path % --eval \"loadReducedProblem(); $*()\"" | \
	tee $@