#!/bin/sh

# Let's exit the script if there are issues
set -e

# The file we want to watch
FILE=/etc/dnsmasq.sh

# Easy method to check for file changes
function checkfile() {
        md5sum /etc/dnsmasq.conf | cut -d " " -f1
}
# Start the initial run of dnsmasq
dnsmasq

echo "NOTICE: dnsmasq running"

# Set the initial file check
MD5=$(checkfile);

# Start the docker-gen service
# This watches for new containers to come online and will register
# them with dnsmasq
# See https://github.com/jwilder/docker-gen
if [ -z "$DISABLE_AUTO_DNSMASQ" ]
then
	echo "NOTICE: Starting docker-gen monitoring"
	docker-gen -config /etc/docker-gen.conf&
fi

# As long as dnsmasq is running we want to continue this loop
while [ `pidof dnsmasq` ]
do
        if [ $MD5 != $(checkfile) ]
        then
                echo "RELOADING DNSMASQ: The dnsmasq.conf file has changed"
		kill -9 $(pidof dnsmasq)
		dnsmasq
                MD5=$(checkfile);
        fi
done
