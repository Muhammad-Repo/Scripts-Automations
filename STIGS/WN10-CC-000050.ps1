<#
.SYNOPSIS
    This PowerShell script ensures standard users are automatically denied elevation requests via UAC.
.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-10-14
    Last Modified   : 2025-10-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000050

.TESTED ON
    Date(s) Tested  : 2025-10-14
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
Run the script in PowerShell with administrative privileges.
Example:
PS C:> .\Remediation_WN10-CC-000050.ps1
#>

# Define registry path
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths"
$desiredValue = "RequireMutualAuthentication=1, RequireIntegrity=1"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set required values
Set-ItemProperty -Path $regPath -Name "\\*\NETLOGON" -Value $desiredValue -Type String
Set-ItemProperty -Path $regPath -Name "\\*\SYSVOL"   -Value $desiredValue -Type String

# Output success message
Write-Host "Hardened path values for '\\*\NETLOGON' and '\\*\SYSVOL' have been successfully set as required."
