<#
    .SYNOPSIS
    This script disable Windows 10 Automatic Lock Screen dismissal
    .DESCRIPTION
    The script obtains the SID of the currently logged in user from WMI, then modifies a registry key to disable the Windows 10 automatic lock screen dismissal. 
    The script will output a log file to the default temp directory of the user.
    The script is inteded to be used once, but can be reinforced on a schedule if desired, but modify the script to perform soem level of log cleanup.
    .EXAMPLE
    Just run this script without any parameters in the system user context (for example, as an Intune Extensions Powershell script)
    .NOTES
    NAME: DisableAutoLockScreenDismissal.ps1
#>

$TranscriptPath = "$env:temp\DisableAutoLockScreenDismissal.log"

# Log method
function Log { Param([string]$message) Write-Output $message; }

# Set any variables
$FaceLogon = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\FaceLogon"

Try 
{
  Start-Transcript -Path $TranscriptPath -Force
  
  # Require dismissal of Lock Screen 
  Log "Disabling automatic dismissal of lock screen"
  Log "Getting logged in user"
  $User = $(Get-WMIObject -class Win32_ComputerSystem | select username).username
  $UserObj = New-Object System.Security.Principal.NTAccount("$user")
  Log "Getting user SID"
  $SIDObj = $UserObj.Translate([System.Security.Principal.SecurityIdentifier])
  $SID = $SIDObj.Value
  
  # Set registyry 
  Log "Testing registry paths"
  $PathValid = Test-Path -Path $FaceLogon
  if ($PathValid)
  {
    $SIDPathValid = Test-Path -Path $FaceLogon\$SID
    if (!$SIDPathValid)
    {
      Log "Creating registry key '$SID'"
      New-Item -Path $FaceLogon -Name $SID -Force
      Log "Setting registry key to disable automatic dismissal of lock screen"
      New-ItemProperty -Path $FaceLogon\$SID -type dword -Name AutoDismissOn -Value 0 -Force      
    }
    Else
    {
      Log "Setting registry key to disable automatic dismissal of lock screen"
      New-ItemProperty -Path $FaceLogon\$SID -type dword -Name AutoDismissOn -Value 0 -Force 
    }
  }
  Else
  {
    Log "Path $FaceLogon does not exist. Exiting script. "
  }  
    
}
Catch
{
  Write-Output "Error occurred"
  Write-Output $PSItem.ErrorID
  Write-Output $PSItem.Exception.Message
  break
}
Finally
{
  Stop-Transcript
}



