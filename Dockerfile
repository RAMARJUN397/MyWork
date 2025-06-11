FROM eclipse-temurin:17-jdk-alpine
MAINTAINER "Arjun DevOps World"
# Add health check to address CIS-DI-0006
HEALTHCHECK --interval=30s --timeout=2s --start-period=5s --retries=3 CMD curl -f http://localhost:2510/index.html || exit 1
VOLUME /tmp
COPY target/*.jar BankingApplication.jar
ENTRYPOINT ["java","-jar","/BankingApplication.jar"]
