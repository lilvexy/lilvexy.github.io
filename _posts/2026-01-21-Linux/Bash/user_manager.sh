#!/bin/bash  

create_user() {
  read -p "input username for user: " username # läser input -p ger oss möjlighet att skriva ut ett meddelande och de som läses in sparas i variabeln angiven i detta fall username. 

  if [[ -z "$username" ]]; then #om username är tomt visa meddelande
    echo "enter username."
    return
  fi #ett sätt att avsluta if satsen. 

  if id "$username" 1>/dev/null; then #slänger outputen i dev null men ej felmeddelandet. 
    echo "User '$username' exists." 
  else
    sudo useradd "$username" #useradd skapar user med givna namnet
    if [ $? -eq 0 ]; then # $? specialvaribel som innehåller exitstatus från sista kommandot och checkar om de är likamed 0 dvs successfull
      echo "User '$username' has been created." #if successful echo output 
    fi #vi stänger if satsen utan att meddela fel då vi behåller systemets egna felmeddelande.
  fi 
}

delete_user() {
  read -p "input user to be deleted: " username

  if [[ -z "$username" ]]; then # om user är tomt då outputar den meddelandet. 
    echo "username is necessary"
    return
  fi

  if id "$username" &>/dev/null; then #resultat slängs i devnull vare sig de kördes eller ej och output.
    sudo userdel "$username"  #tar bort användaren sudo är nödvändigt för sådant. 
    if [ $? -eq 0 ]; then #återanvänder samma specialvariabel som innan.
      echo "User '$username' has been deleted." 
    else
      echo "Could not delete user." #här har vi ett meddelande för om de resultera i 2/felmeddelande, i denna funktion slänger vi systemets egna felmeddelande.
    fi
  else
    echo "User '$username' does not exist."
  fi
}
#Ny funktion -namn sedan syntax för funktion.
list_users() {
  echo "List of users:" #meddelar
  awk -F: '$3 >= 1000 && $3 < 60000 { print $1 }' /etc/passwd #-f separerar texten vid varje":" $3 innebär tredje fält de som uid den ska vara större än 1000 mindre än 60000 
} # detta är för att få bort systemusers som daemon etc. Print flik 1 efter sållning så får du fram vanliga users i etc/passwd. 

add_to_group() {

  read -p "Input Groupname: " gruppnamn 
  if [[ -z "$gruppnamn" ]]; then # om gruppnamnet är tomt , tex bara köra enter. så outputtar echo meddelande.
    echo "input group name."
    return
  fi

  read -p "Input user to add: " username
  if [[ -z "$username" ]]; then
    echo "username is necessary." 
    return
  fi

  if ! id "$username" &>/dev/null; then  # utrops tecknet innebär "inte" 
    echo "User '$username' does not exist."
    return
  fi

  if ! getent group "$gruppnamn" &>/dev/null; then # if ! getent cant match gruppnamn to a group 
    echo "Group '$gruppnamn' does not exist." # then outputtar meddelandet via echo if it does not.
    return
  fi

  sudo usermod -aG "$gruppnamn" "$username" #modify user , a står för append för att addera utan att överskriva, G för group. 
  if [ $? -eq 0 ]; then #samma som tidigare delar av skriptet.
    echo "User '$username' has been added to group '$gruppnamn'." 
  else #annars om de inte är 0 dvs inte kördes. 
    echo "Could not add user to group." 
  fi
}

while true; do # så länge de är true kör , givna meddelanden. de kommer alltid vara true, detta är ett sätt att fortsätta loopa.
  echo "what would you like to do?"
  echo "1) Create user"
  echo "2) Delete user"
  echo "3) List users"
  echo "4) Add to group"
  echo "5) Exit"

  read -p "Choose (1-5): " val  #sparar input till variabeln val

  case $val in #case kopplar valda siffran av option till funktionen som skall köras via funktion namn. 
    1) create_user ;;
    2) delete_user ;; # ;; betyder att de slutar här dvs inte köra något av de andra valen. 
    3) list_users ;;
    4) add_to_group ;;
    5) echo "bye bye!"; exit 0 ;; 
    *) echo -e "\e[31minvalid choice – choose between 1 and 5\e[0m" ;; #allt annat än 1-5 ger detta svar i rött. 

  esac #case baklänges , så man avslutar case. 
done #detta stänger while loopen. 
