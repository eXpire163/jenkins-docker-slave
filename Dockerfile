FROM ubuntu:16.04
MAINTAINER Bibin Wilson <bibinwilsonn@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get install -y git
# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

USER root
RUN apt-get update && apt-get install -y subversion locales maven ant ant-contrib


# add ibm java
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION 1.8.0_sr5

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       amd64|x86_64) \
         ESUM='e0154e19d283b0257598cd62543c92f886cd0e33ce570750d80c92b1c27b532e'; \
         YML_FILE='sdk/linux/x86_64/index.yml'; \
         ;; \
       i386) \
         ESUM='b45066ab6ae61b9a7b78b8828dc6f0dcd82ead18b120107c8f523c314592a1a8'; \
         YML_FILE='sdk/linux/i386/index.yml'; \
         ;; \
       ppc64el|ppc64le) \
         ESUM='52f54e1a4911f3a2123ea3e034818a1e8b2e707455ffb7dd9b104b6c5b4c38a6'; \
         YML_FILE='sdk/linux/ppc64le/index.yml'; \
         ;; \
       s390) \
         ESUM='6e5ebc6791a16e62be541c28a788884ac91f4a6b8441f2eabc04ebb3dd8278b5'; \
         YML_FILE='sdk/linux/s390/index.yml'; \
         ;; \
       s390x) \
         ESUM='f2aec41f74441a829e5bbbc62f14dc8dd85d8a256c2d6e46ec4e8c071f3b23ed'; \
         YML_FILE='sdk/linux/s390x/index.yml'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    BASE_URL="https://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/meta/"; \
    wget -q -U UA_IBM_JAVA_Docker -O /tmp/index.yml ${BASE_URL}/${YML_FILE}; \
    JAVA_URL=$(cat /tmp/index.yml | sed -n '/'${JAVA_VERSION}'/{n;p}' | sed -n 's/\s*uri:\s//p' | tr -d '\r'); \
    wget -q -U UA_IBM_JAVA_Docker -O /tmp/ibm-java.bin ${JAVA_URL}; \
    echo "${ESUM}  /tmp/ibm-java.bin" | sha256sum -c -; \
    echo "INSTALLER_UI=silent" > /tmp/response.properties; \
    echo "USER_INSTALL_DIR=/opt/ibm/java" >> /tmp/response.properties; \
    echo "LICENSE_ACCEPTED=TRUE" >> /tmp/response.properties; \
    mkdir -p /opt/ibm; \
    chmod +x /tmp/ibm-java.bin; \
    /tmp/ibm-java.bin -i silent -f /tmp/response.properties; \
    rm -f /tmp/response.properties; \
    rm -f /tmp/index.yml; \
    rm -f /tmp/ibm-java.bin;
    

#end add ibm java

#RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
#    dpkg-reconfigure --frontend=noninteractive locales && \
#    update-locale LANG=de_DE.UTF-8
#ENV LANG de_DE.UTF-8



# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

RUN mkdir /home/jenkins/.m2

# ADD settings.xml /home/jenkins/.m2/

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ 


# ADD https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.5.0/apache-maven-3.5.0-bin.tar.gz /var/ant/
# ADD ant-contrib-1.0b3.jar /var/ant/lib/
# ENV ANT_HOME=/var/ant/

ENV IBM_JAVA_1_6_HOME /opt/ibm/java
ENV IBM_JAVA_1_6_ENDORSED /var/share/endorsed_apis
ENV mvnsettings /var/share/mvnsettings.xml
ENV JAVA_HOME /opt/ibm/java



# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
