#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# $PSQL "TRUNCATE TABLE games, teams"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# echo $YEAR, $WINNER
if [[ $YEAR != 'year' ]]
then 
  WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
  if [[ -z $WINNER_ID ]]
  then 
  INSERT_TEAMS_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    if [[ $INSERT_TEAMS_RESULT=='INSERT 0 1' ]]
    then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
    fi
  # INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
  fi
  if [[ -z $OPPONENT_ID ]]
  then
  INSERT_TEAMS_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    if [[ $INSERT_TEAMS_RESULT=='INSERT 0 1' ]]
    then
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
    fi
  fi
  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  # if [[ $INSERT_GAMES_RESULT=='INSERT 0 1' ]]
  # echo $YEAR $ROUND $WINNER $OPPONENT
fi
done