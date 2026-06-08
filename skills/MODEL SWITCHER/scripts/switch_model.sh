#!/bin/bash
# switch_model.sh - Modifies the model for a specific agent in openclaw.json

MODEL_ID=$1
AGENT_NAME=$2

if [ -z "$MODEL_ID" ]; then
    echo "Usage: ./switch_model.sh [MODEL_ID] [AGENT_NAME]"
    exit 1
fi

# 1. Resolve agent name — prefer explicit arg, then active agent, then error
if [ -z "$AGENT_NAME" ]; then
    AGENT_NAME=$(openclaw agent current --name 2>/dev/null)
fi

if [ -z "$AGENT_NAME" ]; then
    echo "ERROR: Could not determine the current agent name."
    echo "Pass it explicitly: ./switch_model.sh [MODEL_ID] [AGENT_NAME]"
    exit 1
fi

echo ">>> Targeting agent: $AGENT_NAME"

# 2. Strictly enforce openrouter/ prefix
if [[ ! "$MODEL_ID" == openrouter/* ]]; then
    echo ">>> Prefixing model with 'openrouter/'..."
    MODEL_ID="openrouter/$MODEL_ID"
fi

# 3. Validate the model ID against OpenRouter API
echo ">>> Validating model ID '$MODEL_ID' against OpenRouter..."
RAW_ID=${MODEL_ID#openrouter/}
VALIDATION_RESPONSE=$(curl -s "https://openrouter.ai/api/v1/models")

if echo "$VALIDATION_RESPONSE" | jq -e ".data[] | select(.id == \"$RAW_ID\")" > /dev/null 2>&1; then
    echo ">>> Model ID validated successfully."
else
    echo "ERROR: Model ID '$MODEL_ID' is not a valid OpenRouter model."
    echo "Please check the ID and try again."
    exit 1
fi

# 4. Find the index of the target agent in the agents.list array
CONFIG_PATH="$HOME/.openclaw/openclaw.json"
AGENT_INDEX=$(jq '.agents.list | map(.id == "'"$AGENT_ID"'") | index(true)' "$CONFIG_PATH")

if [ "$AGENT_INDEX" == "null" ] || [ -z "$AGENT_INDEX" ]; then
    echo "ERROR: Agent ID '$AGENT_ID' not found in agents.list."
    exit 1
fi

echo ">>> Found agent '$AGENT_ID' at index $AGENT_INDEX."
echo ">>> Updating model for agent '$AGENT_ID' to $MODEL_ID..."

# 5. Update the specific agent's model using the index
openclaw config set "agents.list[$AGENT_INDEX].model" "$MODEL_ID"

# 5. Apply the model change to the specific agent only
# echo ">>> Updating model for agent '$AGENT_NAME' to $MODEL_ID..."
# openclaw config set "agents.$AGENT_NAME.model" "$MODEL_ID"

if [ $? -eq 0 ]; then
    echo ">>> Restarting gateway to apply changes..."
    openclaw gateway restart

    if openclaw gateway status > /dev/null 2>&1; then
        echo "Successfully updated model for agent '$AGENT_NAME' to $MODEL_ID and restarted gateway."
    else
        echo "WARN: Gateway restart initiated, but status check failed. Please verify gateway is running."
    fi
else
    echo "Error: Failed to update model for agent '$AGENT_NAME' in openclaw.json"
    exit 1
fi