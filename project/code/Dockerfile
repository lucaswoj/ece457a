FROM ubuntu

RUN echo ppa:octave/stable >> /etc/sources.list
RUN apt-get update
RUN apt-get install --assume-yes --force-yes octave

WORKDIR /etc/ece457a/project
ADD . .
