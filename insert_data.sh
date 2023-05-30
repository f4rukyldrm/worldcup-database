#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]
  then
    # get winner and opponent id
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    # if not found
    if [[ -z $winner_id ]]
    then
      #insert winner name
      result=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
   
      # get new winner id
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    
    elif [[ -z $opponent_id ]]
    then
      #insert opponent name
      result=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")

      # get new opponent id
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
   
    fi
  fi
done

# insert others to the games table
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]
  then
    # get winner and opponent id
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    if [[ ! -z $winner_id && ! -z $opponent_id ]]
    then
      # insert
      result=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($year,'$round',$winner_id,$opponent_id,$winner_goals,$opponent_goals)")
    fi
  fi
done