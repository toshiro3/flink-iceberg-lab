FROM flink:1.18

# Hadoopバージョン
ENV HADOOP_VERSION=3.3.4

# Iceberg Flink Runtime JAR
RUN curl -L -o /opt/flink/lib/iceberg-flink-runtime-1.18-1.6.1.jar \
    https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-1.18/1.6.1/iceberg-flink-runtime-1.18-1.6.1.jar

# AWS Bundle（S3アクセス用）
RUN curl -L -o /opt/flink/lib/iceberg-aws-bundle-1.6.1.jar \
    https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/1.6.1/iceberg-aws-bundle-1.6.1.jar

# Flink S3 Filesystem（プラグインとして配置）
RUN mkdir -p /opt/flink/plugins/s3-fs-hadoop && \
    cp /opt/flink/opt/flink-s3-fs-hadoop-*.jar /opt/flink/plugins/s3-fs-hadoop/

# Hadoop Client API（コア依存関係を含む）
RUN curl -L -o /opt/flink/lib/hadoop-client-api-${HADOOP_VERSION}.jar \
    https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client-api/${HADOOP_VERSION}/hadoop-client-api-${HADOOP_VERSION}.jar

# Hadoop Client Runtime（ランタイム依存関係を含む）
RUN curl -L -o /opt/flink/lib/hadoop-client-runtime-${HADOOP_VERSION}.jar \
    https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client-runtime/${HADOOP_VERSION}/hadoop-client-runtime-${HADOOP_VERSION}.jar

# Hadoop AWS（S3A用）
RUN curl -L -o /opt/flink/lib/hadoop-aws-${HADOOP_VERSION}.jar \
    https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar

# AWS SDK Bundle
RUN curl -L -o /opt/flink/lib/aws-java-sdk-bundle-1.12.648.jar \
    https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.648/aws-java-sdk-bundle-1.12.648.jar