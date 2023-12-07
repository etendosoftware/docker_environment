FROM openjdk:11-slim as builder
RUN groupadd -r user && useradd -r -g user user
COPY ./etendo /app
WORKDIR /app
RUN mkdir -p /home/user/.gradle
RUN chown -R user:user /home/user
RUN chown -R user:user /app

ENV HOST_ADDRESS "localhost"
USER user

RUN echo "bbdd.url=jdbc:postgresql://${HOST_ADDRESS}\:5432" >> gradle.properties

RUN echo "SETUP" \
    && ./gradlew setup --info 

ARG INSTALL=false
RUN if [ "$INSTALL" = "true" ]; then ./gradlew install --info; else ./gradlew update.database --info; fi

ENV CATALINA_HOME=/opt/EtendoERP/webapps/etendo
USER root
RUN mkdir -p $CATALINA_HOME && chown -R user:user $CATALINA_HOME
USER user
RUN echo "COMPILATION TASK" \
    && ./gradlew smartbuild --info

RUN sed -i "/bbdd.url=.*/d" WebContent/WEB-INF/Openbravo.properties
RUN echo "bbdd.url=jdbc:postgresql://postgres\:5432" >> WebContent/WEB-INF/Openbravo.properties

RUN echo "GENERATE WAR" \
    && ./gradlew antWar --info

FROM tomcat:8.5.51-jdk11-openjdk-slim
COPY --from=builder /app/lib/etendo.war /usr/local/tomcat/webapps/etendo.war