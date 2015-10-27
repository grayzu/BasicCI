Import-Module $PSScriptRoot\PetShopWebApp_Config.psm1

Describe "PetShopWebApp Configuration" {
      
    Context "Configuration Script"{
        
        It "Should be a DSC configuration script" {
            (Get-Command PetShopWebApp).CommandType | Should be "Configuration"
        }

        It "Should not be a DSC Meta-configuration" {
            (Get-Command PetShopWebApp).IsMetaConfiguration | Should Not be $true
        }

        It "Should fail when a positional parameter is used" {
            PetShopWebApp "foo" | should Throw
        }

        It "Should use the xWebsite DSC resource" {
            (Get-Command PetShopWebApp).Definition | Should Match "xWebsite"
        }
    }
}