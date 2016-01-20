# Build environment for Alibaba Dubbo RPC Framework
FROM calee2005/alpine-java8
MAINTAINER Claude Lee "calee2005@outlook.com"

# Install maven 3.3.9
RUN mkdir /opt \
    && wget -qO- http://apache.fayea.com/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | tar -xzf - -C /opt \
    && mv /opt/apache-maven-3.3.9 /opt/maven

ENV PATH=/opt/maven/bin:$PATH

# Install patch tool
RUN apk add --update patch && rm -rf /var/cache/apk/*

# Download Alibaba Dubbo source code package
RUN wget -qO- https://github.com/alibaba/dubbo/archive/dubbo-2.5.3.tar.gz | tar -xzf - -C /opt \
    && mv /opt/dubbo-dubbo-2.5.3 /opt/dubbo

# Apply patch
COPY patch.diff /opt/dubbo/patch.diff
WORKDIR /opt/dubbo
RUN patch -s -i patch.diff

# Build dubbo
RUN mvn package -Dmaven.test.skip=true && rm -rf ~/.m2
