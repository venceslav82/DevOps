# Prepare the two Hyper-V servers (SERVER1 and SERVER2)

# Stop machines as they must be in power off state
Stop-VM -Name $VM2, $VM3

# Prepare Hyper-V VMs for nested virtualization
Set-VMMemory -VMName $VM2, $VM3 -DynamicMemoryEnabled $false 
Set-VMProcessor -VMName $VM2, $VM3 -ExposeVirtualizationExtensions $true
Get-VMNetworkAdapter -VMName $VM2, $VM3 | Set-VMNetworkAdapter -MacAddressSpoofing On

# Start VMs
Start-VM -Name $VM2, $VM3

pause

# Install Hyper-V role on both Hyper-V VMs (machines must be in power on state)
Invoke-Command -VMName $VM2, $VM3 -Credential $DC -ScriptBlock { Install-WindowsFeature Hyper-V -IncludeManagementTools -Restart }