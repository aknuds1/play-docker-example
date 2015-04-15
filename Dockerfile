FROM debian:jessie
MAINTAINER Example

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | \
tee /etc/apt/sources.list.d/webupd8team-java.list && \
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | \
tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list

RUN apt-get update

RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 \
seen true | debconf-set-selections && DEBIAN_FRONTEND=noninteractive \
apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default
RUN apt-get install -y --force-yes unzip sbt

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install activator
WORKDIR /opt
RUN wget http://downloads.typesafe.com/typesafe-activator/1.3.2/typesafe-activator-1.3.2.zip
RUN unzip typesafe-activator-1.3.2.zip
RUN rm typesafe-activator-1.3.2.zip
ENV PATH /opt/activator-1.3.2:$PATH

COPY ./ /code
WORKDIR /code

EXPOSE 9000

ENTRYPOINT ["sbt"]
CMD ["run"]
