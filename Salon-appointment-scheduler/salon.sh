#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo  -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {

echo "Welcome to My Salon, how can I help you?"

echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"

read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-5]+$ ]]
then 
  echo -e "\nI could not find that service. What would you like today?"
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
else
  
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "What's your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  INSERT_APPOINTMENTS_RESULTS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID', '$SERVICE_TIME')")
  if [[ $INSERT_APPOINTMENTS_RESULTS == "INSERT 0 1" ]]
  then
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
fi

}

MAIN_MENU

