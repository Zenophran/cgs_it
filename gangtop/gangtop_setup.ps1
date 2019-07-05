#This script will set up a gangshow laptop from its default system image into something approaching usable
#It must be run as administrator while connected to the internet

#allow the script to execute
#required for chocolatey to install
Set-ExecutionPolicy Bypass -Scope Process -Force

#set the time zone
Set-TimeZone -Name "AUS Eastern Standard Time"

#Add Users
#This relies on a csv in the following format
#    "username","password"
#    "testuser1","thisisareallyannoyingpasswordtotype"
#    "testuser2","reallylongc0mplexP@sswordgoeshere"
#
# This is done first so the USB drive containing user information can be moved to another laptop quickly
ForEach ($user in (Import-CSV "D:\users.csv")){
  $SecurePassword =  ConvertTo-SecureString $user.password -AsPlainText -Force
  New-LocalUser -AccountNeverExpires -Name $user.username -UserMayNotChangePassword -Password $SecurePassword -PasswordNeverExpires
  $newuser=Get-LocalUser -Name $user.username
  Add-LocalGroupMember -Group Users -Member $newuser
  }

# eject the USB drive so it can be used on the next PC
$driveEject = New-Object -comObject Shell.Application
$driveEject.Namespace(17).ParseName("D:").InvokeVerb("Eject")

write "You can remove the USB drive"

#do these first to get the interactive ones out of the way while we're in front of the laptop
#mcafee livesafe
$MLSArguments = @(
  "/body:misp://MSCJsRes.dll::uninstall.html"
  "/id:uninstall"
)
Start-Process "C:\Program Files\McAfee\MSC\mcuihost.exe" -ArgumentList $MLSArguments -WorkingDirectory "C:\Program Files\mcafee\msc" -Wait

#mcafee webadvisor
start-process "C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe" -Wait

#enable windows defender sandboxing (after a reboot)
setx /M MP_FORCE_USE_SANDBOX 1

#silent uninstalls
#uninstall bloatware/trials
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^5A894077.McAfeeSecurity*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^7EE7776C.LinkedInforWindows*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^B9ECED6F.ASUSGIFTBOX*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^B9ECED6F.ASUSPCAssistant*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.BingWeather*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.People*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.Wallet*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.WindowsMaps*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.Xbox.TCUI*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.XboxApp*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.XboxGameOverlay*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.XboxGamingOverlay*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.XboxIdentityProvider*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.XboxSpeechToTextOverlay*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.YourPhone*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.ZuneMusic*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName
$package = Get-AppxProvisionedPackage -online |Where-Object -Property PackageName -Match "^Microsoft.ZuneVideo*"
Remove-AppxProvisionedPackage -online -PackageName $package.PackageName

#asus giftbox
$MSIArguments = @(
  "/x"
  "{4701E5AB-AF91-4D40-8F18-358CC80E4E5B}"
  "/qb-!"
  "/norestart"
)
Start-Process "MsiExec.exe" -ArgumentList $MSIArguments -Wait

#asus hello
$MSIArguments = @(
  "/x"
  "{D8CE1923-92A9-4036-817E-9E0D8AA2169B}"
  "/qb-!"
  "/norestart"
)
Start-Process "MsiExec.exe" -ArgumentList $MSIArguments -Wait

#asus device activation
$MSIArguments = @(
  "/x"
  "{9C4B0706-9F9A-47BF-B417-0A111FC52B04}"
  "/qb-!"
  "/norestart"
)
Start-Process "MsiExec.exe" -ArgumentList $MSIArguments -Wait

#ASUS ZenAnywhere
$MSIArguments = @(
  "/x"
  "{F5FAC87D-741C-4891-B113-19C9725E8368}"
  "/qb-!"
  "/norestart"
)
Start-Process "MsiExec.exe" -ArgumentList $MSIArguments -Wait

#download and install chocolatey
#yes you shouldn't download and run scripts from the internet but chocolatey is a known source
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#install packages
choco install -y python git.install winamp googlechrome Firefox inkscape libreoffice-fresh gimp krita scribus

#refresh the environment after the install
refreshenv

#install the gangserver prereqs
#it's done on all laptops in case we have a failure
c:\python37\pip install flask flask-restful requests

$PIPArguments = @(
  "install"
  "flask"
  "flask-restful"
  "requests"
)
Start-Process "c:\python37\scripts\pip.exe" -ArgumentList $PIPArguments -Wait

#finally check for windows updates
start-process "wuauclt.exe" -ArgumentList "/updatenow"
