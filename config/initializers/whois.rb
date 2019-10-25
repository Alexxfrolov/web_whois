# frozen_string_literal: true

# Define a server for the .it extension
Whois::Server.define :tld, "it", "whois.nic.it"

# Define a server for the .gr extension
Whois::Server.define :tld, "gr", "whois.iana.org"

# Define a new server for an range of IPv4 addresses
Whois::Server.define :ipv4, "61.192.0.0/12", "whois.nic.ad.jp"

# Define a new server for an range of IPv6 addresses
Whois::Server.define :ipv6, "2001:2000::/19", "whois.ripe.net"

# Define a new server with a custom adapter
Whois::Server.define :tld, "test", nil,
                     adapter: Whois::Server::Adapters::None

# # Define a new server with a custom adapter and options
# Whois::Server.define :tld, "ar", nil,
#                      adapter: Whois::Server::Adapters::Web,
#                      url: "http://www.nic.ar/"
