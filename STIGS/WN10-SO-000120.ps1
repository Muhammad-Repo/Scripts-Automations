<#
.SYNOPSIS
    This PowerShell script ensures the SMB server always requires digital signing of SMB packets.
.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-10-10
    Last Modified   : 2025-10-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000120

.TESTED ON
    Date(s) Tested  : 2025-10-10
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
Run the script in PowerShell with administrative privileges.
Example:
PS C:> .\Remediation_WN10-SO-000120.ps1
#>

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regName = "RequireSecuritySignature"
$desiredValue = 1

# Check if registry key exists, create if it doesn't
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Get current value
$currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regName -ErrorAction SilentlyContinue

# Set registry value if it doesn't match desired
if ($currentValue -ne $desiredValue) {
    Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue
    Write-Output "SMB server signing requirement enabled."
} else {
    Write-Output "SMB server signing requirement already configured correctly."
}

# Optional: Restart SMB service to apply change immediately
# Restart-Service -Name "LanmanServer" -Force
