#NAT Switch в Hyper-V
#Create NAT vSwitch with network 192.168.99.0/24 and Gateway 192.168.99.1

#Steps:

    #Open PowerShell and Run as administrator
    #Create Internal Switch:
    New-VMSwitch -SwitchName "NAT vSwitch" -SwitchType Internal
    #Set IP at new virtual interface:
    New-NetIPAddress -IPAddress 192.168.99.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NAT vSwitch)"
    #Create NAT network:
    New-NetNAT -Name "NAT Network" -InternalIPInterfaceAddressPrefix 192.168.99.0/24
