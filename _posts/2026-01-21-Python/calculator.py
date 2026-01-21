import tkinter as tk
import os
from datetime import datetime


class Gui: # Klassen Gui används för att uppfylla kravet på OOP i uppgiften då jag redan hade byggt miniräknaren innan uppgiften las ut.
    def __init__(self, master, display_widget, greeting_widget):#input till funktionen
        self.window = master 
        self.display = display_widget
        self.greeting = greeting_widget

    def update_display(self, text):
        self.display.delete(0, tk.END)
        self.display.insert(0, text)

window = tk.Tk()
window.title("Calculator")

# --- Display ---
greeting = tk.Label(text="Calculator", foreground="white", background="black", width=34, height=1)
greeting.grid(row=0, columnspan=4)

display = tk.Entry(window, width=20, justify='right', font=('Arial', 16)) #entry tillåter input så som injections
display.grid(row=1, column=0, columnspan=4, padx=5, pady=5)

# --- Skapa instans av klassen ---
app = Gui(window, display, greeting)

# Förhindra tangentbordsinput genom att binda tangent, för att förhindra injections, Jag har valt att inte använda för att försöka logga injection attempts. 
#display.bind("<Key>", lambda e: "break") 


# --- Knappar ---
buttons = [
    ("0",5,1),("1",4,0),("2",4,1), # arrayn tar 3 argument siffran, row, column dvs vad som visas och vart den är placerad. 
    ("3",4,2),("4",3,0),("5",3,1),
    ("6",3,2),("7",2,0),("8",2,1),
    ("9",2,2)
]
symbols = [("+",5,3),("-",4,3),("*",3,3),("/",2,3)] #array av symboler med position på guit
history = [] #tom array för calculate som global history.

# --- Funktioner ---
def on_button_click(value): #definerar functionen
    current = display.get() #de som ska ske i funktionen, current = de som är på skärmen.
    display.delete(0, tk.END) #display rensas
    display.insert(0, current + value)#sätter in de som fanns på skärmen + value.

def check_expression(expression): #kontroll av expression
    susattempt=False
    sustext=expression
    for karakter in expression:
        tariff = False #tariff anges som falsk
        for check in range(0, 10): #check är 0 till 10 då range går genom alla siffror mellan dessa. 
            if karakter == str(check): #om karaktär är samma som string av check dvs siffror men en string inte int
                tariff = True   #så blir tariff true
        # symbolkontroll
        if karakter in ['+', '-', '*', '/']: #om karaktär är någon av dessa symboler
            tariff = True  # så blir de också true. 
        if tariff == False: #om tariff är false
            susattempt=True
            expression = expression.replace(karakter, "") #expression anges som replace karaktär med tom sträng (förhindra injections så man bara får skriva tillåtna.)
        
    if susattempt:
      print("fck u")  # terminalmeddelande
      logpath = os.path.join(os.path.dirname(__file__), "sus_attempt_log.txt") #vart logfilen sparas, formatet är för att de ska fungera på andra datorer och inte behöver andra mappar
      with open(logpath, "a") as file: #öppnar logfilen som append. 
        file.write(f"{datetime.now()} - Försök: {sustext}\n")    #adderar detta. 

    return expression

def calculate(): #funktion för att calculera
    global history #i funktionen saå tror python att du vill skapa en lokal variabel så man behöver ange global sedan variabeln för att använda i funktionen. 
    try: #försöker köra detta
        expression = display.get() #vi återanvänder expression här där de visar display innehållet
        checked_expression = check_expression(expression) #här lagras resultatet av check_expression funktionen ovan 
        result = eval(checked_expression) #result= eval av checked_expression.(eval är de som gör de möjligt med injections därför behöver de som evalueras vara kontrollerad innehåll)
        history.append(f"{expression}={result}")
        display.delete(0, tk.END) #tar bort innehållet på display allt
        display.insert(0, str(result)) #sätter in result i sträng 
    except Exception as e: #annars om tryn inte går eller de blir fel så raderar den innehållet på display och skriver ut no.
        display.delete(0, tk.END)
        display.insert(0,"no")

def delete():

    display.delete(len(display.get())-1)  # deletes last character

for (text,row,col) in buttons: 
    tk.Button(window, text=text, width=5, height=2, background="white", foreground="black",
              command=lambda t=text: on_button_click(t)).grid(row=row, column=col, padx=5, pady=5) #lägger in buttons med färg storlek etc. lambda tillger en liten funktion

for (symbol,row,col) in symbols:
    tk.Button(window, text=symbol, width=5, height=2,
              command=lambda s=symbol: on_button_click(s)).grid(row=row, column=col, padx=5, pady=5)

tk.Button(window, text="=", width=5, height=2, command=calculate).grid(row=5, column=2, padx=5, pady=5) #skapar equal symbol här för att kunna tillge den seperat command
tk.Button(window, text="C", width=5, height=2, command=delete).grid(row=5, column=0, padx=5, pady=5) #skapar radera symbol här för att de inte är en symbol 

window.mainloop()
