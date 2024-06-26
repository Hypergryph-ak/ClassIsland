﻿$PUBLISH_TARGET = ".\ClassIsland"

Write-Host "Build starting..." -ForegroundColor Cyan
$env:git_latest_tag = git describe --abbrev=0 --tags
$env:git_commit_short = $(git rev-parse HEAD).substring(0, 7)
$env:git_current_branch = git branch --show-curren
echo "Git commit: ${env:git_commit_short} ${env:git_latest_tag} ${$env:git_current_branch}"
echo "APPVEYOR_REPO_TAG = ${env:APPVEYOR_REPO_TAG}"

dotnet publish .\ClassIsland\ClassIsland.csproj -c Release -p:PublishProfile=FolderProfile -p:PublishDir=$PUBLISH_TARGET -property:DebugType=embedded

Write-Host "Successfully published to $PUBLISH_TARGET" -ForegroundColor Green

Write-Host "Packaging..." -ForegroundColor Cyan
if ($(Test-Path ./out) -eq $false) {
    mkdir out
} else {
    rm out/* -Recurse -Force
}
7z a ./out/ClassIsland.zip ./ClassIsland/ClassIsland/* -r -mx=9

Write-Host "Generating MD5..." -ForegroundColor Cyan
pwsh -ep Bypass -c .\tools\generate-md5.ps1 ./out


if ($env:APPVEYOR_REPO_TAG -eq $true) {
    Write-Host "Uploading to AppCenter..." -ForegroundColor Cyan
    pwsh -ep Bypass -c .\tools\pre-appcenter-upload.ps1
    pwsh -ep Bypass -c .\tools\appcenter-upload.ps1 $env:appcenter_token ${env:git_latest_tag}
} else {
    Write-Host "Skiped uploading to AppCenter." -ForegroundColor Yellow
}

Write-Host "Completed!" -ForegroundColor Green
