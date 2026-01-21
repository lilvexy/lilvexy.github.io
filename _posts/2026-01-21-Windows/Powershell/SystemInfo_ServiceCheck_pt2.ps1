start-transcript -path "c:\ITLAB\\system-report.txt" #sparar allt som kommer efter i text file till givna adressen och givna textfilnamn.

Write-host "Username is :" $env:USERNAME #skriver ut förklaring till svaret ur commandon #användarnamn
Write-host "Name is :" $env:COMPUTERNAME # Datornamn 

Write-host "Date:"(get-date) #dagens datum och tid. 
Write-host "Windows version:"(get-wmiobject -class Win32_OperatingSystem).version #skriv ut windows version. Hämtar ut .version ur objekt i parentes. 
Write-host "Available Space in Disk C: " (Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq "c:"}|foreach-object{[math]::round($_.freespace/1024/1024/1024)}) "GB" 
#(kodförklaring)hämtar wmiobjekt i klass logicaldisk skickar över(pipe) till kommandot where objekt, tar ut variabel deviceid som ska vara euqal to string c:. Pipe igen och plocka ut freespace
#Math round gör att freespace talet rundas till heltal och /1024 delen konverterar byte till gb. 
$stoppadservices = Get-Service | Where-Object { $_.Status -eq 'Stopped' -and $_.Name -in @('Spooler', 'DHCP', 'DNS') } #variabeln stoppadservices equals output av koden påhögraled.if ($stoppadservices) 

  $stoppadservices | ForEach-Object {
   Write-Host "WARNING: The service '$($_.Name)' is stopped!"  -ForegroundColor Red #output varning service namn stoppad i rödtext. 
}

Write-host "Running Services:"
(Get-Service | Where-Object { $_.Status -eq 'running'}).name #hämtar körande tjänster och tar ut namn på dessa. 

# Skapa en schemalagd uppgift som kör skript servicecheck (bara något extra för att man vill ju kolla detta hela tiden)
$taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\Windows\Powershell\AlertServiceStop.ps1" #kör ps argument är skriptet som ska köras.
$taskTrigger = New-ScheduledTaskTrigger -daily -DaysInterval 1 -At 8AM #trigger variabeln innehåller nya tasktrigger som sätts på daily och dagsintervall på 1dvs varjedag vid 8:00
# Registrera den schemalagda uppgiften med authority
Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName "ServiceCheckDaily" -Description "status check varje dag" -User "NT AUTHORITY\SYSTEM" -RunLevel Highest

Stop-transcript  #sluta logga
