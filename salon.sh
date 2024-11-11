#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
  MAIN_MENU "I could not find that service. What would you like today?"
  else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed -r 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  TIME_FORMATTED=$(echo $SERVICE_TIME | sed -r 's/^ *| *$//g')
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $TIME_FORMATTED, $CUSTOMER_NAME_FORMATTED."
  else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed -r 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SEVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  TIME_FORMATTED=$(echo $SERVICE_TIME | sed -r 's/^ *| *$//g')
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $TIME_FORMATTED, $CUSTOMER_NAME_FORMATTED."
  fi
  fi
}

MAIN_MENU
