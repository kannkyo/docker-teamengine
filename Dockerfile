FROM maven:alpine AS builder

ENV TEAMENGINE_VERSION=5.3.1

WORKDIR /opt
RUN apk add --no-cache git \
    && git clone https://github.com/opengeospatial/teamengine.git \
    && cd teamengine \
    && git checkout $TEAMENGINE_VERSION \
    && mvn package -Dmaven.test.skip

FROM tomcat:7-jre8-alpine AS app

ENV TEAMENGINE_VERSION=5.3.1
ENV TEAMENGINE_BASE=/srv/tomcat/base-1
ENV CATALINA_BASE=$TEAMENGINE_BASE
# ENV TEAMENGINE_BASE=/srv/tomcat/base-1
ENV TE_BASE=/te_base
ENV CATALINA_OPTS="-server -Xmx1024m -XX:MaxPermSize=128m -DTE_BASE=$TE_BASE -Dderby.system.home=$DERBY_DATA"

WORKDIR /
COPY --from=builder /opt/teamengine/teamengine-console/target/teamengine-console-$TEAMENGINE_VERSION-base.zip .
RUN mkdir -p $TE_BASE \
    && unzip teamengine-console-$TEAMENGINE_VERSION-base.zip -d $TE_BASE

RUN mkdir -p $TEAMENGINE_BASE \
    && cd $TEAMENGINE_BASE \
    && cp -r $CATALINA_HOME/conf . \
    && mkdir lib logs temp webapps work

WORKDIR $TEAMENGINE_BASE
COPY --from=builder /opt/teamengine/teamengine-web/target/teamengine.war ./webapps
COPY --from=builder /opt/teamengine/teamengine-web/target/teamengine-common-libs.zip ./
RUN unzip teamengine-common-libs.zip -d lib \
    && rm teamengine-common-libs.zip
