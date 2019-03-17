# powershell bugfix, make sure arrays are emitted correctly as json arrays
Remove-TypeData System.Array -ErrorAction Ignore

# https://4sysops.com/archives/convert-json-to-a-powershell-hash-table/
function ConvertTo-Hashtable {
    [CmdletBinding()]
    [OutputType('hashtable')]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
 
    process {
        ## Return null if the input is null. This can happen when calling the function
        ## recursively and a property is null
        if ($null -eq $InputObject) {
            return $null
        }
 
        ## Check if the input is an array or collection. If so, we also need to convert
        ## those types into hash tables as well. This function will convert all child
        ## objects into hash tables (if applicable)
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) {
                    ConvertTo-Hashtable -InputObject $object
                }
            )
 
            ## Return the array but don't enumerate it because the object may be pretty complex
            Write-Output -NoEnumerate $collection
        } elseif ($InputObject -is [psobject]) { ## If the object has properties that need enumeration
            ## Convert it to its own hash table and return it
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
            }
            $hash
        } else {
            ## If the object isn't an array, collection, or other object, it's already a hash table
            ## So just return it.
            $InputObject
        }
    }
}

$mimehandlername="mimehandler.bat"
$mimehandlerpath=(Get-ChildItem $mimehandlername).FullName
$profiles=Join-Path $env:APPDATA "Mozilla\Firefox\Profiles"
$profile=Get-ChildItem $profiles -Directory | Select-Object -First 1

if($profile -eq $null)
{
    "Could not find firefox configuration directory, exiting."
    return
}

$configfile = Join-Path $profile.FullName "handlers.json"

if(!(Test-Path $configfile -PathType Leaf))
{
    "Could not find firefox handlers file, exiting."
    return    
}

"Firefox handlers file located at '$configfile'"
$configurationModified = $false
$configuration = Get-Content $configfile -Raw | ConvertFrom-Json | ConvertTo-HashTable

if($configuration.ContainsKey('schemes'))
{
    if($configuration.schemes.ContainsKey('magnet') -and $configuration.schemes.magnet.ContainsKey('handlers'))
    {
        "Magnet scheme available, checking.."

        $installed = $false

        foreach($v in $configuration.schemes.magnet.handlers)
        {
            if($v.name -eq $mimehandlername)
            {
                $installed = $true
            }
        }

        if($installed)
        {
            "Already installed"
            if((Read-Host -Prompt "uninstall magnet handler? [y/N]") -match "[yY]")
            {
                $configuration.schemes.Remove('magnet')
                $configurationModified=$true
            }
        }
        else
        {
            "We're not one of the handlers yet.."
            if(!((Read-Host -Prompt "install magnet handler? [Y/n]") -match "[nN]"))
            {
                $configuration.schemes.magnet.handlers.Add( @{ "name"=$mimehandlername; "path"=$mimehandlerpath } )
                $configurationModified=$true
            }
        }
    }
    else
    {
        "No magnet handler yet, adding..."
        if(!((Read-Host -Prompt "install magnet handler? [Y/n]") -match "[nN]"))
        {
            $configuration.schemes['magnet']=@{ "handlers"=@( @{ "name"=$mimehandlername; "path"=$mimehandlerpath } ); "action"=2 }
            $configurationModified=$true
        }
    }
}

if($configurationModified)
{
    $configuration | ConvertTo-Json -Compress -Depth 100 | Out-File -Encoding utf8 $configfile -Force
}

"Press enter to close.."
Read-Host
