FROM gradle:5.1.1-jdk8-alpine as builder

USER root
RUN mkdir /app
RUN mkdir -p /opt/gradleCache
#RUN chown gradle /app

#USER gradle
WORKDIR /app

ADD build.gradle .
ADD src/test/groovy/Empty.groovy src/test/groovy/

# Download dependencies
RUN gradle check --no-daemon --quiet --stacktrace --gradle-user-home /opt/gradleCache

ADD src/main src/main
RUN gradle installDist --no-daemon --quiet --stacktrace --gradle-user-home /opt/gradleCache

#################################################

FROM gradle:5.1.1-jdk8-alpine as tester

USER root

WORKDIR /app

COPY --from=builder /opt/gradleCache /opt/gradleCache
COPY --from=builder /app /app

ADD src/test /app/src/test

CMD exec /usr/bin/gradle test --no-daemon --gradle-user-home /opt/gradleCache

#################################################

FROM fabric8/java-centos-openjdk8-jre:latest as runner

COPY --from=builder /app/build /app/build

CMD ["/app/build/install/app/bin/app"]