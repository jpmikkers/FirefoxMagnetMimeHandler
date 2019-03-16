[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True)]
   [string]$link
)

"link is $link"

if($link -match "^magnet\:")
{
    & .\magnet_add.ps1 $link
}
