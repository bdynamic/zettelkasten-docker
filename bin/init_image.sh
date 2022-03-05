#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source "$SCRIPTPATH/../config"
PERSISTEND=$(realpath "$PERSISTEND")

if [ -d "$PERSISTEND" ]; then
	echo "Persistend path exists! ($PERSISTEND)"
	echo "Will stop now"
	exit 1
else
	mkdir -p "$PERSISTEND"
fi

echo ""
echo "########################################"
echo "Image Name: $IMAGENAME"
echo "Containername: $CONTAINERNAME"
echo "Data will be stored here: $PERSISTEND" 
echo "Upstream gitrepo will be: $REPO"
echo "########################################"

echo ""
echo "Building image for $IMAGENAME"
docker build -t "$IMAGENAME" "$SCRIPTPATH/../"


mkdir -p "$PERSISTEND"

echo ""
echo "Starting container once"
docker run -d --name="$CONTAINERNAME" -e PUID=1000 -e PGID=1000   --network bnet -e TZ=Europe/Berlin  -p "$HTTPPORT":80  -p "$SSLPORT":443 -v "$PERSISTEND":/config   --restart unless-stopped "$IMAGENAME"
echo "Wait 20s to make sure everything initialized"
sleep 20
echo "Stopping container"
docker stop "$CONTAINERNAME"



echo "Docker image should be generated and data initialized"
echo "Take care of your ssh keys (see manual)"
echo "then start the container with the start command"
echo "Afterwards initialize the git stuff :-)"

exit 0