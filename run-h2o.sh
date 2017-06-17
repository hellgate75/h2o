#!/bin/bash
cd /opt
H2O_ARGS=" "
if ! [[ -z "$H2O_CLOUD_NAME" ]]; then
  H2O_ARGS="$H2O_ARGS -name $H2O_CLOUD_NAME"
fi
if ! [[ -z "$H2O_FLAT_FILE_IPS" ]]; then
  H2O_ARGS="$H2O_ARGS -flatfile $H2O_FLAT_FILE_IPS"
fi
if ! [[ -z "$H2O_MACHINE_IP" ]]; then
  H2O_ARGS="$H2O_ARGS -ip $H2O_MACHINE_IP"
fi
if ! [[ -z "$H2O_BASE_PORT" ]]; then
  H2O_ARGS="$H2O_ARGS -baseport $H2O_BASE_PORT"
fi
if ! [[ -z "$H2O_REST_API_PORT" ]]; then
  H2O_ARGS="$H2O_ARGS -port $H2O_REST_API_PORT"
fi
if ! [[ -z "$H2O_DISCOVERY_CID" ]]; then
  H2O_ARGS="$H2O_ARGS -network $H2O_DISCOVERY_CID"
fi
if ! [[ -z "$H2O_DEDICATED_MAX_THREADS" ]]; then
  H2O_ARGS="$H2O_ARGS -nthreads $H2O_DEDICATED_MAX_THREADS"
fi
if [[ "$H2O_CLIENT_MODE" == "yes" ]]; then
  H2O_ARGS="$H2O_ARGS -client"
fi
echo "Running H2O with arguments : H2O_ARGS"
java -Xmx$H2O_JVM_HEAP_SIZE -jar h2o.jar -ice_root /data -flow_dir /flows"$H2O_ARGS"
