@{
    AllNodes = @(
        @{
            NodeName = "*"
            SQLServerName   = "DD-SQL"
        },
        @{
            NodeName        = "SQL"
            Role            = "MSSQL"
            SampleScriptURI = "https://github.com/PowerShell/FeatureSamples/tree/Prod/Demos/BasicCI/Packages/SampleData.sql"
        },
        @{
            NodeName        = "IIS"
            Role            = "Web"
            WebDeployURI    = "https://github.com/PowerShell/FeatureSamples/tree/master/Demos/BasicCI/Packages/WebDeploy_amd64_en-US.msi"
            WebPackageURI   = "https://github.com/PowerShell/FeatureSamples/tree/Prod/Demos/BasicCI/Packages/petshop.zip"
        }
    )
}
