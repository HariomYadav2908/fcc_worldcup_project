#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi


# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 # if winner is winner
 if [[ $WINNER != 'winner' ]]
 then
    # get team id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

    # if team_id not found
    if [[ -z $WINNER_ID ]]
      then
        # inserting new team in database
        INSERT_TEAM_STATUS="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")"
        if [[ $INSERT_TEAM_STATUS='INSERT 0 1' ]] # if successful getting new id
          then
            WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
        fi
    fi

    # get opponent team id
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPP_STATUS="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi

    GAME_INSERT_STATUS="$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")"
    echo $GAME_INSERT_STATUS
    
 fi
done
