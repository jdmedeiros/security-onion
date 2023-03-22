data "template_file" "winsrv" {
  template = <<EOF
<powershell>
# Rename Machine
Rename-Computer -NewName "winsrv" -Force;
$Secure_String_Pwd = ConvertTo-SecureString "Passw0rd" -AsPlainText -Force
Set-LocalUser administrator -Password $Secure_String_Pwd
Invoke-WebRequest -Uri https://download.sysinternals.com/files/SysinternalsSuite.zip -OutFile C:\Users\Administrator\Desktop\SysinternalsSuite.zip
Expand-Archive C:\Users\Administrator\Desktop\SysinternalsSuite.zip -DestinationPath C:\Users\Administrator\Desktop\SysinternalsSuite
Remove-Item C:\Users\Administrator\Desktop\SysinternalsSuite.zip
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\NetworkMiner.lnk")
$Shortcut.TargetPath = "https://www.netresec.com/?download=NetworkMiner"
$Shortcut.Save()
# Restart machine
shutdown -r -t 10;
</powershell>
EOF
}
