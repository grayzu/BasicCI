Import-Module $PSScriptRoot\PetShopWebApp_Config.psm1

Describe "PetShopWebApp Configuration" {
      
    Context "Configuration Script"{
        
        It "Should be a DSC configuration script" {
            (Get-Command PetShopWebApp).CommandType | Should be "Configuration"
        }

        It "Should not be a DSC Meta-configuration" {
            (Get-Command PetShopWebApp).IsMetaConfiguration | Should Not be $true
        }
        
        It "Should require the source path parameter" {
            (Get-Command PetShopWebApp).Parameters["SourcePath"].Attributes.Mandatory | Should be $true
        }

        It "Should fail when an invalid source path is provided" {
            PetShopWebApp -SourcePath "This is not a path" | should Throw
        }

        It "Should include the following 3 parameters: 'SourcePath','WebsiteName','DestinationRootPath' " {
            (Get-Command PetShopWebApp).Parameters["SourcePath","WebsiteName","DestinationRootPath"].ToString() | Should not BeNullOrEmpty 
        }

        It "Should use the xWebsite DSC resource" {
            (Get-Command PetShopWebApp).Definition | Should Match "xWebsite"
        }
    }
}