# Dynamically find the text file in the script's own folder
$filePath = Join-Path -Path $PSScriptRoot -ChildPath "targets.txt"

# Reads the file. Powershell automatically treats each line as an item in an array
$ips = Get-Content -Path $filePath

# Core loop logic using Test-Connection which is Powershell's native ping tool.
foreach ($ip in $ips) {
    # Initialize $alive variable as false by default
    $alive = $false

    # -Count 1 sends one packet
    # -Quiet returns True or False -WarningAction SilentlyContinue hides IPv6 warnings if encountered
    # -ErrorAction Stop skips to the catch statement if Windows encounters a generic failure error
    try {
        $alive = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction Stop -WarningAction SilentlyContinue
    }
    catch {
        # If an error happens, $alive variable stays false and keeps the script running smoothly
        $alive = $false
    }

    if ($alive) {
        Write-Host "[+] $ip is ONLINE" -ForegroundColor Green
    } else {
        Write-Host "[-] $ip is OFFLINE" -ForegroundColor Red
    }
}