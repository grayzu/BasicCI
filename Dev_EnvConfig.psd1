@{
    AllNodes = @(
        @{
            NodeName = "*"
            SQLServerName    = "Localhost"
        },
        @{
            NodeName         = "local529"
            Role             = "MSSQL", "Web"
            WebDeployURI     = "https://petshopdata2.blob.core.windows.net/packages/WebDeploy_amd64_en-US.msi"
            SampleScriptURI  = "https://petshopdata2.blob.core.windows.net/packages/SampleData.sql"
            WebPackageURI    = "https://petshopdata2.blob.core.windows.net/packages/petshop.zip"
        }
    )
}
