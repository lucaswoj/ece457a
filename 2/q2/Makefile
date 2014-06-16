docker-run = \
	docker run \
		--tty \
		--interactive \
		ece457a-assignment2-question2 \
		bash -c "cd /etc/ece457a/assignment2/question2/$(1) && octave Main.m"

docker-build:
	boot2docker up
	export DOCKER_HOST=tcp://localhost:4243
	docker build -t ece457a-assignment2-question2 .


bash:
	docker run \
		--tty \
		--interactive \
		ece457a-assignment2-question2
		bash

ab c d: docker-build
	$(call docker-run,$@)


