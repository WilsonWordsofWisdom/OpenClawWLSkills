#!/bin/bash
# switch_model.sh - Modifies the default model in openclaw.json and restarts gateway

MODEL_ID=$1

if [ -z "$MODEL_ID" ]; then
    echo "Usage: ./switch_model.sh [MODEL_ID]"
    exit 1
fi

# 1. Strictly enforce openrouter/ prefix
if [[ ! "$MODEL_ID" == openrouter/* ]]; then
    echo ">>> Prefixing model with 'openrouter/'..."
    MODEL_ID="openrouter/$MODEL_ID"
fi

# 2. Validate the model ID against OpenRouter API
echo ">>> Validating model ID '$MODEL_ID' against OpenRouter..."
# Extract the raw ID (remove openrouter/ prefix for the API call)
RAW_ID=${MODEL_ID#openrouter/}
VALIDATION_RESPONSE=$(curl -s "https://openrouter.ai/api/v1/models")

# Check if the RAW_ID exists in the API response
if echo "$VALIDATION_RESPONSE" | jq -e ".data[] | select(.id == \"$RAW_ID\")" > /dev/null 2>&1; then
    echo ">>> Model ID validated successfully."
else
    echo "ERROR: Model ID '$MODEL_ID' is not a valid OpenRouter model."
    echo "Please check the ID and try again."
    exit 1
fi

echo ">>> Updating default model to $MODEL_ID..."
openclaw config set agents.defaults.model "$MODEL_ID"

if [ $? -eq 0 ]; then
    echo ">>> Restarting gateway to apply changes..."
    openclaw gateway restart
    
    # Verification step: check if gateway is responsive
    if openclaw gateway status > /dev/null 2>&1; then
        echo "Successfully updated default model to $MODEL_ID and restarted gateway."
    else
        echo "WARN: Gateway restart initiated, but status check failed. Please verify gateway is running."
    fi
else
    echo "Error: Failed to update model in openclaw.json"
    exit 1
fi