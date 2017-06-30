########################################################################
# Dockerfile for Oracle JDK 8 on Ubuntu 14.04
########################################################################

# pull base image
FROM ubuntu:16.04

# maintainer details
MAINTAINER Fabrizio Torelli <hellgate75@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
    h2oVersion=3.10.0.3 \
    H2O_CLOUD_NAME= \
    H2O_FLAT_FILE_IPS= \
    H2O_MACHINE_IP= \
    H2O_REST_API_PORT= \
    H2O_BASE_PORT= \
    H2O_DISCOVERY_CID= \
    H2O_DEDICATED_MAX_THREADS=5 \
    H2O_CLIENT_MODE= \
    H2O_JVM_HEAP_SIZE=4G

# add a post-invoke hook to dpkg which deletes cached deb files
# update the sources.list
# update/dist-upgrade
# clear the caches


RUN \
  echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache && \
  echo "deb http://mirror.math.princeton.edu/pub/ubuntu trusty main universe" >> /etc/apt/sources.list && \
  apt-get update -q -y && \
  apt-get dist-upgrade -y && \
# Install Oracle Java 7
  export DEBIAN_FRONTEND=noninteractive && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip python-pip python-sklearn python-pandas python-numpy python-matplotlib software-properties-common python-software-properties && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update -q && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer && \
  apt-get clean && \
  apt-get -y autoclean && \
#  rm -rf /var/cache/apt/* && \
  rm -rf /var/lib/apt/lists/* && \
# Fetch h2o latest_stable
  wget http://h2o-release.s3.amazonaws.com/h2o/latest_stable -O latest && \
  wget --no-check-certificate -i latest -O /opt/h2o.zip && \
  unzip -d /opt /opt/h2o.zip && \
  rm /opt/h2o.zip && \
  cd /opt && \
  cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \
  cp h2o.jar /opt && \
  /usr/bin/pip install `find . -name "*.whl"` && \
  cd / && \
  wget https://raw.githubusercontent.com/h2oai/h2o-3/master/docker/start-h2o-docker.sh && \
  chmod +x start-h2o-docker.sh && \

# Get Content
  wget http://s3.amazonaws.com/h2o-training/mnist/train.csv.gz && \
  gunzip train.csv.gz && \
  wget https://raw.githubusercontent.com/laurendiperna/Churn_Scripts/master/Extraction_Script.py  && \
  wget https://raw.githubusercontent.com/laurendiperna/Churn_Scripts/master/Transformation_Script.py && \
  wget https://raw.githubusercontent.com/laurendiperna/Churn_Scripts/master/Modeling_Script.py

#Install R
RUN apt-get update && \
    apt-get install -y apt-transport-https && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/' && \
    apt-get update && \
    apt-get install -y r-base --no-install-recommends && \
    apt-get clean && \
    apt-get -y autoclean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Installing H2O for R" /usr/bin/R --slave -e 'install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R")))'

RUN echo "Installing H2O for Python..." && pip install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

# Define a mountable data directory
RUN mkdir /data && mkdir flows
VOLUME ["/data", "/flows"]

# Define the working directory
WORKDIR /opt
COPY run-h2o.sh /usr/local/bin/run-h2o
RUN chmod 777 /usr/local/bin/run-h2o

EXPOSE 54321 54322 55555

ENTRYPOINT ["run-h2o"]
# Define default command

CMD \
  ["/bin/bash"]
