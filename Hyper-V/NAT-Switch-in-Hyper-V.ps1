#NAT Switch в Hyper-V
#Постановка: Създаване на NAT vSwitch с адресно пространство 192.168.99.0/24 и Gateway 192.168.99.1

#Стъпки:

    #Отваряте PowerShell сесия с Run as administrator
    #Създавате интърнал суич:
    New-VMSwitch -SwitchName "NAT vSwitch" -SwitchType Internal
    #Задавате адрес на новосъздадения виртуален интерфейс:
    New-NetIPAddress -IPAddress 192.168.99.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NAT vSwitch)"
    #Създавате NAT мрежа с адресно пространство, включващо адреса на виртуалния интерфейс:
    New-NetNAT -Name "NAT Network" -InternalIPInterfaceAddressPrefix 192.168.99.0/24
