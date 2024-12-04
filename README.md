# container-image-activemq-classic

![build](https://github.com/kred-no/container-image-activemq-classic/actions/workflows/build-and-push.yml/badge.svg)

Container image builds for Apache ActiveMQ Classic message broker.

| Release | Java RE    |
| :--     | :--        |
| `6.1.4` | `17`,`21`  |

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
| activemq_version      | `6.1.4` |
| activemq_sha512       | `a88f672e5190e122cdcd251b01acc0a2fa20695c1da2f0c93269ba50f4554ce01b980fd5082be86ab99f5d3161ce137cdf74013b29da477161b6a60b3993ba46` |
| postgres_jdbc_version | `42.7.4` |
| postgres_jdbc_sha1    | `264310fd7b2cd76738787dc0b9f7ea2e3b11adc1` |

## Resources

  * [Documentation](https://activemq.apache.org/components/classic/documentation/)
  * [Releases](https://activemq.apache.org/components/classic/download/)
  * [Release Notes](https://issues.apache.org/jira/secure/ReleaseNote.jspa?projectId=12311210&version=12354974)
