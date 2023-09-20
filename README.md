# WIP TEST INSTANCE

## plex_wg_stack 

### About

plex_wg_stack is a docker-compose file that sets up a WireGuard VPN server and a Plex media server. It is designed to be easy to use and configure, and it can be used on any system that supports Docker.


### Installation

To install plex_wg_stack:

* clone the repository
* create a `.env` file following your need
* run the following command:

```
docker-compose up -d
```

This will create and start the WireGuard and Plex containers.

### Configuration

The following environment variables can be set in `.env` file to configure the WireGuard and Plex containers:

* `WG_TAG`: The version of the WireGuard image to use.
* `PLEX_TAG`: The version of the Plex image to use.
* `XID`: The user ID to use for the WireGuard and Plex containers.
* `TZ`: The timezone to use for the WireGuard and Plex containers.

### Usage

WIP

### Troubleshooting

If you have any problems with plex_wg_stack, please check the following:

* The Docker service is running.
* The WireGuard and Plex containers are running.
* The WireGuard and Plex ports are open on your firewall.
* The WireGuard and Plex configuration files are correct.
