<#
.SYNOPSIS
    This PowerShell script ensures the SMB client always requires digital signing of SMB packets.
.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-10-10
    Last Modified   : 2025-10-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000100

.TESTED ON
    Date(s) Tested  : 2025-10-10
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
Run the script in PowerShell with administrative privileges.
Example:
PS C:> .\Remediation_WN10-SO-000100.ps1
#>

# Define registry path and required setting
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$valueName = "RequireSecuritySignature"
$desiredValue = 1

# Create the key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Get current value
$currentValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $valueName -ErrorAction SilentlyContinue

# Set registry value if needed
if ($currentValue -ne $desiredValue) {
    Set-ItemProperty -Path $regPath -Name $valueName -Value $desiredValue -Type DWord
    Write-Output "'$valueName' was set to '$desiredValue'."
} else {
    Write-Output "'$valueName' is already set to '$desiredValue'. No change needed."
}

# Optional: Restart dependent services or reboot for immediate effect
# Restart-Service -Name "LanmanWorkstation" -Force

