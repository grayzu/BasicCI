#############################################################
# PowerShell Demo Days 2015 Demo
# 
# This script is used to setup VM environment for Demo
#
#############################################################

# a DevOps workflow

$cred = Import-Clixml -Path .\Admin.xml

#region ###Prep local machine###
    Write-Host "Starting configuration of Local Machine."
    New-NetIPAddress -IPAddress '10.0.0.1' -PrefixLength 24 -InterfaceAlias 'vEthernet (DemoNet)' -AddressFamily IPv4 -ErrorAction SilentlyContinue
    #"`r`n10.0.0.10`tcorp.fabricam.com" | Out-File -FilePath 'c:\windows\system32\drivers\etc\hosts' -Encoding ascii -Append
    #Add all required modules to local machine
    Install-Module -Name xWebAdministration
    Install-Module -Name xWebDeploy
    Install-Module -Name xSqlPs
    Install-Module -Name xNetworking
    Install-Module -Name xPSDesiredStateConfiguration
    Copy-Item $PSScriptRoot\Resources\ $env:ProgramFiles\WindowsPowerShell\Modules\ -Recurse -Force
    Write-Host "Completed: Local Machine setup"
#endregion 

#region ###Prep Dev target node###
    Write-Host "Starting configuration of Target node."
    #Copy required module
    #dir $env:ProgramFiles\WindowsPowerShell\Modules\x* -Recurse | %{Copy-VMFile -Name DemoDays -SourcePath $_.FullName -DestinationPath $_.FullName -CreateFullPath -FileSource Host -Force -Verbose}

    #Set IP Address
    Invoke-Command -VMName DemoDays -ScriptBlock {New-NetIPAddress -IPAddress '10.0.0.10' -PrefixLength 24 -InterfaceAlias 'Ethernet' -AddressFamily IPv4 -ErrorAction SilentlyContinue} -Credential $cred
    Write-Host "   Completed: set Host IP Address"

    #Disable firewall
    Invoke-Command -VMName DemoDays -ScriptBlock {Set-NetFirewallProfile -Name Public -Enabled False;Set-NetFirewallProfile -Name Domain -Enabled False;Set-NetFirewallProfile -Name Private -Enabled False} -Credential $cred
    Write-Host "   Completed: disabled firewall"

    #Add DNS name to host file
    Invoke-Command -VMName DemoDays -ScriptBlock {"`r`n10.0.0.10`tcorp.fabricam.com" | Out-File -FilePath 'c:\windows\system32\drivers\etc\hosts' -Encoding ascii -Append} -Credential $cred
    Write-Host "   Completed: set hosts file"

    #Add Demo user
    Invoke-Command -VMName DemoDays -ScriptBlock {$CN = [ADSI]"WinNT://$env:computername";$user = $CN.Create("User","Demo");$user.SetPassword("<PasswordHere>");$user.UserFlags = 64 + 65536;$user.SetInfo();$Admins = [ADSI]"WinNT://$env:computername/Administrators,group";$Admins.Add("WinNT://$env:computername/Demo,user");} -Credential $cred
    Write-Host "   Completed: created Demo user"
    Write-Host "Completed: Pull server setup"
#endregion 

#region ###Prep Target Node###
    Write-Host ""
    Write-Host "Starting configuration of Target Server."
    #Copy public SSL certificate
    dir $PSScriptRoot\fabricam_ssl.cer | Copy-VMFile -Name Server -DestinationPath 'c:\temp\fabricam_ssl.cer' -CreateFullPath -FileSource Host -Force
    Invoke-Command -VMName Server -ScriptBlock {Import-Certificate -FilePath 'c:\temp\fabricam_ssl.cer' -CertStoreLocation Cert:\LocalMachine\Root} -Credential $cred
    Write-Host "   Completed: copied and installed SSL Certificate"

    #Set IP Address
    Invoke-Command -VMName Server -ScriptBlock {New-NetIPAddress -IPAddress '10.0.0.11' -PrefixLength 24 -InterfaceAlias 'Ethernet' -AddressFamily IPv4} -Credential $cred
    Write-Host "   Completed: set Host IP Address"

    #Disable Firewall
    Invoke-Command -VMName Server -ScriptBlock {Set-NetFirewallProfile -Name Public -Enabled False;Set-NetFirewallProfile -Name Domain -Enabled False;Set-NetFirewallProfile -Name Private -Enabled False} -Credential $cred
    Write-Host "   Completed: disabled firewall"

    #Add DNS name to host file
    Invoke-Command -VMName Server -ScriptBlock {"`r`n10.0.0.10`tcorp.fabricam.com" | Out-File -FilePath 'c:\windows\system32\drivers\etc\hosts' -Encoding ascii -Append} -Credential $cred
    Write-Host "   Completed: set hosts file"

    #Add Demo users
    Invoke-Command -VMName Server -ScriptBlock {$CN = [ADSI]"WinNT://$env:computername";$user = $CN.Create("User","Demo");$user.SetPassword("<PasswordHere>");$user.UserFlags = 64 + 65536;$user.SetInfo();$Admins = [ADSI]"WinNT://$env:computername/Administrators,group";$Admins.Add("WinNT://$env:computername/Demo,user");} -Credential $cred
    Invoke-Command -VMName Server -ScriptBlock {$CN = [ADSI]"WinNT://$env:computername";$user = $CN.Create("User","Employees");$user.SetPassword("<PasswordHere>");$user.UserFlags = 64 + 65536;$user.SetInfo();} -Credential $cred
    Invoke-Command -VMName Server -ScriptBlock {$CN = [ADSI]"WinNT://$env:computername";$user = $CN.Create("User","Managers");$user.SetPassword("<PasswordHere>");$user.UserFlags = 64 + 65536;$user.SetInfo();} -Credential $cred
    #Invoke-Command -VMName Server -ScriptBlock {$CN = [ADSI]"WinNT://$env:computername";$user = $CN.Create("User","Finance");$user.SetPassword("<PasswordHere>");$user.UserFlags = 64 + 65536;$user.SetInfo();} -Credential $cred
    Write-Host "   Completed: created Demo user"
    Write-Host "Completed: Target server setup"
#endregion