# WIP TEST INSTANCE

## plex_wg_stack 

### About

**plew_wg_stack** is a collection of two Docker Compose files and related configurations. The first one is designed to run a WireGuard container from LinuxServer.io (lsio) as a server, intended for deployment on an affordable VPS. The second Compose file runs an lsio Plex container with default IP routing modified to pass through a WireGuard container, which operates as a client on the same machine.

A set of scripts is also included to assist in configuring the WireGuard containers.

Here are a few key points to consider with this stack:

- The primary objective is to either run Plex behind a VPN or access Plex from within a VPN. This approach can be applied to other lsio containers as well.

- **This stack does not use `network_mode: "service:wireguard"**. This choice is made to avoid conflicts in the use of container networks, enabling the concurrent operation of multiple stacks within the same VPN/container. This setup allows you to run multiple services like Plex, WireGuard, Transmission, and others without port conflicts. Your web user interface and any existing reverse proxy configurations will continue to function when connected to the VPN.

- The bundle of scripts provided is intended to facilitate the setup of the WireGuard container. They are not mandatory, and you can use your custom configurations if desired.

- This stack supports only lsio containers or containers running on s6-overlay.

- On the server side, port forwarding is handled within the container, and Docker manages the port forwarding from the host to the container.