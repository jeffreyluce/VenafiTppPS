<#
.SYNOPSIS
Get attributes for a given object

.DESCRIPTION
Retrieves object attributes.  You can either retrieve all attributes or individual ones.
By default, the attributes returned are not the effective policy, but that can be requested with the
EffectivePolicy switch.

.PARAMETER DN
Path to the object to retrieve configuration attributes.  Just providing DN will return all attributes.

.PARAMETER AttributeName
Only retrieve the value/values for this attribute

.PARAMETER EffectivePolicy
Get the effective policy of the attribute

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
DN by property name

.OUTPUTS
PSCustomObject with properties DN and Config.
    DN, path provided to the function
    Attribute, PSCustomObject with the following properties:
        Name
        Values
        IsCustomField

.EXAMPLE
Get-TppAttribute -DN '\VED\Policy\My Folder\myapp.company.com'
Retrieve all configurations for a certificate

.EXAMPLE
Get-TppAttribute -DN '\VED\Policy\My Folder\myapp.company.com' -EffectivePolicy
Retrieve all effective configurations for a certificate

.EXAMPLE
Get-TppAttribute -DN '\VED\Policy\My Folder\myapp.company.com' -AttributeName 'driver name'
Retrieve all the value for attribute driver name from certificate myapp.company.com

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppAttribute/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppAttribute.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-read.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____26

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-readall.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____27

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-readeffectivepolicy.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____30

#>
function Get-TppAttribute {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NonEffectivePolicy', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String[]] $DN,

        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy')]
        [Parameter(ParameterSetName = 'NonEffectivePolicy')]
        [ValidateNotNullOrEmpty()]
        [String[]] $AttributeName,

        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy')]
        [Switch] $EffectivePolicy,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        if ( $AttributeName ) {
            if ( $EffectivePolicy ) {
                $uriLeaf = 'config/ReadEffectivePolicy'
            } else {
                $uriLeaf = 'config/read'
            }
        } else {
            $uriLeaf = 'config/readall'
        }

        $baseParams = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = $uriLeaf
            Body       = @{
                ObjectDN = ''
            }
        }
    }

    process {

        foreach ( $thisDN in $DN ) {

            $baseParams.Body['ObjectDN'] = $thisDN

            # if specifying attribute name(s), it's a different rest api
            if ( $AttributeName ) {

                $configValues = @()

                # TODO: convert to ArrayList
                # $configValues = [System.Collections.ArrayList] @()

                # get the attribute values one by one as there is no
                # api which allows passing a list
                foreach ( $thisAttribute in $AttributeName ) {

                    $params = $baseParams.Clone()
                    $params.Body += @{
                        AttributeName = $thisAttribute
                    }

                    $response = Invoke-TppRestMethod @params

                    if ( $response ) {
                        $configValues += [PSCustomObject] @{
                            Name  = $thisAttribute
                            Value = $response.Values
                        }
                        # $null = $configValues.Add(
                        #     [PSCustomObject] @{
                        #         Name  = $thisAttribute
                        #         Value = $response.Values
                        #     }
                        # )
                        # $null = $configValues.Add($response.Values)
                    }
                } # attribute
            } else {
                $response = Invoke-TppRestMethod @baseParams
                if ( $response ) {
                    $configValues = $response.NameValues
                }
            } # DN

            if ( $configValues ) {

                # convert custom field guids to names
                $updatedConfigValues = $configValues.ForEach{

                    $thisConfigValue = $_
                    $thisConfigValue | Add-Member @{
                        IsCustomField = $false
                    }

                    $customField = $TppSession.CustomField | Where-Object {$_.Guid -eq $thisConfigValue.Name}
                    if ( $customField ) {
                        $thisConfigValue.Name = $customField.Label
                        $thisConfigValue.IsCustomField = $true
                    }

                    $thisConfigValue
                }

                [PSCustomObject] @{
                    DN     = $thisDN
                    Config = $updatedConfigValues
                }
            }
        }
    }
}