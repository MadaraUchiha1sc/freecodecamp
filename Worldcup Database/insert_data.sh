#! /bin/bash

if [[ $1 == "test" ]]
then
PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  TEAMS1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'") 
  if [[ $WINNER != "winner" ]]
  then
    if [[ -z $TEAMS1 ]]
    then
      INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
      then
        echo Inserted names, $WINNER
      fi
    fi
  fi

  TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
   if [[ $OPPONENT != "opponent" ]]
   then
     if [[ -z $TEAMS2 ]]
     then
      INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
      then
        echo Inserted team, $OPPONENT
      fi
     fi 
   fi

   YEARS=$($PSQL "SELECT year FROM games WHERE year='$YEAR'")
   if [[ $YEAR != "year" ]]
   then
     if [[ -z $YEARS ]]
     then 
       INSERT_YEARS=$($PSQL "INSERT INTO games(year) VALUES('$YEAR')")
       if [[ $INSERT_YEARS == "INSERT 0 1" ]]
       then
         echo Inserted year, $YEAR
       fi
     fi
   fi

   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

   if [[ -n $WINNER_ID || -n $OPPONENT_ID ]]
   then 
     if [[ $YEAR != "year" ]]
     then
       INSERT_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
       if [[ $INSERT_DATA == "Insert 0 1" ]]  
       then
         echo Inserted data, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
       fi
     fi
   fi
done
