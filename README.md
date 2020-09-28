# Dnsmasq for Docker Containers

Manually managing your `hosts` file is now a thing of the past! Dnsmasq for Docker Containers makes getting domain name resolution to your host a snap. Fire it up and (nearly) out-of-the-box it will monitor for changes in running containers and create the appropriate DNS entries.

## Super Quick Start

Get started faster than light speed with the following:

- Add the environment variable `VIRTUAL_HOST` to the containers you want to resolve. E.G `docker run -p 80 -e VIRTUAL_HOST=helloworld.test tutum/hello-world`
- `docker run -p 53:53/udp -v /var/run/docker.sock:/tmp/docker.sock blobaugh/dnsmasq`
- Add the IP of your server running dnsmasq as a the first DNS entry in your system network preferences

## Mapping a Domain to a Container

Any container with a `VIRTUAL_HOST` environment variable will be picked up and automagically resolved to with dnsmasq.

E.G: `docker run -p 80 -e VIRTUAL_HOST=helloworld.test tutum/hello-world`

NOTE: If you use the jwilder nginx-proxy already then no changes are necessary. The nginx-proxy already relies on the `VIRTUAL_HOST` variable.

## Dnsmasq Configuration

Dnsmasq for Docker Containers comes with a few powerful configuration options out-of-the-box, and an advanced mode for power users.

### Environment Variables

The following environment variables are available to easily tweak how dnsmasq runs.

#### DISABLE_AUTO_DNSMASQ

When set to `true`, dnsmasq will not monitor for containers starting and stopping. Values supplied in the dnsmasq.conf file will be static and manually controlled.

Default: not set

E:G: `docker run -p 53:53/udp -v /var/run/docker.sock:/tmp/docker.sock -e DISABLE_AUTO_DNSMASQ=true blobaugh/dnsmasq`

#### LOG_QUERIES

Keep a log of queries against dnsmasq. The log file is generated to `/var/log/dnsmasq.log`.

Logging of queries is disable by default for performance.

Default: not set

E:G: `docker run -p 53:53/udp -v /var/run/docker.sock:/tmp/docker.sock -e LOG_QUERIES=true blobaugh/dnsmasq`

#### DNS_RESOLVERS

By default no resolvers are set. This means that if a domain is unknown to dnsmasq it will fail. This was done intentionally, as some people prefer using certain DNS servers, and some networks require specific DNS servers.

If you would like to have dnsmasq attempt to resolve all domains, use this setting. 

You may supply more than one DNS server as a comma separated list.

Default: not set

E:G: `docker run -p 53:53/udp -v /var/run/docker.sock:/tmp/docker.sock -e LOG_QUERIES=1.1.1.1,8.8.8.8 blobaugh/dnsmasq`

#### HOST_IP

By default all domains will map to 127.0.0.1. If you are using a host with a different IP, such as running in Digital Ocean, supplying this variable will alter the IP the domains resolve to.

E:G: `docker run -p 53:53/udp -v /var/run/docker.sock:/tmp/docker.sock -e HOST_IP=1.1.1.1, blobaugh/dnsmasq`

### Advanced Mode

For you advanced power users and tweakers out there, take a peek into `dnsmasq.tmpl`. That file contains the template of the dnsmasq.conf file that is generated. It utilizes the Go language templating. 

There are two ways to create new templates:
- Mount the template as a volume to your host and create on the fly changes
- Create your own container image with a new template.

If you are in the advanced camp then I assume you know what those two things are and do not need your hand held in creating them. Cheers.

## Using docker-compose


## Tools

### Monitor DNS configuration

Want to keep an eye on what changes are going on inside dnsmasq? Run this command to pull a fresh copy of the settings every 3 seconds

```docker exec -it CONTAINER_NAME watch -n 3 cat /etc/dnsmasq.conf```

### Watch dnsmasq query log

This requires LOG_QUERIES to be set to true.

If you would like to monitor the requests sent to your dnsmasq server you may do so with the following command:

`docker exec -it CONTAINER_NAME  tail -f /var/log/dnsmasq.log`

## Development Contributions

As with all open source projects, contributions are welcome. The bones of this project were built in a few hours and I by no means consider myself and expert on DNS servers. If you have a better or more secure method, by all means, send a pull request. 

If you have a question or request hit up the Issues tab above.

### Quick start development guide

- `git clone git@github.com:blobaugh/dnsmasq-for-docker.git`
- `git checkout -b my-awesome-branch`
- Make your changes
- Test by running a build `docker build --tag blobaugh/dnsmasq:MYTEST .`

### Publishing to Docker Hub

- `docker login`
- `docker build --tag blobaugh/dnsmasq:VERSION`
- `docker push blobaugh/dnsmasq:VERSION`
