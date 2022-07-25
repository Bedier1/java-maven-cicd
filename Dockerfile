FROM maven

WORKDIR /usr/app
COPY . .    
RUN mvn package
RUN mkdir /app
COPY ./target/java-maven-app-*.jar  /app
WORKDIR /app

CMD ["java", "-jar", "java-maven-app-*.jar"]
