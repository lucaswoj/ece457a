docker-run = \


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

octave:
	docker run \
		--tty \
		--interactive \
		ece457a-assignment2-question2 \
		bash -c "octave"

ab.out c.out d.out dc.out: docker-build
	docker run \
		--tty \
		--interactive \
		ece457a-assignment2-question2 \
		bash -c "cd /etc/ece457a/assignment2/question2/$(@:.out=) && octave Main.m" | \
	tee $@


