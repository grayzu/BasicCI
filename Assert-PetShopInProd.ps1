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

# Import the PetShop WebApp Configuration
Import-Module $PSScriptRoot\PetShopWebApp_Config.psm1

# Generate IL files
PetShopWebApp -OutputPath $outputFolder -ConfigurationData $PSScriptRoot\Prod_EnvConfig.psd1

# select subscription
Get-AzureRMSubscription -SubscriptionName "CI Automation Demo" | Select-AzureRMSubscription

# Deploy configurations to Azure Automation: Import Node Configurations
Import-AzureRmAutomationDscNodeConfiguration -Path "$outputFolder\SQL.mof" -ConfigurationName "PetShopWebApp" -ResourceGroupName 'petshopdemo' -AutomationAccountName 'petshop' -Force
Import-AzureRmAutomationDscNodeConfiguration -Path "$outputFolder\IIS.mof" -ConfigurationName "PetShopWebApp" -ResourceGroupName 'petshopdemo' -AutomationAccountName 'petshop' -Force