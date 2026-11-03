$ErrorActionPreference = "Stop"

# Ask user input
$UriAndName = Read-Host "What is the task name?`n  Type nothing press Enter for default is `"NAT emulator for IPv6`"`nYour answer"
if ($UriAndName.Length -eq 0){
    $UriAndName = "NAT emulator for IPv6"
}
$UriAndName = "\$($UriAndName)"
$IgnoresString = Read-Host "Type Ignores argument`n  Type nothing press Enter for default is `"CustomRule_`"`nYour answer"
if ($IgnoresString.Length -eq 0){
    $IgnoresString = "`"CustomRule_`""
}

$WorkingDirectory = (Get-Location).Path
$PathToNats = "`"$(Join-Path -Path $WorkingDirectory -ChildPath "nats.ps1")`""
Read-Host "Your install path will be:`n  $($PathToNats)`nPress Enter to generate task scheduler xml file"

# Replace text
$taskXml = Get-Content ".\task_scheduler_template.xml" -Raw
$taskXml = $taskXml.Replace("///UriAndName///", $UriAndName)
$taskXml = $taskXml.Replace("///PathToNats///", $PathToNats)
$taskXml = $taskXml.Replace("///IgnoresString///", $IgnoresString)

$taskXml | Out-File "NAT emulator for IPv6.xml"
$taskXmlPath = Join-Path -Path $WorkingDirectory -ChildPath "NAT emulator for IPv6.xml"
Set-Clipboard -Value $taskXmlPath
Read-Host "Press Enter to open Task Scheduler`n  Navigate to the folder you want to create the task`n  Import and choose and paste has copied to clipboard`n    `"$($taskXmlPath)`"`n  Check `"Run whether user is logged on or not`"`n    if you want to hide python window on launch`n  Right click on task and run manually once`nPress Enter to open Task Scheduler"

taskschd

Write-Host "It is now safe to turn off`nyour powershell window."
Read-Host
