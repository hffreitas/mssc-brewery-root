FROM centos:centos8.4.2105

RUN yum update -y
RUN yum -y install  java-11-openjdk java-11-openjdk-devel

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-1.el8_4.aarch64
ENV DOWNLOAD_URL=https://dlcdn.apache.org/activemq/activemq-artemis/2.19.0/apache-artemis-2.19.0-bin.tar.gz
RUN curl ${DOWNLOAD_URL} -so /tmp/activemq.tar.gz

ENV ACTIVEMQ_HOME="/opt/activemq"
ENV ACTIVEMQ_VERSION="2.19.0"
RUN mkdir -p ${ACTIVEMQ_HOME}
RUN tar -xzf /tmp/activemq.tar.gz -C /tmp && \
    mv /tmp/apache-artemis-${ACTIVEMQ_VERSION}/* ${ACTIVEMQ_HOME} && \
    rm -rf /tmp/activemq.tar.gz

RUN groupadd --system activemq
RUN adduser --system --no-create-home --gid activemq activemq
RUN chown -R activemq:activemq /opt/activemq
WORKDIR /opt/activemq/bin

RUN ./artemis create artemis-broker-test --user=admin --password=admin --http-host 0.0.0.0 --relax-jolokia --silent

CMD ls -la /usr/lib/jvm/
# Web Console
EXPOSE 8161
# OpenWire
EXPOSE 61616
# AMQP
EXPOSE 5672
# STOMP
EXPOSE 61613

CMD "/opt/activemq/bin/artemis-broker-test/bin/artemis" run