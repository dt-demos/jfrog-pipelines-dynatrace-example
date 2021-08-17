FROM openjdk:15

ARG RESOURCE_PATH=target/
ENV RESOURCE_PATH=$RESOURCE_PATH

COPY $RESOURCE_PATH/*.jar .

# used to set the problem pattern
ARG APP_VERSION=1
ENV APP_VERSION=$APP_VERSION

EXPOSE 8080

CMD ["sh", "-c", "/usr/bin/java -Xmx400m -Xms400m -jar *.jar"]
