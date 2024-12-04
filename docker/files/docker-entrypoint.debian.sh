#!/usr/bin/dumb-init /bin/sh

printf "\n\n*** CONTAINER INFO ***\n"
printf "  Host: $(hostname)\n"
printf "    IP: $(hostname -I)\n"
printf "    OS: $(cat /etc/issue.net)\n"
printf "*** CONTAINER INFO ***\n\n"

########################
## Pre-start Validation
########################

if [ -z ${ACTIVEMQ_USER} ]; then echo "[ERROR] Required variable ACTIVEMQ_USER is not set."; exit 1; fi
if [ -z ${ACTIVEMQ_HOME} ]; then echo "[ERROR] Required variable ACTIVEMQ_HOME is not set."; exit 1; fi
if [ -z ${ACTIVEMQ_CONF} ]; then echo "[ERROR] Required variable ACTIVEMQ_CONF is not set."; exit 1; fi
if [ -z ${ACTIVEMQ_DATA} ]; then echo "[ERROR] Required variable ACTIVEMQ_DATA is not set."; exit 1; fi
if [ -z ${ACTIVEMQ_TMP} ]; then echo "[ERROR] Required variable ACTIVEMQ_TMP is not set."; exit 1; fi

########################
## Append hostname to hostsfile on startup
########################

echo 127.0.0.1 `cat /etc/hostname` | tee -a /etc/hosts

########################
## Update Credentials
########################

printf "%s\n" \
  "${ADMIN_USERNAME}=${ADMIN_PASSWORD}" \
  | tee ${ACTIVEMQ_CONF}/users.properties

printf "%s\n" \
  "admins=${ADMIN_USERNAME}" \
  | tee ${ACTIVEMQ_CONF}/groups.properties

printf "activemq.username=%s\nactivemq.password=%s\nguest.password=%s\n" \
  "${SYSTEM_USERNAME}" \
  "${SYSTEM_PASSWORD}" \
  "${GUEST_PASSWORD}" \
  | tee ${ACTIVEMQ_CONF}/credentials.properties

printf "activemq.username=%s\nactivemq.password=ENC(%s)\nguest.password=ENC(%s)\n" \
  "${SYSTEM_USERNAME}" \
  "$(activemq encrypt --password ${ACTIVEMQ_ENCRYPTION_PASSWORD} --input ${SYSTEM_PASSWORD} | grep "Encrypted text:" | awk '{print $3}')" \
  "$(activemq encrypt --password ${ACTIVEMQ_ENCRYPTION_PASSWORD} --input ${GUEST_PASSWORD} | grep "Encrypted text:" | awk '{print $3}')" \
  | tee ${ACTIVEMQ_CONF}/credentials-enc.properties

########################
## Start service
########################

if id ${ACTIVEMQ_USER} >/dev/null 2<&1; then
  printf "[INFO] Starting server as user \"${ACTIVEMQ_USER}\"..\n\n"
  mkdir -p ${ACTIVEMQ_TMP}
  mkdir -p ${ACTIVEMQ_DATA}
  chown -HR ${ACTIVEMQ_USER}:${ACTIVEMQ_USER} ${ACTIVEMQ_HOME}
  chown -HR ${ACTIVEMQ_USER}:${ACTIVEMQ_USER} ${ACTIVEMQ_CONF}
  chown -HR ${ACTIVEMQ_USER}:${ACTIVEMQ_USER} ${ACTIVEMQ_DATA}
  chown -HR ${ACTIVEMQ_USER}:${ACTIVEMQ_USER} ${ACTIVEMQ_TMP}

  # Make JVM-variable(s) global when running as non-root. Not passed when using gosu
  echo JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS} | tee -a /etc/environment
  set -- gosu ${ACTIVEMQ_USER} ${@}
else
  printf "[WARNING] User \"${ACTIVEMQ_USER}\" doesn't exist. Starting server as \"root\"\n"
fi

exec "${@}"
