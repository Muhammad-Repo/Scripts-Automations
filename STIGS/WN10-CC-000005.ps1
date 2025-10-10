
<#
.SYNOPSIS
    This Powershell script ensures that camera access is disabled from the lock screen.
.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-10-10
    Last Modified   : 2025-10-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005

.TESTED ON
    Date(s) Tested  : 2025-10-09
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
Run the script in PowerShell with administrative privileges.
Example:
PS C:> .\Remediation_WN10-CC-000005.ps1
#>

# Define registry keys and target value
$baseKey = "HKLM:\SOFTWARE\Policies\Microsoft"
$personalizationKey = "$baseKey\Windows\Personalization"
$valueName = "NoLockScreenCamera"
$expectedValue = 1

# Ensure registry path exists
if (-not (Test-Path $personalizationKey)) {
    New-Item -Path "$baseKey\Windows" -Name "Personalization" -Force | Out-Null
    Write-Output "Created key: Personalization"
}

# Check current value
try {
    $currentValue = Get-ItemProperty -Path $personalizationKey -Name $valueName -ErrorAction Stop
    if ($currentValue.$valueName -ne $expectedValue) {
        Set-ItemProperty -Path $personalizationKey -Name $valueName -Value $expectedValue -Type DWord
        Write-Output "Updated NoLockScreenCamera to $expectedValue (was $($currentValue.$valueName))."
    } else {
        Write-Output "Compliant: NoLockScreenCamera is set to $($currentValue.$valueName)."
    }
} catch {
    # Value doesn't exist, create it
    New-ItemProperty -Path $personalizationKey -Name $valueName -PropertyType DWord -Value $expectedValue -Force | Out-Null
    Write-Output "Created NoLockScreenCamera and set to $expectedValue."
}
