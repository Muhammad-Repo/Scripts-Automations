<#
.SYNOPSIS
    TThis PowerShell script ensures that the 'MinimumPIN' registry key is set to 6 or greater.

.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-10-01
    Last Modified   : 2025-10-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000032

.TESTED ON
    Date(s) Tested  : 2025-10-01
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
Run the script in PowerShell with administrative privileges.
Example:
PS C:> .\Remediation_WN10-00-000032.ps1
#>

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$valueName = "MinimumPIN"
$desiredValue = 6

# Check if the registry key exists
if (-not (Test-Path $regPath)) {
    # Create the registry path if it doesn't exist
    New-Item -Path $regPath -Force | Out-Null
}

# Check if the registry value exists and is configured correctly
$currentValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue

# If the value is missing or incorrect, set it to the desired value
if ($currentValue.$valueName -ne $desiredValue) {
    Set-ItemProperty -Path $regPath -Name $valueName -Value $desiredValue -Type DWord
    Write-Host "The registry value '$valueName' has been set to $desiredValue."
} else {
    Write-Host "The registry value '$valueName' is already configured correctly."
}
