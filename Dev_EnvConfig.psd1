@{
    AllNodes = @(
        @{
            NodeName = "*"
            SQLServerName    = "Localhost" 
        },
        @{
            NodeName         = "local529"
            Role             = "MSSQL", "Web"
            WebDeployURI     = "https://github.com/grayzu/BasicCI/tree/Dev/Packages/WebDeploy_amd64_en-US.msi"
            SampleScriptURI  = "https://github.com/grayzu/BasicCI/tree/Dev/Packages/SampleData.sql"
            WebPackageURI    = "https://github.com/grayzu/BasicCI/tree/Dev/Packages/petshop.zip"
        }
    )
}
