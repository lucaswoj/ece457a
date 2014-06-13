FROM ubuntu

RUN echo ppa:octave/stable >> /etc/sources.list
RUN apt-get update
RUN apt-get install --assume-yes --force-yes octave

ADD . /etc/ece457a/assignment2/question2/
RUN chmod +x /etc/ece457a/assignment2/question2/2b.m