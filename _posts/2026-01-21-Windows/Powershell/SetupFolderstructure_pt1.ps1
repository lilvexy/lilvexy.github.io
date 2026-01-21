
$logFile = "c:\Windows\Powershell\setup-log.txt"
$foldernames = @("scripts", "documentation", "userdata", "vmlogs", "backups") #variabeln innehåller array av namn för folders.
$basePath = "C:\Windows\Powershell" #basepath visar adressen där vi vill skapa foldersen.




$messages = @( #messages är en array av string 
    "welcome scripts are stored here ",
    "welcome, documentations are stored here.",
    "welcome, all user data is stored here",
    "Loggs from virtual machines are stored in this folder.",
    "Backupfiles and data is stored here."                                
)
for ($i = 0; $i -lt $foldernames.Count; $i++) {
    $foldername = $foldernames[$i] #definerar foldername som foldernames+1
    $message = $messages[$i] #definerar message som messages+1
    $fullPath = "$basePath\$foldername" #definerar fullpath som base sökvägen\foldername

    "Creating folder $fullPath" | Out-File -FilePath $logFile -Append

    New-Item -Path $fullPath -ItemType Directory -Force  #skapar mapp med sökväg fullpath

    New-Item -Path $fullPath -Name "Welcome.txt" -ItemType File -Force #skapar welcome text med sökväg fullpath

    "Creating welcome text $fullPath\Welcome.txt" | Out-File -FilePath $logFile -Append

    Set-Content -Path "$fullPath\Welcome.txt" -Value $message #sätter in text i folder welcome text och value är de som är i message variabeln.
    
} 

"Setting permissions for script folder" | Out-File -FilePath $logFile -Append
icacls "C:\Windows\Powershell\scripts" /reset /T #tar bort behörighet
icacls "C:\Windows\Powershell\scripts" /grant "Administrators:(OI)(CI)F" /inheritance:r #sätter dit admin behörighet. 
