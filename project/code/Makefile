octave-build:
	boot2docker up
	export DOCKER_HOST=tcp://localhost:4243
	docker build -t ece457a-assignment2-question2 .

octave-bash: octave-build
	docker run \
		--tty \
		--interactive \
		ece457a-assignment2-question2
		bash

octave: octave-build
	docker run \
		--tty \
		--interactive \
		ece457a-assignment2-question2 \
		bash -c "octave"
