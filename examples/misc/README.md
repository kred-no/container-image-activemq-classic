# Examples

```bash
# Basic example
#   [ActiveMQ UI] http://localhost:8161
docker compose -f compose.kaha.yml up
docker compose -f compose.kaha.yml --volumes --remove-orphans

# Postgres for persistence + Prometheus metrics
#     [ActiveMQ UI] http://localhost:8161
#   [Prometheus UI] http://localhost:9090
docker compose -f compose.postgres.yml -f compose.override.yml up
docker compose -f compose.postgres.yml -f compose.override.yml down --volumes --remove-orphans
```