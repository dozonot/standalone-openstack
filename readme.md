# what is this
This script is create standalone openstack for CentOS 7 minimal 1708

# how to use
1. Create centos vm ( or physical machine).
1. Install CentOS with install option minimal.
1. Configure network setting.
1. Configure variable in standalone.sh.  
  1. ```IPADDR=10.0.0.238```
This variable is the IP Address of the node.  
  1. ```NODENAME=packstack.localdomain```
This variable is the host name of the node.  
  1. ```CINDERDISK=/dev/sdb```
This variable is the Citnder disk name.
1. Add permission to standalone.sh
```chmod +x standalone.sh```
1. Run standalone.sh
