#
# Lab Environment for WSAA 2022.01 - M3
#
# Notes:
#  1) Requires a sysprepped template
#  2) Requires NAT switch named "NAT vSwitch". Should you want/need, you can create one: https://zahariev.pro/files/hyper-v-nat-switch.html
# 

# General constants/variables
$SourceVHD = 'D:\WindowsTemplates\WIN-SRV-2K19-ST-DE.vhdx'
$TargetFolder = 'C:\VM\'

# Local credentials
$Password = ConvertTo-SecureString -AsPlainText "Password1" -Force
$LocalUser = "Administrator" 
$LC = New-Object System.Management.Automation.PSCredential($LocalUser, $Password)

# Domain credentials
$Domain = "WSAA.LAB"
$DomainUser = "$Domain\Administrator" 
$DC = New-Object System.Management.Automation.PSCredential($DomainUser, $Password)

# VM Names

$VM = 'WSAA-M3-VM-S4'


# Option 1: Clone VHDs (takes much space as we are making copies)

cp $SourceVHD ($TargetFolder + $VM + ".vhdx") 


# Option 2: Create Differential Disks (space efficient as we are making linked clones)

#New-VHD -Path ($TargetFolder + $VM + ".vhdx") -ParentPath $SourceVHD -Differencing


# Create VMs (with automatic checkpoints turned off and no dynamic memory)
New-VM -Name $VM -MemoryStartupBytes 3072mb -VHDPath ($TargetFolder + $VM + ".vhdx") -Generation 2 -SwitchName "NAT-Switch" | Set-VM -CheckpointType Production -AutomaticCheckpointsEnabled $false -PassThru | Set-VMMemory -DynamicMemoryEnabled $false

# Start VMs
Start-VM -Name $VM

# Ensure that the Administrator password is set to the same as in the beginning of the script
pause

# Change OS name
Invoke-Command -VMName $VM -Credential $LC -ScriptBlock { Rename-Computer -NewName SERVER4 -Restart  }
pause

# Set network settings
Invoke-Command -VMName $VM -Credential $LC -ScriptBlock { New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.199.104" -PrefixLength 24 -DefaultGateway 192.168.199.1 ; Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.199.2 }




# Join other machines to the domain
Invoke-Command -VMName $VM -Credential $LC -ScriptBlock { Add-Computer -DomainName $args[0] -Credential $args[1] -Restart } -ArgumentList $Domain, $DC
pause


# 
# Extra steps
# 
# Note that:
# - they (as the ones before) can be executed manually either using the script or not
# - can be further extended
#

# Prepare the one Hyper-V server (SERVER3)

# Stop machine as it must be in power off state
Stop-VM -Name $VM

# Prepare Hyper-V VM for nested virtualization
Set-VMMemory -VMName $VM -DynamicMemoryEnabled $false 
Set-VMProcessor -VMName $VM -ExposeVirtualizationExtensions $true
Get-VMNetworkAdapter -VMName $VM | Set-VMNetworkAdapter -MacAddressSpoofing On

# Start VM
Start-VM -Name $VM
