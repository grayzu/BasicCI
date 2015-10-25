#
#  DSC resource for managing SQL server using osql.exe tool. Allows to run any Sql command/query on database
#

$SqlFileLocation = Join-Path "$env:ProgramFiles\Microsoft SQL Server" "SqlFiles"
#
# The Get-TargetResource cmdlet.
#
function Get-TargetResource
{
    param
    (		 
        [parameter(Mandatory)]         
        [ValidateNotNullOrEmpty()]
        [string] $SQLServer,

        [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [String] $SqlUserName,
        #[Hashtable] $SqlAdministratorCredential,

        [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [String] $SqlPassword,

	    [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [string] $SQLFilePath,

        [string] $Arguments,

        [boolean] $IsApplied
    )

   $IsApplied = $false

   $FileName = Get-Item -Path $SQLFilePath
   $FileName = $FileName.Name
   $FullPath = Join-Path $SqlFileLocation $FileName
   
   if ((Test-Path -Path $SqlFileLocation) -eq $False)
   {
    	 New-Item -Path $SqlFileLocation -ItemType Directory
   }

   if ((Test-Path -Path $FullPath))
   {
    	 $IsApplied = $true
   }
   return @{
       
        SQLServer = $SQLServer        
        SQLFilePath = $SQLFilePath
     	 IsApplied = $IsApplied
    }
}

#
# The Set-TargetResource cmdlet.
#
function Set-TargetResource
{
    param
    (	
        [parameter(Mandatory)]         
        [ValidateNotNullOrEmpty()]
        [string] $SQLServer,

        [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [String] $SqlUserName,
        #[Hashtable] $SqlAdministratorCredential,

        [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [String] $SqlPassword,

	    [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [string] $SQLFilePath,

        [string] $Arguments,

        [boolean] $IsApplied
               
    )   

    if((Test-TargetResource @psboundparameters))
    {
        return
    }
    $saPwd = $SqlPassword #$SqlAdministratorCredential.GetNetworkCredential().Password
    $saUser = $SqlUserName #$SqlAdministratorCredential.GetNetworkCredential().UserName

    
    
    #$osql = dir -Path "$env:ProgramFiles\Microsoft SQL Server" -Filter osql.exe -Recurse #Join-Path "$env:ProgramFiles\Microsoft SQL Server\110\Tools\Binn" "osql.exe"
    $osqlcmd = "& 'OSql.exe' "
    $osqlcmd +=" -S $SQLServer"
    $osqlcmd +=" -U $saUser"
    $osqlcmd +=" -P $saPwd"
    
    $osqlcmd +=" -i $SQLFilePath"
    
    if($Arguments -ne $null)
    {
        $osqlcmd += " $Arguments"
        Write-Verbose -Message "Calling OSQL.exe with $osqlcmd arguments."
    }
   
    Write-Verbose -Message "SQL file path is $SQLFilePath"
    Write-Verbose -Message "SQL user is $saUser"    

    try
    {
        Invoke-Expression $osqlcmd
        Copy-Item -Path $SQLFilePath -Destination $SqlFileLocation -Force
    }
    catch {  
        Write-Verbose -Message "Set osql operation  on SQL server $SQLServer reached exception."
        throw $_
    }
}

#
# The Test-TargetResource cmdlet.
#
function Test-TargetResource
{
    param
    (	
        [parameter(Mandatory)]         
        [ValidateNotNullOrEmpty()]
        [string] $SQLServer,

        [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [String] $SqlUserName,
        #[Hashtable] $SqlAdministratorCredential,

        [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [String] $SqlPassword,

	    [parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()]
        [string] $SQLFilePath,

        [string] $Arguments,

        [boolean] $IsApplied
        
    )

    $status = Get-TargetResource @psboundparameters
    
    if($status.IsApplied -eq $true)
    {
        return $true
    }
    else
    {
        return $false
    }
}
