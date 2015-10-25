@{
    AllNodes = @(
        @{
            NodeName = "*"
            SQLServerName    = "Localhost"
        },
        @{
            NodeName         = "local529"
            Role             = "MSSQL", "Web"
            WebDeployURI     = "https://github.com/PowerShell/FeatureSamples/tree/master/Demos/BasicCI/Packages/WebDeploy_amd64_en-US.msi"
            SampleScriptURI  = "https://github.com/PowerShell/FeatureSamples/tree/Dev/Demos/BasicCI/Packages/SampleData.sql"
            WebPackageURI    = "https://github.com/PowerShell/FeatureSamples/tree/Dev/Demos/BasicCI/Packages/petshop.zip"
        }
    )
}
