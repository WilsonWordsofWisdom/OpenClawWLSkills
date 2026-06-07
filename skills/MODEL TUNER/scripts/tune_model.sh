#!/bin/bash
# tune_model.sh - Updates OpenClaw model parameters and restarts gateway

# Default values if not provided
TEMPERATURE=${TEMPERATURE:-0.7}
TOP_P=${TOP_P:-0.90}
TOP_K=${TOP_K:-40}
MODEL_ID=${MODEL_ID:-""}

# Build the config base path — per-model or global
if [ -n "$MODEL_ID" ]; then
 CONFIG_BASE="agents.defaults.models.'$MODEL_ID'.params"
 SCOPE_LABEL="model '$MODEL_ID'"
else
 CONFIG_BASE="agents.defaults.params"
 SCOPE_LABEL="global (all models)"
fi

REMOTE_COMMANDS=""
REMOTE_COMMANDS+="echo '>>> [1/5] Setting temperature ($TEMPERATURE) on $SCOPE_LABEL...' && "
REMOTE_COMMANDS+="$OPENCLAW_CMD config set $CONFIG_BASE.temperature $TEMPERATURE --strict-json && "
REMOTE_COMMANDS+="echo '>>> [2/5] Setting top_p ($TOP_P)...' && "
REMOTE_COMMANDS+="$OPENCLAW_CMD config set $CONFIG_BASE.top_p $TOP_P --strict-json && "
REMOTE_COMMANDS+="echo '>>> [3/5] Setting top_k ($TOP_K) (best-effort)...' && "
REMOTE_COMMANDS+="($OPENCLAW_CMD config set $CONFIG_BASE.top_k $TOP_K --strict-json && echo 'top_k set.') || echo 'WARN: top_k not supported, skipping.' && "
REMOTE_COMMANDS+="echo '>>> [4/5] Validating config...' && "
REMOTE_COMMANDS+="$OPENCLAW_CMD config validate && "
REMOTE_COMMANDS+="echo '>>> [5/5] Restarting gateway...' && "
REMOTE_COMMANDS+="$OPENCLAW_CMD gateway restart && "
REMOTE_COMMANDS+="echo 'Tuning applied successfully: scope=$SCOPE_LABEL'"

# Execute the chain
eval $REMOTE_COMMANDS