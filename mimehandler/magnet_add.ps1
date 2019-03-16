[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True)]
   [string]$magnetlink
)

$configfile = Join-Path $env:USERPROFILE -ChildPath "mime_magnet_config.json"
$configuration = @{ "address"=""; "port"=-1; "username"=""; "password"="" }
$configmodified = $false

"To reset the configuration, delete '$configfile'"
Start-Sleep -Seconds 1

if (Test-Path $configfile)
{
    # the configuration file exists, read it
    $configuration = Get-Content $configfile -Raw | ConvertFrom-Json
}

if([string]::IsNullOrWhiteSpace($configuration.address))
{
    $inp = Read-Host -Prompt "Please enter the transmission server ip address or name (default: localhost)"
    if([string]::IsNullOrWhiteSpace($inp))
    {
        $inp = "localhost"
    }
    $configuration.address=$inp
    $configmodified = $true
}

if($configuration.port -lt 0)
{
    $inp = Read-Host -Prompt "Please enter the transmission server port number (default: 9091)"
    if([string]::IsNullOrWhiteSpace($inp))
    {
        $inp = "9091"
    }
    $configuration.port=[int]$inp
    $configmodified = $true
}

if([string]::IsNullOrWhiteSpace($configuration.username) -or [string]::IsNullOrWhiteSpace($configuration.password))
{
    $cred = Get-Credential -Message "Transmission username and password"
    if($cred -ne $null)
    {
        $configuration.username = $cred.UserName
        $configuration.password = $cred.Password | ConvertFrom-SecureString
        $configmodified = $true
    }
}

if($configmodified)
{
    $configuration | ConvertTo-Json -Depth 100 | Out-File $configfile -Force
}

$uri="http://$($configuration.address):$($configuration.port)/transmission/rpc"
$cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $configuration.username, ($configuration.password | ConvertTo-SecureString)

try
{
	Invoke-RestMethod -Uri $uri -Credential $cred -ErrorAction SilentlyContinue
}
catch
{
}

$response=$error[0].ErrorDetails.Message
$sessionid=$response | Select-String -pattern 'X-Transmission-Session-Id\: (?<sessid>[a-zA-Z0-9]*)' | Foreach {$_.Matches.Groups[1].Value } 

#create body using backticks to escape double quotes
$body = "{`"method`":`"torrent-add`",`"arguments`":{`"filename`":`"$magnetlink`"}}"

Invoke-RestMethod -Uri $uri -Headers @{"X-Transmission-Session-Id"=$sessionid} -Credential $cred -Method Post -Body $body
