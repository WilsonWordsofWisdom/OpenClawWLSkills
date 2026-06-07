#!/bin/bash
# switch_model.sh - Modifies the default model in openclaw.json and restarts gateway

MODEL_ID=$1

if [ -z "$MODEL_ID" ]; then
    echo "Usage: ./switch_model.sh [MODEL_ID]"
    exit 1
fi

echo ">>> Updating default model to $MODEL_ID..."
openclaw config set agents.defaults.model "$MODEL_ID" --strict-json

if [ $? -eq 0 ]; then
    echo ">>> Restarting gateway to apply changes..."
    openclaw gateway restart
    echo "Successfully updated default model to $MODEL_ID and restarted gateway."
else
    echo "Error: Failed to update model in openclaw.json"
    exit 1
fi