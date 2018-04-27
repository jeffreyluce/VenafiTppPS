# VenafiTppPS - PowerShell module for Venafi Trust Protection Platform

[![Build status](https://ci.appveyor.com/api/projects/status/vxyan36tsimle56b?svg=true)](https://ci.appveyor.com/project/GregBrownstein/venafitppps)

### Documentation can be found at [http://venafitppps.readthedocs.io](http://venafitppps.readthedocs.io)

### If there are any specific items you would like added, please update the [features issue](https://github.com/gdbarron/VenafiTppPS/issues/1)

## Usage
After loading the module, create a new session with
```
New-TppSession -ServerUrl "https://venafi.mycompany.com" -Credential <cred>
```
before calling any functions.  This will create a session which will be used by default in other functions.

