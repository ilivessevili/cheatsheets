 #!/bin/sh
 OS_SRVS="nova|glance|neutron|keystone|cinder|ceilometer|heat|apache2"
 initctl list | grep -iE $OS_SRVS  | cut -d\  -f1 |  xargs -i service  {} stop
