# container-image-activemq-classic

![build](https://github.com/kred-no/container-image-activemq-classic/actions/workflows/debian-build.yml/badge.svg)
![build](https://github.com/kred-no/container-image-activemq-classic/actions/workflows/temurin-build.yml/badge.svg)

Container image builds for Apache ActiveMQ Classic message broker.

  * [Docker Hub Registry]("https://hub.docker.com/r/kdsda/activemq-classic")

#### Tags

  * `<activemq-version>-debian-<java-version>-<build-id>`
  * `<activemq-version>-temurin-<java-version>-<build-id>`


## Runtime Variables (debian)

| Name | Description | Default |
| --:  | :--         | :--     |
| ADMIN_USERNAME  | N/A | `admin` |
| ADMIN_PASSWORD  | N/A | `admin` |
| GUEST_PASSWORD  | N/A | `password` |
| SYSTEM_USERNAME | N/A | `system` |
| SYSTEM_PASSWORD | N/A | `manager` |
| TZ              | N/A | `Europe/Oslo` |


## Variables (temurin)

| Name | Description | Default |
| --:  | :--         | :--     |
| ACTIVEMQ_CONNECTION_USER     | Override MQueue User      | `admin (unset)` |
| ACTIVEMQ_CONNECTION_PASSWORD | Override MQueue Password  | `admin (unset)` |
| ACTIVEMQ_WEB_USER            | Override Console User     | `system (unset)` |
| ACTIVEMQ_WEB_PASSWORD        | Override Console Password | `manager (unset)` |
| ACTIVEMQ_JMX_USER            | Override JMX User         | `admin (unset)` |
| ACTIVEMQ_JMX_PASSWORD        | Override JMX Password     | `activemq (unset)` |
| ACTIVEMQ_OPTS                | ActiveMQ Runtime Flags    | `-Djava.util.logging.config.file=logging.properties -Djava.security.auth.login.config=${ACTIVEMQ_CONF}/login.config -Djetty.host=0.0.0.0` |
| JAVA_TOOL_OPTIONS            | Java Runtime Flags        | `-XX:+ExitOnOutOfMemoryError -XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=75.0 -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=500 -XX:+PerfDisableSharedMem -Xss512k -Xshare:on -Xlog:gc*:stdout:uptime,level,tags` |
| TZ                           | Timezone                  | `Europe/Oslo` |

>NOTE: Entrypoint based on official activemq classic container build


## Misc File/Folder Locations

| Location | Description | 
| --:      | :--         |
| `/opt/activemq/conf/activemq.xml` | Primary configuration file |
| `/opt/activemq/conf/jetty.xml`    | Jetty/console configuration file |
| `/opt/activemq/data`              | Data folder (e.g. KahaDB) |
| `/usr/local/bin/entrypoint`       | Entrypoint for container |

>NOTE: If you override any files, take care in case entrypoint parse them on startup.


## Local Development

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

See [`examples`](examples/) for other examples.

## Resources

  * [Documentation](https://activemq.apache.org/components/classic/documentation/)
  * [Releases](https://activemq.apache.org/components/classic/download/)
  * [Release Notes](https://issues.apache.org/jira/secure/ReleaseNote.jspa?projectId=12311210&version=12354974)
