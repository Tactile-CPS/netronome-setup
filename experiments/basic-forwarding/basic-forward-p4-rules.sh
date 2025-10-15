# Commands to add rules to Match-Action tables
## Add port-to-port forwarding rules
### Physical ports p0,p1, virtual ports v0.0-v0.3
/opt/netronome/p4/bin/rtecli tables -i 1 -r forward1 add \
-m '{ "standard_metadata.ingress_port" : {  "value" : "p0" } }' \
-a '{ "type" : "ingress::forward_all_packets_action",  "data" : { "port" : { "value" : "p1" } } }'

/opt/netronome/p4/bin/rtecli tables -i 1 -r forward2 add \
-m '{ "standard_metadata.ingress_port" : {  "value" : "p1" } }' \
-a '{ "type" : "ingress::forward_all_packets_action",  "data" : { "port" : { "value" : "p0" } } }'

/opt/netronome/p4/bin/rtecli tables -i 1 -r forward3 add \
-m '{ "standard_metadata.ingress_port" : {  "value" : "v0.0" } }' \
-a '{ "type" : "ingress::forward_all_packets_action", "data" : { "port" : { "value" : "p0" } } }'

/opt/netronome/p4/bin/rtecli tables -i 1 -r forward4 add \
-m '{ "standard_metadata.ingress_port" : {  "value" : "v0.1" } }' \
-a '{ "type" : "ingress::forward_all_packets_action", "data" : { "port" : { "value" : "p0" } } }'

/opt/netronome/p4/bin/rtecli tables -i 1 -r forward5 add \
-m '{ "standard_metadata.ingress_port" : {  "value" : "v0.2" } }' \
-a '{ "type" : "ingress::forward_all_packets_action", "data" : { "port" : { "value" : "p1" } } }'

/opt/netronome/p4/bin/rtecli tables -i 1 -r forward6 add \
-m '{ "standard_metadata.ingress_port" : {  "value" : "v0.3" } }' \
-a '{ "type" : "ingress::forward_all_packets_action", "data" : { "port" : { "value" : "p1" } } }'

