FROM maven:alpine AS builder

ENV TE_VERSION=5.4

WORKDIR /opt
RUN apk add --no-cache git \
    && git clone https://github.com/opengeospatial/teamengine.git \
    && cd teamengine \
    && git checkout -b ${TE_VERSION} refs/tags/${TE_VERSION} \
    && mvn package -Dmaven.test.skip

FROM tomcat:7-jre8-alpine AS app

ENV TE_VERSION=5.4 \
    TE_BASE=/te_base \
    CATALINA_BASE=/srv/tomcat/base-1
ENV CATALINA_OPTS="-server -Xmx1024m -XX:MaxPermSize=128m -DTE_BASE=$TE_BASE -Dderby.system.home=$DERBY_DATA"

WORKDIR /
COPY --from=builder /opt/teamengine/teamengine-console/target/teamengine-console-$TE_VERSION-base.zip .

RUN mkdir -p $TE_BASE \
    && unzip teamengine-console-$TE_VERSION-base.zip -d $TE_BASE \
    && mkdir -p $CATALINA_BASE \
    && cd $CATALINA_BASE \
    && cp -r $CATALINA_HOME/conf . \
    && mkdir lib logs temp webapps work

WORKDIR $CATALINA_BASE
COPY --from=builder /opt/teamengine/teamengine-web/target/teamengine.war ./webapps
COPY --from=builder /opt/teamengine/teamengine-web/target/teamengine-common-libs.zip ./
RUN unzip teamengine-common-libs.zip -d lib \
    && rm teamengine-common-libs.zip
