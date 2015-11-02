$sqlCon = New-CimSession -ComputerName dd-sql.westus.cloudapp.azure.com -Credential $cred
$webCon = New-CimSession -ComputerName dd-web.westus.cloudapp.azure.com -Credential $cred

# Force udate of configurations on prod machines
Update-DscConfiguration -CimSession $sqlCon -Wait -Verbose
Update-DscConfiguration -CimSession $webCon -Wait -Verbose