Invoke-ScriptAnalyzer .\PetShopWebApp_Config.psm1
Invoke-ScriptAnalyzer .\PetShopWebApp_Config.psm1 -ExcludeRule PSAvoidUsingInternalURLs,PSAvoidUsingPositionalParameters

Invoke-Pester .\PetShopWebApp_Config.Tests.ps1