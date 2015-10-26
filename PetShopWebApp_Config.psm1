Configuration PetShopWebApp
{
    Import-DSCResource -Module xWebAdministration
    Import-DSCResource -Module xWebDeploy
    Import-DSCResource -Module xSqlPs
    Import-DSCResource -Module xNetworking
    Import-DscResource -module xFileContent
    Import-DscResource -module xPSDesiredStateConfiguration

    #Configure SQL backend
    Node $Allnodes.Where{$_.Role -contains "MSSQL"}.Nodename
    {
        $CacheScriptContent = {$appcmd = "$env:SystemDrive\WINDOWS\Microsoft.NET\Framework\v2.0.50727\aspnet_regsql.exe"; `
                        & $appcmd -S .\ -U OaaS -P pass@word1 -A all -d MSPetShop4Services; `
                        & $appcmd -S .\ -U OaaS -P pass@word1 -d MSPetShop4 -ed; `
                        & $appcmd -S .\ -U OaaS -P pass@word1 -d MSPetShop4 -t Item -et; `
                        & $appcmd -S .\ -U OaaS -P pass@word1 -d MSPetShop4 -t Product -et; `
                        & $appcmd -S .\ -U OaaS -P pass@word1 -d MSPetShop4 -t Category -et; `
                        echo "Database Caching successfully enabled. Database=MSPetShop4" >> $env:ALLUSERSPROFILE\CacheScript.txt
                      }

        #Enable Remove Access to SQL Engine and SQL browser
	    xFireWall RemoteAccessOnSQLBrowser
        {

            Name = "SqlBrowser"
            Ensure = "Present"
            Access = "Allow"
            State ="Enabled"
            ApplicationPath = "c:\Program Files\Microsoft SQL Server\90\Shared\sqlbrowser.exe"
            Profile = "Any"
        }

        xFireWall RemoteAccessOnSQLEngine
        {
            Name = "SqlServer"
            Ensure = "Present"
            Access = "Allow"
            State ="Enabled"
            ApplicationPath = "c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\sqlservr.exe"
            Profile = "Any"
        }
	          
        # Provisioning databases with some pet information
        xRemoteFile PetshopSampleDataScript
        {
            Uri = $Node.SampleScriptURI
            DestinationPath = "c:\programdata\SampleData.sql"
        }

        xOSql PetShopSampleData
        {
            SQLServer = $Node.SQLServerName
            SqlUserName = (Import-Clixml .\SQLAdmin.xml).UserName
            SqlPassword = (Import-Clixml .\SQLAdmin.xml).GetNetworkCredential().password
            SQLFilePath = "c:\programdata\SampleData.sql"
        }

        #Enables sql database caching 
        Script PetShopSQLCacheDependency                       
        {
            SetScript = $CacheScriptContent
            GetScript = {@{}} #no easy way to get the sql database cache flag
            TestScript = {if(Test-path c:\programdata\CacheScript.txt){if((get-content c:\programdata\CacheScript.txt) -match "Username=OaaS, Password=pass@word1, Database=MSPetShop4"){return $true}else{return $false}}else{return $false}}
        }
   }

    #Configure IIS front end
    Node $Allnodes.Where{$_.Role -contains "Web"}.Nodename
    {
        # Install IIS and  Web Management Tools
        WindowsFeature WebServer
        {
            Name = "Web-server"
            Ensure = "Present"
         }

        WindowsFeature WebAppDev
        {
            Name = "Web-Asp-Net45"
            Ensure = "Present"
         }

        WindowsFeature IISManagementTools
        {
            Name = "Web-Mgmt-Tools"
            Ensure = "Present"
         }
        
        xWebsite Default
        {
            Ensure = "Present"
            Name = "Default Web Site"
            PhysicalPath = "%SystemDrive%\inetpub\wwwroot"
            State = "Started"
            BindingInfo = MSFT_xWebBindingInformation
                          {
                            Protocol = "HTTP"
                            Port = "8080"
                          }
        }

        File WebsiteDirectory
        {
            Ensure ="Present"
            Type = "Directory"
            DestinationPath = "c:\inetpub\MSPetShop"
        }

        # IIS server prep. Enabling site remote access
        xWebSite Petshop
        {
            Ensure = "Present"
            Name = "MSPetShop"
            PhysicalPath = "c:\inetpub\MSPetShop"
            State = "Started"
            BindingInfo = MSFT_xWebBindingInformation
                          {
                            Protocol = "HTTP"
                            Port = "80"
                          }
        }
        
        xFireWall EnableRemoteIISAccess
        {
            Name = "PetShop_IIS_Port"
            Ensure = "Present"
            Access = "Allow"
            State ="Enabled"
            Protocol = "TCP"
            Direction = "Inbound"
            LocalPort = "80"
            Profile = "Any"
        }

        #Deploys PetShop Web Server in IIS
        Package WebDeployTool
        {
            Ensure = "Present"
            Path  = $Node.WebDeployURI
            ProductId = "{1A81DA24-AF0B-4406-970E-54400D6EC118}"
            Name = "Microsoft Web Deploy 3.5"
            Arguments = "/quiet"
        }  
        
        xRemoteFile PetshopSource
        {
            Uri = $Node.WebPackageURI
            DestinationPath = "c:\data\petshop.zip"
        }

        xWebPackageDeploy WebPackage
        {
            Ensure = "Present"
            SourcePath = "c:\data\petshop.zip"
            Destination = "MSPetShop"
        }

        xFindAndReplace Web2Config
        {
            FilePath = "C:\inetpub\MSPetShop\web.config"
            Pattern = "server=.\\TestDSC;"
            ReplacementString = "server=$($Node.SQLServerName)\;"
        }
   }
}