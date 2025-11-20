echo "[!] Creating postgresql DB container..."
docker run -d --rm \
         -e POSTGRES_USER=local_rqb_svc \
         -e POSTGRES_PASSWORD=docker \
         -e POSTGRES_DB=local_rqb_svc \
         --tmpfs /var/lib/postgresql/data \
         -p 5432:5432 \
         postgres:17


echo "[!] Confluent network..."
docker network create kafka-playground 2>/dev/null

echo "[!] Zookeeper container..."
docker run -d --rm \
         --name zookeeper \
         --network kafka-playground \
         -e ZOOKEEPER_CLIENT_PORT=2181 \
         -e ZOOKEEPER_TICK_TIME=2000 \
         confluentinc/cp-zookeeper:7.7.0

echo "[!] Creating Kafka container..."
docker run -d --rm \
  --name kafka \
  --network kafka-playground \
  -p 9070:9071 \
  -e KAFKA_BROKER_ID=1 \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9071 \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9071 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
  confluentinc/cp-kafka:7.7.0

echo "[!] Creating Schema container..."
docker run -d --rm \
         --name schema-registry \
         --network kafka-playground \
         -p 8088:8081 \
         -e SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS=PLAINTEXT://kafka:9071 \
         -e SCHEMA_REGISTRY_HOST_NAME=schema-registry \
         -e SCHEMA_REGISTRY_LISTENERS=http://0.0.0.0:8081 \
         confluentinc/cp-schema-registry:7.7.0


