#!/bin/sh

PREVIOUS_MODEL_PATH="/home/flexfringe/previous.json"

# (1) make test -> logfiles (test repo)
# Happens outside this action

# (2)  download previous model (action)
wget https://logdiff.herokuapp.com/api/latest -O $PREVIOUS_MODEL_PATH

# (3) run flexfringe logdiff on logs and downloaded model (action)
echo "Previous model:"
cat $PREVIOUS_MODEL_PATH | jq
echo "RUNNING LOGDIFF (TODO)"

echo "---------------------------------------------------------"

# (4) learn new model from logs (action)
/home/flexfringe/flexfringe "$@"

echo "---------------------------------------------------------"

# (5) push new model to database (action)
OUTPUT_PATH="$1.ff.final.json"
echo "Output path: $OUTPUT_PATH"
wget \
    --header 'Content-Type: application/json' \
    --post-file "$OUTPUT_PATH" \
    https://logdiff.herokuapp.com/api/latest

echo "---------------------------------------------------------"

# (6) publish logdiff results (action) 
echo "Publishing logdiff results... (TODO)"

