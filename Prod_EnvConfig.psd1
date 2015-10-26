@{
    AllNodes = @(
        @{
            NodeName = "*"
            SQLServerName   = "DD-SQL"
        },
        @{
            NodeName        = "SQL"
            Role            = "MSSQL"
            SampleScriptURI = "https://petshopdata2.blob.core.windows.net/packages/SampleData.sql"
        },
        @{
            NodeName        = "IIS"
            Role            = "Web"
            WebDeployURI    = "https://petshopdata2.blob.core.windows.net/packages/WebDeploy_amd64_en-US.msi"
            WebPackageURI   = "https://petshopdata2.blob.core.windows.net/packages/petshop.zip"
        }
    )
}
