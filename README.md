# socat-netns

This is a script (and systemd service) which use socat to redirect a port
from a Linux network namespace (netns) to another netns.

## Installing

Run `sudo make install`.

## Using the script

The script usage is:

    socat-netns <protocol> <source netns or 'default'> <source port> <destination netns or 'default'> <destination port>

- protocol can be either `tcp` or `udp`
- the source netns or destination netns can be set to `default` to specify the default network namespace.

The script will first check or wait that the netns are created, then it will use socat to redirect the port
from the source netns to the destination netns using the specified protocol.

### Example

Let's suppose you want to redirect the TCP port 8000 from the netns `vpn1` to the port 7000 on netns `vpn0`.

You can then run the command:

    socat-netns tcp vpn1 8000 vpn0 7000

The script will verify that the netns exist and then will run the command:

    ip netns exec vpn1 socat tcp-LISTEN:8000,reuseaddr,fork EXEC:'ip netns exec vpn0 socat STDIO "tcp-CONNECT:127.0.0.1:7000"'

If you want to use udp instead, you can use the command:

    socat-netns udp vpn1 8000 vpn0 7000

and the script will run the command:

    ip netns exec vpn1 socat udp-RECVFROM:8000,reuseaddr,fork EXEC:'ip netns exec vpn0 socat -u STDIO "udp-SENDTO:127.0.0.1:7000"'

## Systemd service

You can add as many socat redirects as you want using different systemd services.
The service name contains all the parameters of the script above, separated by slashes.

A service named
`socat-netns@<PROTOCOL>-<NETNS_SOURCE>-<PORT_SOURCE>-<NETNS_DEST>-<PORT_DEST>.service`
will use the `socat-netns` script above to redirect the port using the specified parameters.

Using the example above, we have the service `socat-netns@tcp-vpn1-8000-vpn0-7000`

Start the new service:

    sudo systemctl start socat-netns@tcp-vpn1-8000-vpn0-7000

Check the logs:

    journalctl -u socat-netns@tcp-vpn1-8000-vpn0-7000

Enable it at boot:

    sudo systemctl enable socat-netns@tcp-vpn1-8000-vpn0-7000
