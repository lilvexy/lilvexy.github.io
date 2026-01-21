import tkinter as tk
from tkinter import messagebox
import datetime
import os
import json

# Always save files next to this script
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# -------------------------
# Funktioner
# -------------------------
def get_week_filename(date):
    """Skapar filnamn per vecka, t.ex. week51.json"""
    week_num = date.isocalendar()[1]
    return os.path.join(BASE_DIR, f"week{week_num}.json")

def load_tasks():
    """Ladda uppgifter från fil om den finns"""
    tasks_listbox.delete(0, tk.END)
    filename = get_week_filename(current_week)
    if os.path.exists(filename):
        with open(filename, "r", encoding="utf-8") as f:
            tasks = json.load(f)
            for task in tasks:
                if task["done"]:
                    tasks_listbox.insert(tk.END, f"{task['text']} ✅")
                else:
                    tasks_listbox.insert(tk.END, task['text'])

def save_tasks():
    """Spara alla uppgifter till fil"""
    tasks = []
    for i in range(tasks_listbox.size()):
        text = tasks_listbox.get(i)
        done = text.endswith("✅")
        if done:
            text = text[:-1].strip()
        tasks.append({"text": text, "done": done})
    filename = get_week_filename(current_week)
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(tasks, f, ensure_ascii=False, indent=2)

def add_task():
    task = task_entry.get().strip()
    if task:
        tasks_listbox.insert(tk.END, task)
        task_entry.delete(0, tk.END)
        save_tasks()
    else:
        messagebox.showwarning("Varning", "Skriv något först!")

def delete_task():
    try:
        index = tasks_listbox.curselection()[0]
        tasks_listbox.delete(index)
        save_tasks()
    except IndexError:
        messagebox.showwarning("Varning", "Välj en uppgift att ta bort!")

def toggle_done(event=None):
    """Markera/avmarkera uppgift som klar med höger-bock"""
    try:
        index = tasks_listbox.curselection()[0]
        text = tasks_listbox.get(index)

        if text.endswith("✅"):
            text = text[:-1].strip()  # Ta bort bock
        else:
            text = f"{text} ✅"  # Lägg till bock på höger sida

        tasks_listbox.delete(index)
        tasks_listbox.insert(index, text)
        save_tasks()
    except IndexError:
        pass

def update_week_label():
    week_num = current_week.isocalendar()[1]
    week_label.config(text=f"Vecka {week_num}")
    load_tasks()

def prev_week():
    global current_week
    current_week -= datetime.timedelta(weeks=1)
    update_week_label()

def next_week():
    global current_week
    current_week += datetime.timedelta(weeks=1)
    update_week_label()

# -------------------------
# GUI
# -------------------------
root = tk.Tk()
root.title("Weekly To-Do Widget")
root.geometry("320x420")
root.resizable(False, False)
root.configure(bg="#FFF8DC")  # Notepad-look

# ----------------------------------------
# Widget-inställningar
# ----------------------------------------
root.overrideredirect(True)          # Tar bort titelrad
root.attributes("-topmost", True)    # Alltid ovanpå
root.attributes("-alpha", 0.95)      # Lite genomskinligt (valfritt)

# Flytta fönstret
def start_move(event):
    root.x = event.x
    root.y = event.y

def stop_move(event):
    root.x = None
    root.y = None

def do_move(event):
    deltax = event.x - root.x
    deltay = event.y - root.y
    new_x = root.winfo_x() + deltax
    new_y = root.winfo_y() + deltay
    root.geometry(f"+{new_x}+{new_y}")

root.bind("<Button-1>", start_move)
root.bind("<ButtonRelease-1>", stop_move)
root.bind("<B1-Motion>", do_move)

current_week = datetime.date.today()

# Veckonavigering
week_frame = tk.Frame(root, bg="#FFF8DC")
week_frame.pack(pady=5)

prev_button = tk.Button(week_frame, text="< Föregående", command=prev_week)
prev_button.pack(side=tk.LEFT, padx=5)

week_label = tk.Label(week_frame, text="", font=("Arial", 14, "bold"), bg="#FFF8DC")
week_label.pack(side=tk.LEFT, padx=5)

next_button = tk.Button(week_frame, text="Nästa >", command=next_week)
next_button.pack(side=tk.LEFT, padx=5)

# Titel
label = tk.Label(root, text="Min To-Do Lista", font=("Arial", 12, "bold"), bg="#FFF8DC")
label.pack(pady=5)

# Inputfält
task_entry = tk.Entry(root, width=25, font=("Arial", 12))
task_entry.pack(pady=5)

# Lägg till knapp
add_button = tk.Button(root, text="Lägg till", width=20, command=add_task)
add_button.pack(pady=5)

# Lista
tasks_listbox = tk.Listbox(
    root,
    width=35,
    height=15,
    font=("Arial", 12),
    bg="#FFF8DC",
    selectbackground="#FFF8DC",
    selectforeground="black"
)
tasks_listbox.pack(pady=10)
tasks_listbox.bind("<Double-Button-1>", toggle_done)  # dubbelklick för att markera klar

# Ta bort knapp
delete_button = tk.Button(root, text="Ta bort markerad", width=20, fg="red", command=delete_task)
delete_button.pack(pady=5)


# -------------------------
# Starta appen
# -------------------------
update_week_label()
root.mainloop()
