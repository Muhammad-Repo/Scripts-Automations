<#
.SYNOPSIS
    This PowerShell script configures the registry to prevent elevated installs for non-admin users.

.NOTES
    Author          : Muhammad Saidmurodov
    LinkedIn        : linkedin.com/in/mukhammad-saidmurodov/
    GitHub          : github.com/muhammad-repo
    Date Created    : 2025-09-29
    Last Modified   : 2025-09-29
    Version         : 1.0
    CVEs            : N//A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000315

.TESTED ON
    Date(s) Tested  : 2025-09-29
    Tested By       : Muhammad Saidmurodov
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1

.USAGE
Run the script in PowerShell with administrative privileges.
Example:
PS C:> .\Remediation_WN10-CC-000315.ps1
#>


# Define registry paths to check (both HKLM and HKCU)
$RegPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer",
    "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"
)

$RegName = "AlwaysInstallElevated"
$ExpectedValue = 0

foreach ($RegPath in $RegPaths) {
    Write-Host "Checking $RegPath..."

    # Ensure registry path exists
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
        Write-Host "Created registry path: $RegPath"
    }

    # Check and set the value
    try {
        $CurrentValue = (Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue).$RegName

        if ($null -eq $CurrentValue) {
            Write-Host "Value not found. Creating and setting..."
            New-ItemProperty -Path $RegPath -Name $RegName -PropertyType DWord -Value $ExpectedValue -Force | Out-Null
        }
        elseif ($CurrentValue -ne $ExpectedValue) {
            Write-Host "Non-compliant (current: $CurrentValue). Fixing..."
            Set-ItemProperty -Path $RegPath -Name $RegName -Value $ExpectedValue
        }
        else {
            Write-Host "Compliant. Value already set to $ExpectedValue."
        }

        # Confirm result
        $CheckValue = (Get-ItemProperty -Path $RegPath -Name $RegName).$RegName
        Write-Host "Final value at ${RegPath}\${RegName} = $CheckValue"
    }
    catch {
        Write-Host "Error checking ${RegPath}: $_"
    }

    Write-Host "-----------------------------------"
}
