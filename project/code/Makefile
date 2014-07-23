octave-build:
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
