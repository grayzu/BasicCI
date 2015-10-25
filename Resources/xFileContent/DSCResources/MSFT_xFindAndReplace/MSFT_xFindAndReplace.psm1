<#######################################################################################
 #  MSFT_xFindAndReplace : DSC Resource that will set/test/get the content of a file 
 #  by replacing any instances of a pattern with the specified string.
 #######################################################################################>
 


######################################################################################
# The Get-TargetResource cmdlet.
# This function will get the list of string instances that match the given pattern in the file.
######################################################################################
function Get-TargetResource
{
	param
	(		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String]$FilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [String]$Pattern,

		[Parameter()]
        [String]$ReplacementString = "",

        [Parameter()]
        [String[]] $MatchingString
	)
	
    $MatchingString = Select-String -Path $FilePath -Pattern $Pattern

    $returnValue = @{
        FilePath = $FilePath
        Pattern = $Pattern
        ReplacementString = $ReplacementString
        MatchingString = $MatchingString
	}

	$returnValue
}

######################################################################################
# The Set-TargetResource cmdlet.
# This function will replace instances of thea string pattern with another string in the file.
######################################################################################
function Set-TargetResource
{
	param
	(	
        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String]$FilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [String]$Pattern,

		[Parameter()]
        [String]$ReplacementString = ""
	)
    
    if((($Content = get-content $FilePath) -match $Pattern).count -gt 0)
    {
        $i = 0
        $Content | ForEach-Object {$_ -replace $Pattern, $ReplacementString; if($_ -match $Pattern){$i += 1}} | set-content $FilePath
        Write-Verbose "Replaced $i instances of '$Pattern' in file $FilePath with '$ReplacementString'."
    }
    else
    {
        Write-Verbose "No instances of '$Pattern' were found in file $FilePath."
    }
    
}

######################################################################################
# The Test-TargetResource cmdlet.
# This will test if the string pattern exists in the given file.
######################################################################################
function Test-TargetResource
{
	param
	(
        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String]$FilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [String]$Pattern,

		[Parameter()]
        [String]$ReplacementString = ""
	)

    if(((get-content $FilePath) -match $Pattern).count -gt 0)
    {
        return $false # Not in the desired state
    }
    else
    {
        return $true # In the desired state
    }

}

#  FUNCTIONS TO BE EXPORTED 
Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource