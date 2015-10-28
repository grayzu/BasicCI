#############################################################################
# Script to return server to baseline for Demo
#############################################################################

#Remove Petshop website directory
del C:\inetpub\MSPetShop -Recurse -Force -Verbose

#Remove MSPetshop website
Remove-Website 'MSPetShop' -Verbose

#Remove petshop source code
del c:\data\petshop.zip -Verbose

#Set default website back to port 80
Set-WebBinding -Name 'Default Web Site' -BindingInformation '*:8080:' -PropertyName Port -Value 80 -Verbose