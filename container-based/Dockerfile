FROM ubuntu:18.04

ARG artifactURL="https://github.com/AKSarav/SampleWebApp/raw/master/dist/SampleWebApp.war"
ARG DEBIAN_FRONTEND=noninteractive

#Install dependencies
RUN apt-get update --yes && \
    apt-get install --yes \
      coreutils \
      curl \
      direnv \
      expect \
      gawk \
      git \
      groff \
      less \
      lsb-release \
      moreutils \
      parallel \
      python3-pip \
      unzip \
      wget \
    && rm --recursive --force /var/lib/apt/lists/*

#Install openjdk
# This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

# Fix certificate issues, found as of
# https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302
RUN apt-get update && \
	apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Download apache-tomcat

WORKDIR /opt/
RUN curl -O https://downloads.apache.org/tomcat/tomcat-8/v8.5.63/bin/apache-tomcat-8.5.63.tar.gz
RUN tar xvfz apache*.tar.gz
RUN ln -s apache-tomcat-8.5.63 tomcat
RUN rm -rf /opt/tomcat/webapps/*


WORKDIR /opt/tomcat/webapps
RUN curl -O -L ${artifactURL} --output ROOT.war

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
