#!/bin/bash
# TEST RUN
# ./autoIndexerScript.sh /home/nickshiell/storage/TestSet/PickleJar /home/nickshiell/storage/TestSet/PickleJar

# PRODUCTION RUN
#./autoIndexerScript.sh /home/nickshiell/storage/PickleJar /home/nickshiell/storage/PickleJar

# For production run
#YEARS=(2016 2017 2018 2019 2020 2021 2022)
#MONTHS=(January February March April May June July August September October November December)

# For test run
YEARS=(2016)
MONTHS=(August September October November December)

JOB_ARRAY=()

NUM_PROCESSES=10
JOBS_COMPLETED=0
TOTAL_JOBS=0

# Check that exactly one command line argument has been passed
if [ "$#" -ne 2 ]; then
    echo "Please provide an input and output directory"
    exit 
fi

# assign the input and output directories
BASE_INPUT_CSV_DATA_DIR=$1
BASE_OUTPUT_PKL_DATA_DIR=$2

# Create the jobs array
for year in ${YEARS[@]}; do
  for month in ${MONTHS[@]}; do
    JOB_ARRAY+=("${year}/${month}")
    ((TOTAL_JOBS=TOTAL_JOBS+1))
  done
done

NUMBER_OF_JOBS=${#JOB_ARRAY[@]}

# Assign the jobs in batchs, when a batch is complete move onto the next
while [ $JOBS_COMPLETED -lt $TOTAL_JOBS ]
do
  
  for (( i=0; i<$NUM_PROCESSES; i++ )); do
	  
    CUR_INPUT_DIR=${BASE_INPUT_CSV_DATA_DIR}"/"${JOB_ARRAY[$JOBS_COMPLETED]}"/"
	  CUR_OUTPUT_DIR=${BASE_OUTPUT_PKL_DATA_DIR}"/"${JOB_ARRAY[$JOBS_COMPLETED]}"/"
	  
    #echo python3 productionScript.py ${CUR_INPUT_DIR} ${CUR_OUTPUT_DIR} &
    python3 indexerProductionScript.py ${CUR_INPUT_DIR} ${CUR_OUTPUT_DIR} &
    
    pids[${i}]=$!
    ((JOBS_COMPLETED=JOBS_COMPLETED+1))

    # Break out if we run out of jobs
    if [ $JOBS_COMPLETED -ge $NUMBER_OF_JOBS ]
    then
      i=NUM_PROCESSES+1
    fi
  done
 
  # wait for all pids
  for pid in ${pids[*]}; do
    wait $pid
  done

  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
done