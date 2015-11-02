#############################################################################
# Script to return server to baseline for Demo
#############################################################################

#Remove all PetShop Databases
SQLPS
dir SQLSERVER:\SQl\dd-sql\default\databases | where name -Like 'MSPetShop*' | Remove-Item -Force -Verbose

#Remove all PetShop DB accounts
cd SQLSERVER:\SQl\dd-sql\default\logins 
Remove-Item 'mspetshop' -Force -Verbose

#Remove SQL firewall port opening
Remove-NetFirewallRule -DisplayName "SqlServer"

#Remove all cache files
Remove-Item 'C:\ProgramData\CacheScript.txt' -Force -Verbose
Remove-Item 'C:\ProgramData\*.sql' -Force -Verbose
Remove-Item 'C:\Program Files\Microsoft SQL Server\SqlFiles' -Recurse -Force -Verbose