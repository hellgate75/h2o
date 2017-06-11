#!/bin/bash
cd /opt
java -Xmx4g -jar h2o.jar -ice_root /data -flow_dir /flows -nthreads 5
