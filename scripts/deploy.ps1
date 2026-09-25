$ErrorActionPreference = "Stop"
$DeployRoot = "C:\Hastenload\MT5-Agent"
$SourceRoot = $env:GITHUB_WORKSPACE

Write-Host "Deploying Preview MT5 Agent to $DeployRoot"
New-Item -ItemType Directory -Force -Path $DeployRoot | Out-Null

Get-ChildItem $DeployRoot -Force -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -notin @(".venv", "agent.log") } |
  Remove-Item -Recurse -Force

Copy-Item "$SourceRoot\agent.py" "$DeployRoot\agent.py" -Force
Copy-Item "$SourceRoot\requirements.txt" "$DeployRoot\requirements.txt" -Force

$Python = (Get-Command python -ErrorAction Stop).Source
if (-not (Test-Path "$DeployRoot\.venv\Scripts\python.exe")) {
    & $Python -m venv "$DeployRoot\.venv"
}
& "$DeployRoot\.venv\Scripts\python.exe" -m pip install --upgrade pip
& "$DeployRoot\.venv\Scripts\python.exe" -m pip install -r "$DeployRoot\requirements.txt"

Write-Host "Preview files deployed. MT5 agent task activation will be configured after runner registration."
