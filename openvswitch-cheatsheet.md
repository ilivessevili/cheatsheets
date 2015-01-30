OpenvSwitch CheatSheet
======================



#=manipulate the ovsdb=
--------------------

show ovsdb config
----------------
```bash
sudo ovs-vsctl show
```


add bridge
----------
```bash
sudo ovs-vsctl --may-exist add-br br0
```

add port to bridge
------------------
```bash
sudo ovs-vsctl --may-exist add-port  br0 portname
```

list bridges
------------
```bash
sudo ovs-vsctl list-br
```

list ports
------------
```bash
sudo ovs-vsctl list-ports br0
```

set peers
---------
creates bridges br0 and br1, adds eth0 and tap0 to br0, adds tap1 to br1, and then connects br0 and br1 with a pair of patch ports
```bash
sudo   ovs-vsctl add-br br0
sudo   ovs-vsctl add-port br0 eth0
sudo   ovs-vsctl add-port br0 tap0
sudo   ovs-vsctl add-br br1
sudo   ovs-vsctl add-port br1 tap1
sudo   ovs-vsctl \
       -- add-port br0 patch0 \
       -- set interface patch0 type=patch options:peer=patch1 \
       -- add-port br1 patch1 \
       -- set interface patch1 type=patch options:peer=patch0
oputput of sudo ovs-vsctl show

Bridge "br0"
        Port "br0"
            Interface "br0"
                type: internal
        Port "eth0"
            Interface "eth0"
        Port "tap0"
            Interface "tap0"
        Port **"patch0"**
            Interface "patch0"
                type: patch
                options: {peer="patch1"}
    Bridge my-br
        Port my-br
            Interface my-br
                type: internal
        Port "port1"
            Interface "port1"
    Bridge "br1"
        Port "tap1"
            Interface "tap1"
        Port **"patch1"**
            Interface "patch1"
                type: patch
                options: {peer="patch0"}
        Port "br1"
            Interface "br1"
                type: internal
    ovs_version: "2.0.2"
```


mirror port
-----------
configure br0 with eth0 and tap0 as trunk ports. All traffic coming in or going out on eth0 or tap0 is also mirrored to tap1; any traffic arriving on tap1 is dropped

```bash
sudo   ovs-vsctl add-br br0
sudo   ovs-vsctl add-port br0 eth0
sudo   ovs-vsctl add-port br0 tap0
sudo   ovs-vsctl add-port br0 tap1 \
       -- --id=@p get port tap1 \
       -- --id=@m create mirror name=m0 select-all=true output-port=@p \
       -- set bridge br0 mirrors=@m
Bridge "br0"
        Port "eth0"
            Interface "eth0"
        Port "br0"
            Interface "br0"
                type: internal
        Port "tap1" <-- **mirrored port**
            Interface "tap1"
        Port "tap0"
            Interface "tap0"

```

configure a VLAN as an RSPAN VLAN
---------------------------------
configure br0 with eth0 as a trunk port and tap0 as an access port for VLAN 10. All traffic coming in or going out on tap0, as well as traffic coming in or going out on eth0 in VLAN 10, is also mirrored to VLAN 15 on eth0. 

```bash
sudo   ovs-vsctl --may-exist add-br br0
sudo   ovs-vsctl --may-exist add-port br0 eth0
sudo   ovs-vsctl --may-exist add-port br0 tap0 tag=10
sudo   ovs-vsctl  \
       -- --id=@m create mirror name=m0 select-all=true select-vlan=10 \
                                output-vlan=15 \
       -- set bridge br0 mirrors=@m
output

 Bridge "br0"
        Port "tap0"
            tag: 10
            Interface "tap0"
        Port "eth0"
            Interface "eth0"
        Port "br0"
            Interface "br0"
                type: internal

```

set VLAN tag to port
--------------------
```bash
sudo   ovs-vsctl --may-exist add-br br0
sudo   ovs-vsctl --may-exist add-port br0 p0 tag=10

oputput
Bridge "br0"
        Port "p0"
            tag: **10**
            Interface "p0"
        Port "tap0"
            tag: 10
            Interface "tap0"
        Port "eth0"
            Interface "eth0"
        Port "br0"
            Interface "br0"
                type: internal

```

setup GRE/VXLAN tunnel
---
```bash
ovs-vsctl add-br testbr
ifconfig testbr 10.0.0.1/24
ovs-vsctl add-port testbr gre0 -- set Interface gre0 type=gre options:local_ip=192.168.100.100 options:remote_ip=192.168.100.101
ovs-vsctl add-port testbr vxlan0 -- set Interface vxlan0 type=vxlan options:local_ip=192.168.100.100 options:remote_ip=192.168.100.102
oputput
 Bridge testbr
        Port "gre0"
            Interface "gre0"
                type: gre
                options: {local_ip="192.168.100.100", remote_ip="192.168.100.101"}
        Port testbr
            Interface testbr
                type: internal
        Port "vxlan0"
            Interface "vxlan0"
                type: vxlan
                options: {local_ip="192.168.100.100", remote_ip="192.168.100.102"}

```


#==OpenFlow manipulation==

dump flows
---
```bash
sudo ovs-ofctl dump-flows br-int
```

#==Others==

show logs
---
```bash
sudo  ovsdb-tool show-log 
```









