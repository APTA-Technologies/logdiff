#!/bin/sh

# Grab arguments that we don't want to pass to logdiff
API_TOKEN="$1"
GIT_REF="$2"
REPO_NAME="$3"

# Shift remaining arguments down, e.g. with shift 1, $2 becomes $1
shift 3

PREVIOUS_MODEL_PATH="/home/flexfringe/previous.json"

# (1) make test -> logfiles (test repo)
# Happens outside this action

# (2)  download previous model (action)
curl https://logdiff.herokuapp.com/api/model/latest -o $PREVIOUS_MODEL_PATH --header "access_token: $API_TOKEN"

# (3) run flexfringe logdiff on logs and downloaded model (action)
echo "Previous model:"
cat $PREVIOUS_MODEL_PATH | jq
echo "RUNNING LOGDIFF (TODO)"
/home/flexfringe/flexfringe "$2" --mode=predict --predictalign=1 "$1" --aptafile="$PREVIOUS_MODEL_PATH"

echo "---------------------------------------------------------"

# (4) learn new model from logs (action)
/home/flexfringe/flexfringe "$@"

echo "---------------------------------------------------------"

# (5) push new model to database (action)
OUTPUT_PATH="$1.ff.final.json"
echo "Output path: $OUTPUT_PATH"

# Generate json to submit
JSON_OUTPUT=$( jq -n \
    --arg repo_name "$REPO_NAME" \
    --arg git_ref "$GIT_REF" \
    --argjson data "$(cat $OUTPUT_PATH)" \
    '{repo_name: $repo_name, git_ref: $git_ref, data: $data}')

# Post new model data
curl -X POST \
    --header 'Content-Type: application/json' \
    --header "access_token: $API_TOKEN" \
    --data "$JSON_OUTPUT" \
    https://logdiff.herokuapp.com/api/model

echo "---------------------------------------------------------"

# (6) publish logdiff results (action) 
echo "Publishing logdiff results... (TODO)"
RESULT_PATH="$PREVIOUS_MODEL_PATH.result"

JSON_RESULT=$( jq -n \
    --arg repo_name "$REPO_NAME" \
    --arg git_ref "$GIT_REF" \
    --arg data "$(cat $RESULT_PATH)" \
    '{repo_name: $repo_name, git_ref: $git_ref, data: $data}')
    
curl -X POST \
    --header 'Content-Type: application/json' \
    --header "access_token: $API_TOKEN" \
    --data "$JSON_RESULT" \
    https://logdiff.herokuapp.com/api/result

cp "$RESULT_PATH" ./logdiff_result.csv
echo "::set-output name=resultfile::logdiff_result.csv"
