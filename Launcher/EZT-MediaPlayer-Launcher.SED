[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=1
HideExtractAnimation=1
UseLongFileName=1
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=%InstallPrompt%
DisplayLicense=%DisplayLicense%
FinishMessage=%FinishMessage%
TargetName=%TargetName%
FriendlyName=%FriendlyName%
AppLaunched=%AppLaunched%
PostInstallCmd=%PostInstallCmd%
AdminQuietInstCmd=%AdminQuietInstCmd%
UserQuietInstCmd=%UserQuietInstCmd%
SourceFiles=SourceFiles
[Strings]
InstallPrompt=
DisplayLicense=
FinishMessage=
TargetName=.\Launcher\EZT-MediaPlayer.exe
FriendlyName=EZT-MediaPlayer
AppLaunched=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noprofile -ExecutionPolicy Bypass -Nologo -NonInteractive -File EZT-MediaPlayer-Setup.ps1
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="EZT-MediaPlayer-Setup.ps1"
FILE1="Version.txt"
[SourceFiles]
SourceFiles0=.\Launcher\
SourceFiles1=\
[SourceFiles0]
%FILE0%=
[SourceFiles1]
%FILE1%=
