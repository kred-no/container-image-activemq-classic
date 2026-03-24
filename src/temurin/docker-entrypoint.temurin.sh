#!/bin/bash

printf "[$(date)] Starting Container .."

printf "\n\n*** CONTAINER INFO ***\n"
printf "  Host: $(hostname)\n"
printf "    IP: $(hostname -I)\n"
printf "    OS: $(cat /etc/issue.net)\n"
printf "*** CONTAINER INFO ***\n\n"

#echo 127.0.0.1 `cat /etc/hostname` | tee -a /etc/hosts

# Transport/connection security
if [ -n "${ACTIVEMQ_CONNECTION_USER}" ]; then
  if [ -f "${ACTIVEMQ_HOME}/conf/connection.security.enabled" ]; then
    echo "ActiveMQ Connection Security enabled"
  else
    echo "Enabling ActiveMQ Connection Security"
    sed -i "s/activemq.username=system/activemq.username=${ACTIVEMQ_CONNECTION_USER}/" ${ACTIVEMQ_HOME}/conf/credentials.properties
    sed -i "s/activemq.password=manager/activemq.password=${ACTIVEMQ_CONNECTION_PASSWORD}/" ${ACTIVEMQ_HOME}/conf/credentials.properties
    read -r -d '' REPLACE << END
      <plugins>
        <simpleAuthenticationPlugin>
          <users>
            <authenticationUser username="$\{activemq.username}" password="$\{activemq.password}"/>
          </users>
        </simpleAuthenticationPlugin>
      </plugins>
    </broker>
END
    REPLACE=${REPLACE//$\\/$}
    REPLACE=${REPLACE//\//\\\/}
    REPLACE=$(echo $REPLACE | tr '\n' ' ')
    sed -i "s/<\/broker>/$REPLACE/" ${ACTIVEMQ_HOME}/conf/activemq.xml
    touch "${ACTIVEMQ_HOME}/conf/connection.security.enabled"
  fi
fi

# JMX security
if [ -n "${ACTIVEMQ_JMX_USER}" ]; then
  if [ -f "${ACTIVEMQ_HOME}/conf/jmx.security.enabled" ]; then
    echo "JMX Security already enabled"
  else
     echo "Enabling ActiveMQ JMX security"
     read -r -d '' REPLACE << END
       <managementContext>
         <managementContext createConnector="true" />
       </managementContext>
     </broker>
END
     REPLACE=${REPLACE//\//\\\/}
     REPLACE=${REPLACE//$\\/$}
     REPLACE=$(echo $REPLACE | tr '\n' ' ')
     sed -i "s/<\/broker>/$REPLACE/" ${ACTIVEMQ_HOME}/conf/activemq.xml
     sed -i "s/admin/${ACTIVEMQ_JMX_USER}/" ${ACTIVEMQ_HOME}/conf/jmx.access
     sed -i "s/admin/${ACTIVEMQ_JMX_USER}/" ${ACTIVEMQ_HOME}/conf/jmx.password
     if [ -n "${ACTIVEMQ_JMX_PASSWORD}" ]; then
       sed -i "s/\ activemq/\ ${ACTIVEMQ_JMX_PASSWORD}/" ${ACTIVEMQ_HOME}/conf/jmx.password
     fi
     touch "${ACTIVEMQ_HOME}/conf/jmx.security.enabled"
  fi
fi

# WebConsole security
if [ -n "${ACTIVEMQ_WEB_USER}" ]; then
  if [ -f "${ACTIVEMQ_HOME}/conf/webconsole.security.enabled" ]; then
    echo "ActiveMQ WebConsole Security already enabled"
  else
    echo "Enabling ActiveMQ WebConsole security"
    sed -i "s/admin=/${ACTIVEMQ_WEB_USER}=/g" ${ACTIVEMQ_HOME}/conf/users.properties
    if [ -n "${ACTIVEMQ_WEB_PASSWORD}" ]; then
      sed -i "s/=admin/=${ACTIVEMQ_WEB_PASSWORD}/g" ${ACTIVEMQ_HOME}/conf/users.properties
    fi
    # Update groups.properties so the new user is a member of the admins group
    # (required by jetty.xml adminSecurityConstraint which expects the 'admins' role)
    sed -i "s/admins=admin/admins=${ACTIVEMQ_WEB_USER}/" ${ACTIVEMQ_HOME}/conf/groups.properties
    touch "${ACTIVEMQ_HOME}/conf/webconsole.security.enabled"
  fi
fi

_term() {
  echo "Received signal, stopping ActiveMQ..."
  if [ -n "${child_pid:-}" ] && kill -0 "${child_pid}" 2>/dev/null; then
    kill -TERM "${child_pid}" 2>/dev/null || true
  fi
}

trap _term TERM INT

"$@" &
child_pid=$!
wait "${child_pid}"

exit $?
