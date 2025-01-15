# container-image-activemq-classic

![build](https://github.com/kred-no/container-image-activemq-classic/actions/workflows/build-and-push.yml/badge.svg)

Container image builds for Apache ActiveMQ Classic message broker.

| Release     | Java RE       |
| :--         | :--           |
| `6.1.5`     | `17`,`21`     |
| ~~`6.1.4`~~ | ~~`17`,`21`~~ |

```bash
# Build & Run Locally
export image="local/activemq:latest"

# Build
docker buildx build -f Dockerfile -t $image .

# Run image; access web-console @localhost:8161
docker run --rm -it -p 8161:8161 -p 61616:61616 $image

# Run image from Docker Hub
export $tag="6.1.4-21-jre-headless-main"
docker run --rm -it -e ADMIN_PASSWORD=Secret -p 8161:8161 -p 61616:61616 docker.io/kdsda/activemq-classic:$tag
```

Se [`examples`](examples/) for other examples

## Runtime Variables

| NAME | DEFAULT |
| :--  | :--     |
| TZ              | `Europe/Oslo` |
| ACTIVEMQ_USER   | `activemq` |
| ACTIVEMQ_HOME   | `/opt/activemq` |
| ACTIVEMQ_CONF   | `${ACTIVEMQ_HOME}/conf` |
| ACTIVEMQ_DATA   | `${ACTIVEMQ_HOME}/data` |
| ACTIVEMQ_TMP    | `${ACTIVEMQ_HOME}/tmp` |
| ADMIN_USERNAME  | `admin` |
| ADMIN_PASSWORD  | `admin` |
| GUEST_PASSWORD  | `password` |
| SYSTEM_USERNAME | `system` |
| SYSTEM_PASSWORD | `manager` |

## Build Arguments

| NAME | DEFAULT |
| :--  | :--     |
| base_image_name       | `docker.io/azul/zulu-openjdk-debian` |
| base_image_tag        | `21-jre-headless` |
| activemq_version      | `6.1.5` |
| activemq_sha512       | `78bf174889ee4d20c220acc9008802f5d10c1253c0190d2b4a3b03c752a2d1a0ff9d2d36213b2f91e3b6d636cd8b0724a5046d0cd6519264a2841a4a09d43cff` |
| postgres_jdbc_version | `42.7.5` |
| postgres_jdbc_sha1    | `747897987b86c741fb8b56f6b81929ae1e6e4b46` |

## Resources

  * [Documentation](https://activemq.apache.org/components/classic/documentation/)
  * [Releases](https://activemq.apache.org/components/classic/download/)
  * [Release Notes](https://issues.apache.org/jira/secure/ReleaseNote.jspa?projectId=12311210&version=12354974)
