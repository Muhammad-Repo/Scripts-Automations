<#
.SYNOPSIS
    The Powershell script ensures the security event log size is configured to 1024000 KB or greater.

.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-10-09
    Last Modified   : 2025-10-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000505

.TESTED ON
    Date(s) Tested  : 2025-10-09
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
Run the script in PowerShell with administrative privileges.
Example:
PS C:> .\Remediation_WN10-AU-000505.ps1
#>

# Define registry keys and target value
$baseKey = "HKLM:\SOFTWARE\Policies\Microsoft"
$eventLogKey = "$baseKey\Windows\EventLog"
$securityKey = "$eventLogKey\Security"
$valueName = "MaxSize"
$minValue = 1024000

# Step 1: Ensure Windows key exists
if (-not (Test-Path "$baseKey\Windows")) {
    New-Item -Path $baseKey -Name "Windows" -Force | Out-Null
    Write-Output "Created key: Windows"
}

# Step 2: Ensure EventLog key exists
if (-not (Test-Path $eventLogKey)) {
    New-Item -Path "$baseKey\Windows" -Name "EventLog" -Force | Out-Null
    Write-Output "Created key: EventLog"
}

# Step 3: Ensure Security key exists
if (-not (Test-Path $securityKey)) {
    New-Item -Path $eventLogKey -Name "Security" -Force | Out-Null
    Write-Output "Created key: Security"
}

# Step 4: Check and set the MaxSize value
$currentValue = Get-ItemProperty -Path $securityKey -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    # Value does not exist, create it
    New-ItemProperty -Path $securityKey -Name $valueName -PropertyType DWord -Value $minValue -Force | Out-Null
    Write-Output "Created MaxSize and set to $minValue."
} elseif ($currentValue.$valueName -lt $minValue) {
    # Value exists but is too small, update it
    Set-ItemProperty -Path $securityKey -Name $valueName -Value $minValue
    Write-Output "Updated MaxSize to $minValue (was $($currentValue.$valueName))."
} else {
    Write-Output "Compliant: MaxSize is set to $($currentValue.$valueName), which is >= $minValue."
}

