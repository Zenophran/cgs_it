#This script will set up a gangshow laptop from its default system image into something approaching usable
#It must be run as administrator while connected to the internet

#allow the script to execute
Set-ExecutionPolicy Bypass -Scope Process -Force

#uninstall bloatware/trials
Remove-AppxProvisionedPackage -Online -PackageName "5A894077.McAfeeSecurity_1.4.3.0_neutral_~_wafk5atnkzcwy"
Remove-AppxProvisionedPackage -Online -PackageName "7EE7776C.LinkedInforWindows_2.1.7098.0_neutral_~_w1wdnht996qgy"
Remove-AppxProvisionedPackage -Online -PackageName "B9ECED6F.ASUSGIFTBOX_3.1.7.0_neutral_~_qmba6cd70vzyy"
Remove-AppxProvisionedPackage -Online -PackageName "B9ECED6F.ASUSPCAssistant_2.0.15.0_neutral_~_qmba6cd70vzyy"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.BingWeather_4.28.10351.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.People_2019.305.632.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.SkypeApp_14.48.51.0_neutral_~_kzf8qxf38zg5c"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.Wallet_2.2.18179.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.Windows.Photos_2019.19041.16510.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.WindowsMaps_2019.325.2243.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.Xbox.TCUI_1.24.10001.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.XboxApp_48.54.25001.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.XboxGameOverlay_1.42.12001.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.XboxGamingOverlay_3.30.20002.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.XboxIdentityProvider_12.54.4001.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.XboxSpeechToTextOverlay_1.21.13002.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.YourPhone_2019.620.738.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.ZuneMusic_2019.19031.11411.0_neutral_~_8wekyb3d8bbwe"
Remove-AppxProvisionedPackage -Online -PackageName "Microsoft.ZuneVideo_2019.19031.11411.0_neutral_~_8wekyb3d8bbwe"

#do these first to get the interactive ones out of the way
#mcafee livesafe
$MLSArguments = @(
  "/x"
  "C:\Windows\Installer\5ee33.msi"
  "/qb-!"
  "/norestart"
)
Start-Process "C:\Program Files\McAfee\MSC\mcuihost.exe" -ArgumentList $MSIArguments -Wait

#mcafee webadvisor
start-process "C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe" -Wait

#enable windows defender sandboxing (after a reboot)
setx /M MP_FORCE_USE_SANDBOX 1

#silent uninstalls
#asus giftbox
$MSIArguments = @(
  "/x"
  "C:\Windows\Installer\5ee33.msi"
  "/qb-!"
  "/norestart"
)
Start-Process "MsiExec.exe" -ArgumentList $MSIArguments -Wait

#asus hello
$MSIArguments = @(
  "/x"
  "C:\Windows\Installer\5ee37.msi"
  "/qb-!"
  "/norestart"
)
Start-Process "MsiExec.exe" -ArgumentList $MSIArguments -Wait

#asus device activation
$MSIArguments = @(
  "/x"
  "C:\Windows\Installer\447dc3.msi"
  "/qb-!"
  "/norestart"
)
Start-Process "MsiExec.exe" -ArgumentList $MSIArguments -Wait

#mcafee web advisor
$MSIArguments = @(
  "/x"
  "{FCC74B77-EC3E-4DD8-A80B-008A702075A9}"
  "/qb-!"
  "/norestart"
)
Start-Process "MsiExec.exe" -ArgumentList $MSIArguments -Wait

#download and install chocolatey
#yes you shouldn't download and run scripts from the internet but chocolatey is a known source
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#install packages
choco install -y python git.install winamp googlechrome Firefox 

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

