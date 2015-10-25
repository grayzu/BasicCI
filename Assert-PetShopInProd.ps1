###########################################################################################
#  Production deployment of configuration to two servers 
#     DD-Web: IIS server which hosts Web App front end
#     DD-SQL: SQL server which hosts SQL backend
#
#  Two servers are already connected to Azure Automation so all that needs to be done is
#  import the new configuration into Azure Automation then target nodes will pull during
#  next DSC refresh
###########################################################################################

$outputFolder = "C:\DemoScripts\MOF\PetShop_Prod"
$Cred = Import-Clixml $PSScriptRoot\Admin.xml

# Import the PetShop WebApp Configuration
Import-Module $PSScriptRoot\PetShopWebApp_Config.psm1

# Generate IL files
PetShopWebApp -OutputPath $outputFolder -ConfigurationData $PSScriptRoot\Prod_EnvConfig.psd1

###################################################
#### Configure Azure VMs with Azure Automation ####
#### Login to AzureRM before calling script    ####
###################################################

Get-AzureRMSubscription -SubscriptionName "CI Automation Demo" | Select-AzureRMSubscription

#### Import Node Configurations
Import-AzureRmAutomationDscNodeConfiguration -Path "$outputFolder\SQL.mof" -ConfigurationName "PetShopWebApp" -ResourceGroupName 'petshopdemo' -AutomationAccountName 'petshop' 
Import-AzureRmAutomationDscNodeConfiguration -Path "$outputFolder\IIS.mof" -ConfigurationName "PetShopWebApp" -ResourceGroupName 'petshopdemo' -AutomationAccountName 'petshop' 