param(
    [ValidateSet('debug', 'release')]
    [string]$Mode = 'release',

    [string]$DeviceId = '',

    [switch]$Install,
    [switch]$Launch,
    [switch]$SkipAnalyze,
    [switch]$SkipTests,

    [switch]$NoBuildLock,
    [int]$LockTimeoutMinutes = 30
)

$ErrorActionPreference = 'Stop'

$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$BuildLockPath = Join-Path $ProjectRoot '.tmp\build_apk.lock'
$PackageName = 'com.focustimer.focus_timer'

function New-BuildLock {
    if ($NoBuildLock) { return $null }

    $lockDir = Split-Path -Parent $BuildLockPath
    if (-not (Test-Path -LiteralPath $lockDir)) {
        New-Item -ItemType Directory -Force -Path $lockDir | Out-Null
    }

    try {
        $stream = [System.IO.File]::Open(
            $BuildLockPath,
            [System.IO.FileMode]::OpenOrCreate,
            [System.IO.FileAccess]::ReadWrite,
            [System.IO.FileShare]::None
        )
        $bytes = [System.Text.Encoding]::UTF8.GetBytes("pid=$PID started=$(Get-Date -Format o)")
        $stream.SetLength(0)
        $stream.Write($bytes, 0, $bytes.Length)
        $stream.Flush()
        return $stream
    } catch [System.IO.IOException] {
        throw "Another build appears to be running. Close it first, or rerun with -NoBuildLock."
    }
}

function Run-Step {
    param(
        [string]$Title,
        [scriptblock]$Command
    )

    Write-Host ''
    $startedAt = Get-Date
    Write-Host "==> [$($startedAt.ToString('HH:mm:ss'))] $Title" -ForegroundColor Cyan
    try {
        & $Command
    } finally {
        $elapsed = (Get-Date) - $startedAt
        Write-Host "Elapsed: $Title ($([math]::Round($elapsed.TotalSeconds, 1))s)" -ForegroundColor DarkGray
    }
}

$buildLock = $null
try {
    Set-Location $ProjectRoot
    $buildLock = New-BuildLock

    if (-not $SkipAnalyze) {
        Run-Step 'flutter analyze' {
            flutter analyze
        }
    }

    if (-not $SkipTests) {
        Run-Step 'flutter test' {
            flutter test
        }
    }

    Run-Step "flutter build apk --$Mode" {
        flutter build apk "--$Mode"
    }

    $ApkName = if ($Mode -eq 'release') { 'app-release.apk' } else { 'app-debug.apk' }
    $ApkPath = Join-Path $ProjectRoot "build\app\outputs\flutter-apk\$ApkName"

    if (-not (Test-Path $ApkPath)) {
        throw "APK not found: $ApkPath"
    }

    $ApkItem = Get-Item $ApkPath
    $SizeMb = [math]::Round($ApkItem.Length / 1MB, 1)
    Write-Host ''
    Write-Host "APK: $ApkPath ($SizeMb MB)" -ForegroundColor Green

    if ($Install -or $Launch) {
        if ([string]::IsNullOrWhiteSpace($DeviceId)) {
            $devices = adb devices | Select-String -Pattern 'device$' | ForEach-Object {
                ($_ -split '\s+')[0]
            }

            if ($devices.Count -eq 1) {
                $DeviceId = $devices[0]
            } elseif ($devices.Count -eq 0) {
                throw 'No ADB device found. Connect a device or pass -DeviceId.'
            } else {
                Write-Host 'Connected devices:' -ForegroundColor Yellow
                adb devices -l
                throw 'Multiple ADB devices found. Pass -DeviceId <serial>.'
            }
        }
    }

    if ($Install) {
        Run-Step "adb install on $DeviceId" {
            adb -s $DeviceId install -r $ApkPath
        }
    }

    if ($Launch) {
        Run-Step "launch $PackageName on $DeviceId" {
            adb -s $DeviceId shell monkey -p $PackageName -c android.intent.category.LAUNCHER 1
        }
    }
} finally {
    if ($null -ne $buildLock) {
        $buildLock.Dispose()
    }
}
