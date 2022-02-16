New-VHD -Path C:\VM\WSAA-M1-VM-S2-D1.vhdx -SizeBytes 20gb -Dynamic
New-VHD -Path C:\VM\WSAA-M1-VM-S2-D2.vhdx -SizeBytes 20gb -Dynamic
#To attach them to WSAA-M1-VM-S2 (SERVER2), we can execute the following two commands, again on the Hyper-V host
Add-VMHardDiskDrive -VMName WSAA-M1-VM-S2 -Path C:\VM\WSAA-M1-VM-S2-D1.vhdx
Add-VMHardDiskDrive -VMName WSAA-M1-VM-S2 -Path C:\VM\WSAA-M1-VM-S2-D2.vhdx



