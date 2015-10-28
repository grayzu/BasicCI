###########################################################################################
#  Development deployment of configuration to local VM
#     IIS and SQL installed on single VM
#
#  Configuration is pushed and applied to target vm over winrm
#
###########################################################################################

$outputFolder = "C:\DemoScripts\MOF\PetShop_Dev"
$Cred = Import-Clixml $PSScriptRoot\Admin.xml

# Import the PetShop WebApp Configuration
Import-Module $PSScriptRoot\PetShopWebApp_Config.psm1

PetShopWebApp -OutputPath $outputFolder -ConfigurationData $PSScriptRoot\Dev_EnvConfig.psd1

Start-DscConfiguration -Path $outputFolder -Credential $Cred -Wait -Verbose