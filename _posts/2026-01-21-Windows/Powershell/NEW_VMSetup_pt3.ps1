start-transcript -path "c:\ITLab\VMLogs\vm-creation.log" #skriver ner allt som kommer efter till  given path.
New-VM -Name "TestLab-VM" ` #skapar ny vm med detta namn
       -MemoryStartupBytes 2GB ` #mängden ram
       -Generation 2 ` #väljer generation 
       -NewVHDPath "C:\ITLAB\VHDs\TestLab-VM.vhdx" ` #Location av virtuellhårddisk
       -NewVHDSizeBytes 25GB ` #hårddisksize.
       -SwitchName "Default Switch" #vilken switch den ska ha. 
       
(Get-VM -Name "TestLab-VM").State #hämtar vm info på given vm name resultatet tar vi ut status på. 
(Get-VM -Name "TestLab-VM").MemoryAssigned #samma som ovan fast för minne
Set-VMDvdDrive -VMName "TestLab-VM" -Path "D:\Windows.iso" #sätter drive på vm där path  location där iso filen befinner sig. 
stop-transcript #sluta logga då allt nedan redan loggas. 


Get-VM "testlab-vm" | Select-Object Name, State | Out-File -FilePath "C:\itlab\vmlogs\vm-status.txt" #hämta vm name och status pipa ut detta till en textfil.
Get-VM "testlab-vm" | Select-Object @{Name="Memory(GB)"; Expression={[math]::Round($_.MemoryAssigned / 1024/1024/1024)}}| Out-File -FilePath "C:\itlab\vmlogs\vm-memory.txt" #höntar vm info, plockar ut namn memory gb och roundar till heltal delat på 1024 för att omvandla till gb. 