### 

### **Windows Server Domain, Hardening & Safety rules**

This hardening focuses on Windows Server endpoints in a domain environment.  
Notes:   
Some protections may impact legacy applications and should be tested in audit mode before enforcement, audit allows us to take note of user behavior to identify necessary exceptions from the rules after the test period audits should be changed to block with necessary exceptions like legacy applications.   
The logs for each rule /audits can be found by their event id in Event viewer. 

Actual paths / server names should be replaced in a real deployment. Cmdlets are marked in green. 

#### 

#### **Inventory & Cleanup**

Get-WindowsFeature | Where-Object {$\_.InstallState \-eq "Installed"} \#inventera vad som finns och ta bort saker utan syfte eller legacy. Så som smbv1, telnet  etc på listan du får fram.   
Get-Service \# Overview of services and stop those without purpose.

\#Real-Time Monitoring is part of Windows Defender Antivirus and this has to be on.   
This can be applied through GPO but I have chosen to showcase my example in powershell and will show GPOs in other examples further down  
Set-MpPreference \-DisableRealtimeMonitoring $false 

#### 

#### **Controlled Folder Access (CFA)**

\#CFA protects files and directories from unauthorized modifications, directories can be added. Event ID 1123(Blocked access), 1124(Allowed)   
Set-MpPreference \-EnableControlledFolderAccess Enabled   
Logs can be found in Event Viewer:  
→ Applications and Services Logs  
→ Microsoft  
→ Windows  
→ Windows Defender  
→ Operational  

#### **Attack Surface Reduction:** Mitigates: Initial Access / Execution via malicious Office documents.

One of the common attack surfaces is child processes of Office applications. To stop code from being run through Excel and Word, we will make rules by creating a GPO right-click and edit.   
Computer Configuration  
→ Policies  
→ Administrative Templates  
→ Windows Components  
→ Microsoft Defender Antivirus  
→ Microsoft Defender Exploit Guard  
→ Attack Surface Reduction  
Here we will put reduction rules:   
Value name: 26190899-1602-49e8-8b27-eb1d0a1ce869 Value : 2 \#This rule Audits- Office applications from creating child processes. Event ID 1125 , Will later be changed to value: 1 which means blocked.   
Value name: 92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b Value: 1 \#Rule will block Win32 API calls from Office macros. Event ID 1121

Exceptions can be added in the same place under exclude rules.  
Logs can be found in Event viewer Applications and Services Logs → Microsoft → Windows → Windows Defender → Operational

#### **Network Protection** 

We will now go to network protection instead of surface reduction.  
Network protection is set on enable and has event ID 1126\.   
This uses Microsoft's Cloud list of **known malicious URLs** and if a URL matches one in the list it will be blocked.

#### **Credential Guard & Windows Defender Application Control (WDAC)**

#### This section covers credential isolation using virtualization-based security and application control through code integrity policies.

Example on how to make a CIP policy, you can add more programs you want allowed on your system.

$testPaths \= @(

    "C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE",

    "C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE",

    "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"

)

New-CIPolicy \-Level FilePublisher \` \#signed files 

    \-FilePath "\\\\servername\\share\\Policy\\OfficeTestPolicy.xml" \`

    \-UserPEs \`\#programs installed by the user

    \-Fallback Hash \#non signed files are identified by their hash.

Policy only applies to this path, other versions/drives need an adjusted path and 

\#You can convert the policy into binary when the scan is finished. (takes awhile)

ConvertFrom-CIPolicy \-XmlFilePath "\\\\servername\\share\\Policy\\OfficeTestPolicy.xml" \-BinaryFilePath \\\\servername\\share\\Policy\\OfficeTestPolicy.cip

We will now go to GPO edit

Computer Configuration  
→ Policies  
→ Administrative Templates  
→ System  
→ Device Guard →  Deploy Windows App Control Enable under option : Code integrity policy we will put the path to our policy:  \\\\servername\\share\\Policy\\OfficeTestPolicy.cip

#### **Folder Permissions (for CIP policy)**

Both share permissions and NTFS permissions must be correct for the UNC path to be accessible at startup.

1\. On the server, navigate to the folder containing the CIP file:  
   \\\\servername\\share\\Policy

2\. Right-click the folder → Properties → Sharing → Advanced Sharing

3\. Check "Share this folder"

4\. Click "Permissions" → "Add" → "Object Types..." → select "Computers" → OK

5\. Select "Domain Computers" and give at least "Read" permission → OK → Apply → OK to exit Sharing tab

6\. Now go to the Security tab → Edit → Add → Object Types → select "Computers" → OK

7\. Select "Domain Computers" → Assign "Read & Execute" permissions → Apply → OK

#### **Virtualization Based Security (VBS)**

We will now turn on Virtualization based security \- enabled.

**Options**:  
   
**Security level- secure boot**(Secure Boot ensures only signed firmware and bootloader gets to run pre Windows loading so if it fails here PC won’t start)   
**Virtualization protection of code integrity** \-Enabled without lock (Stops attacks that try to bypass kernel-signing)

**Credential guard conf**\- Enabled without lock(Isolates **LSA / NTLM / Kerberos tokens** in the hypervisor. Prevents privileged users from **stealing credential tokens from memory**.)

**Secure launch- Enabled**. (Windows checks that everything is legitimate before the OS loads but if Secure Launch detects a violation, Windows starts in Protected Mode with some components restricted, but the PC still boots)

Without lock allows Credential Guard / VBS / WDAC to run in test mode where policy violations are logged but not enforced. After testing, the UEFI lock can be applied to enforce the policy fully

##### **Recommended list of logs to monitor** 

1. Virus/Malware detection \- Event ID: 1116  
2. Realtidsövervakning \- Event ID: 5001  
3. Network protection of hostile urls \- Event ID: 1126   
4. Controlled Folder Access \- Event ID: 1127

##### 

