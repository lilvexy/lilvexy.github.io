$logFile = "C:\ITLAB\documentation\checklogg.txt" #adressen som logfile innehåller. 

$stoppadservices = Get-Service | Where-Object { $_.Status -eq 'Stopped' -and $_.Name -in @('Spooler', 'DHCP', 'DNS') } #variabeln stoppadservices equals output av koden påhögraled.
if ($stoppadservices) 
{
    $stoppadservices | ForEach-Object #om någon av ovan givna service namn är stoppade
    {
        $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - WARNING: The service '$($_.Name)' is stopped." #meddela datum i format och ange warning namn stoppad
        $logMessage | Out-File -Append -FilePath $logFile #logmeddelandet pipas ut till textfil till angivna adressen i variabel logfile.
      
    }
}
 else #annars
{
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - All services are running." # logga datum i format och alla services är igång 
    $logMessage | Out-File -Append -FilePath $logFile #pipa logmeddelande till textfil i adress given i variabel logfile. 
}