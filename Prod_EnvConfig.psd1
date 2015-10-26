@{
    AllNodes = @(
        @{
            NodeName = "*"
            SQLServerName   = "DD-SQL"
        },
        @{
            NodeName        = "SQL"
            Role            = "MSSQL"
            SampleScriptURI = "https://github.com/grayzu/BasicCI/raw/Prod/Packages/SampleData.sql"
        },
        @{
            NodeName        = "IIS"
            Role            = "Web"
            WebDeployURI    = "https://github.com/grayzu/BasicCI/raw/Prod/Packages/WebDeploy_amd64_en-US.msi"
            WebPackageURI   = "https://github.com/grayzu/BasicCI/raw/Prod/Packages/petshop.zip"
        }
    )
}
