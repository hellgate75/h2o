# H2O Machine Learning engine

Docker Image for h2o


### Introduction ###

H2O is a Machine learning engine, working as standa-alone node or on a clustered (cloud) mode.

Here some more info on H2O :
http://docs.h2o.ai/h2o/latest-stable/h2o-docs/index.html


### Goals ###

This doscker images has been designed to be a test, development, integration environment for H2O processes in machine learning sector.
*No warranties for production use.*

NOTE: Will be released soon a production docker image.


### Docker Image features ###

Here some information :

Volumes : /data , /flows

Data Volume is used to store logs and archives.

Flows volumes is used to store or import flows files.

Ports: 54321, 54322

Port 54321 is default http port

Port 54322 is default rest service port


### Docker Environment Variable ###

Here h2o container environment variable :
* `H2O_JVM_HEAP_SIZE` : To set the total heap size for an H2O node, configure the memory allocation option -Xmx. When launching nodes, we recommend allocating a total of four times the memory of your data. (default: 4G, reccomended minimum: 1G)
* `H2O_CLOUD_NAME` : Assign a name to the H2O instance in the cloud (where <H2OCloudName> is the name of the cloud). Nodes with the same cloud name will form an H2O cloud (also known as an H2O cluster).
* `H2O_FLAT_FILE_IPS` : Specify a flatfile of IP address for faster cloud formation
* `H2O_REST_API_PORT` : Specify a PORT used for REST API. The communication port will be the port with value +1 higher.
* `H2O_MACHINE_IP`specifies IP for the machine other than the default localhost, for example: IPv4: -ip 178.16.2.223 and  IPv6: -ip 2001:db8:1234:0:0:0:0:1 (Short version of IPv6 with :: is not supported.) Note: If you are selecting a link-local address fe80::/96, it is necessary to specify the zone index (e.g., %en0 for fe80::2acf:e9ff:fe15:e0f3%en0) in order to select the right interface. default(localhost)
* `H2O_BASE_PORT` : Specifies starting port to find a free port for REST API, the internal communication port will be port with value +1 higher.
* `H2O_DISCOVERY_CID` :  (`<ip_address/subnet_mask>`) Specify an IP addresses with a subnet mask. The IP address discovery code binds to the first interface that matches one of the networks in the comma-separated list; to specify an IP address, use -network. To specify a range, use a comma to separate the IP addresses: `123.45.67.0/22,123.45.68.0/24`. For example, 10.1.2.0/24 supports 256 possibilities. IPv4 and IPv6 addresses are supported.
* `H2O_DEDICATED_MAX_THREADS` : Specify the maximum number of threads in the low-priority batch work queue. (default: 5)
* `H2O_CLIENT_MODE` : Launch H2O node in client mode. This is used mostly for running Sparkling Water. (yes/no, default: no)



### Sample command ###

Here a sample command to run h2o container:

```bash
docker run -d -p 8098:54321 -p 8099:54322 -v /path/to/store/data:/data -v /path/to/store/flows:/flows --name my-h2o hellgate75/h2o:latest
```

### Test Container ###

On your browser open URL: http://localhost:54321/ , if you have a specific ip address for the container in an external or remote machine
instance type: http://h2o_instance_ip_address:54321/

### License ###

[LGPL 3](/LICENSE)
