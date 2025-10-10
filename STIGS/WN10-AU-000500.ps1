<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-06-22
    Last Modified   : 2025-06-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 2025-06-22
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
    Put any usage instructions here.
    Example syntax:
    PPS C:> .\Remediation_WN10-AU-000500.ps1 
#>

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$valueName = "MaxSize"
$desiredValue = 0x8000  # This is 32768 in decimal

# Create the registry key if it does not exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
New-ItemProperty -Path $regPath -Name $valueName -Value $desiredValue -PropertyType DWord -Force | Out-Null

# Confirm the value was set
$actualValue = Get-ItemPropertyValue -Path $regPath -Name $valueName
Write-Output "MaxSize is now set to $actualValue KB"
