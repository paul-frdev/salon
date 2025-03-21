#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
# echo $($PSQL "TRUNCATE appointments, customers Restart Identity")
echo -e "\n~~ ~~~~~ MY SALON ~~~~~ ~~\n"

MAIN_MENU() {

  if [[ ! $1 ]]; then
    echo "Welcome to My Salon, how can I help you?"
  else
    echo -e "\n$1"
  fi

  echo -e "\n1) cut \n2) color \n3) perm \n4) style \n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) SERVICE_MENU $SERVICE_ID_SELECTED ;;
  2) SERVICE_MENU $SERVICE_ID_SELECTED ;;
  3) SERVICE_MENU $SERVICE_ID_SELECTED ;;
  4) SERVICE_MENU $SERVICE_ID_SELECTED ;;
  5) SERVICE_MENU $SERVICE_ID_SELECTED ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SERVICE_MENU() {

  SERVICE_NAME=$($PSQL "Select name From services Where service_id = $SERVICE_ID_SELECTED")

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  EXIST_CUSTOMER_PHONE=$($PSQL "Select phone From customers Where phone = '$CUSTOMER_PHONE'")

  if [[ -z $EXIST_CUSTOMER_PHONE ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    CUSTOMER_INFO=$($PSQL "Insert Into customers(phone, name) Values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "Select customer_id From customers Where phone = '$CUSTOMER_PHONE'")

    APPOINT_NEW_CUSTOMER=$($PSQL "Insert Into appointments(customer_id, service_id, time) Values($CUSTOMER_ID, $1, '$SERVICE_TIME')")

    CUSTOMER_DETAILS $CUSTOMER_ID

  else
    CUSTOMER_ID=$($PSQL "Select customer_id From customers Where phone = '$CUSTOMER_PHONE'")
    CUSTOMER_DETAILS $CUSTOMER_ID
  fi

}

CUSTOMER_DETAILS() {
  INFO_TIME=$($PSQL "SELECT time From appointments Inner Join customers Using(customer_id)  Where customer_id = $1")
  INFO_SERVICE=$($PSQL "SELECT name From services Inner Join appointments Using(service_id)  Where customer_id = $1")
  INFO_NAME=$($PSQL "SELECT name From customers Inner Join appointments Using(customer_id)  Where customer_id = $1")

  MESSAGE $INFO_TIME $INFO_SERVICE $INFO_NAME
}

MESSAGE() {
  if [[ -z $EXIST_CUSTOMER_PHONE ]]; then
    echo -e "\nI have put you down for a $2 at $1, $3."
  else
    echo -e "\nYou have already had a reservation to a $2 at $1, $3"
  fi
}

EXIT() {
  echo -e "\n$1"
}

MAIN_MENU

# 555-555-5555
# 10:30
