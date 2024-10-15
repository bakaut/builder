# Step 1: Use OpenJDK 8 as base image
FROM openjdk:8-jdk-alpine

# Step 2: Install Maven
RUN apk add --no-cache curl tar bash \
    && mkdir -p /usr/share/maven \
    && curl -o /tmp/apache-maven-3.6.3-bin.tar.gz https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
    && tar xzf /tmp/apache-maven-3.6.3-bin.tar.gz -C /usr/share/maven --strip-components=1 \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Step 3: Set environment variables
ENV MAVEN_HOME /usr/share/maven
ENV PATH $MAVEN_HOME/bin:$PATH

# Step 4: Clone the repository
RUN git clone https://github.com/aws-samples/elasticache-iam-auth-demo-app.git /app

# Step 5: Build the application
WORKDIR /app
RUN mvn clean verify

RUN ls -la
