docker-run = \
	docker run \
		--tty \
		--interactive \
		ece457a-assignment2-question2 \
		bash -c "cd /etc/ece457a/assignment2/question2 && octave -qf $(1).m"

docker-build:
	boot2docker up
	docker build -t ece457a-assignment2-question2 .


bash:
	docker run \
		--tty \
		--interactive \
		ece457a-assignment2-question2
		bash

ab: docker-build
	$(call docker-run,$@)


