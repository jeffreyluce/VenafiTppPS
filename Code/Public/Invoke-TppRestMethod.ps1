function Invoke-TppRestMethod {
    <#
	.SYNOPSIS 
	Generic REST call for Venafi
	
	.DESCRIPTION
	
	.PARAMETER VenafiSession

	.PARAMETER Method

	.PARAMETER UriLeaf

	.PARAMETER Header

	.PARAMETER Body

	.INPUTS

	.OUTPUTS

	.EXAMPLE

	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Session')]
        [ValidateNotNullOrEmpty()]
        [alias("sess")]
        $VenafiSession,

        [Parameter(Mandatory, ParameterSetName = 'URL')]
        [ValidateNotNullOrEmpty()]
        [String] $ServerUrl,

        [Parameter(Mandatory)]
        [ValidateSet("Get", "Post", "Patch", "Put", "Delete")] 
        [String] $Method,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $UriLeaf,

        [Parameter()]
        [String] $Header,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Hashtable] $Body
    )

    Switch ($PsCmdlet.ParameterSetName)	{
        "Session" {
            $ServerUrl = $VenafiSession.ServerUrl
            $hdr = @{ "X-Venafi-Api-Key" = $VenafiSession.ApiKey }
        }
    }

    $uri = Join-UriPath @($ServerUrl, "vedsdk", $UriLeaf)

    Write-Verbose ("URI: {0}" -f $uri)
		
    if ( $Header ) {
        $hdr += $Header
        Write-Verbose ("Adding to header {0}" -f $Header | out-string)
    }
		
    if ( $Body ) {
        $restBody = $Body
        if ( $Method -ne 'Get' ) {
            $restBody = ConvertTo-Json $Body -depth 5 
        }
    }
    Write-Verbose ("Body: {0}" -f $restBody | Out-String)

    $params = @{
        Method      = $Method
        Uri         = $uri
        Headers     = $hdr
        Body        = $restBody
        ContentType = 'application/json'
    }

    Write-Verbose ($params | out-string)
    Invoke-RestMethod @params
}
