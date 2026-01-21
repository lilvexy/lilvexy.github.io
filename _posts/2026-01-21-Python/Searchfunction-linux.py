import os
os.system

def options ():
     print("1:sök efter en fil")
     print("2:sök folder")
     print("3:sök efter text")
     print("4:avsluta")
     val= input("välj alternativ (1-4)")
  
     if val=="1":
      
         print("ange filnamn du söker")
         filnamn= input()
         os.system(f"sudo find / -iname {filnamn} 2>/dev/null")
     if val=="2": 
         print ("ange namn på mappen")
         foldername= input()
         os.system(f"sudo find / -type d -name {foldername} 2>/dev/null") 
 

     if val=="3":
        print("ange text")
        text=input()   
        os.system(f"sudo grep -r {text} / 2>/dev/null")
     if val=="4":
         print("avslutar")
         exit()     

options()


