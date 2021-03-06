# Move-TppObject

## SYNOPSIS
Move an object of any type

## SYNTAX

```
Move-TppObject [-SourceDN] <String> [-TargetDN] <String> [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Move an object of any type

## EXAMPLES

### EXAMPLE 1
```
Move-TppObject -SourceDN '\VED\Policy\My Folder\mycert.company.com' -TargetDN '\VED\Policy\New Folder\mycert.company.com'
```

Moves mycert.company.com to a new Policy folder

## PARAMETERS

### -SourceDN
Full path to an object in TPP

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetDN
New path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TppSession
Session object created from New-TppSession method. 
The value defaults to the script session object $TppSession.

```yaml
Type: TppSession
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### none
## OUTPUTS

## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Move-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/Move-TppObject/)

[http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObject/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Move-TppObject.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Move-TppObject.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-renameobject.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____36](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-renameobject.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____36)

