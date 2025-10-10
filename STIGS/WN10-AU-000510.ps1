<#
.SYNOPSIS
    This PowerShell script ensures the System event log maximum size is configured to 32768 KB.

.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-10-01
    Last Modified   : 2025-10-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N//A
    STIG-ID         : WN10-AU-000510

.TESTED ON
    Date(s) Tested  : 2025-10-01
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
Run the script in PowerShell with administrative privileges.
Example:
PS C:> .\Remediation_WN10-AU-000510.ps1
#>

# Registry path for the policy setting
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
# Desired minimum size (in KB)
$minSizeKB = 32768

# Create the registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Output "Created registry path: $regPath"
}

# Check current value
$currentValue = Get-ItemProperty -Path $regPath -Name MaxSize -ErrorAction SilentlyContinue | Select-Object -ExpandProperty MaxSize -ErrorAction SilentlyContinue

# Set the value if not present or less than required
if ($null -eq $currentValue -or $currentValue -lt $minSizeKB) {
    Set-ItemProperty -Path $regPath -Name MaxSize -Value $minSizeKB -Type DWord
    Write-Output "MaxSize set to $minSizeKB KB in: $regPath"
} else {
    Write-Output "MaxSize already set to $currentValue KB, which meets or exceeds requirement."
}
