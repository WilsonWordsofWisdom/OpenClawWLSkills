#!/bin/bash
# get_shortlist.sh - Fetches a curated list of cost-effective/popular models from OpenRouter

# Fetch models from OpenRouter API
MODELS_JSON=$(curl -s https://openrouter.ai/api/v1/models)

if [ -z "$MODELS_JSON" ]; then
    echo "Error: Could not fetch models from OpenRouter API."
    exit 1
fi

echo "### 🚀 OpenRouter Recommended Models"
echo "| Model ID | Input Cost (1M) | Output Cost (1M) | Category |"
echo "| :--- | :--- | :--- | :--- |"

# 2. Filter for high-quality providers and construct the routable OpenRouter ID
# We use jq to extract the ID and pricing, then prepend 'openrouter/' 
# because that is the required identifier for the OpenClaw routing layer.
echo "$MODELS_JSON" | jq -r '.data[] | select(.id | test("openai|anthropic|google|meta")) | ["openrouter/" + .id, .pricing.prompt, .pricing.completion] | @tsv' | \
sort -k2 -n | \
while IFS=$'\t' read -r id prompt completion; do
    
    # 3. Categorize based on price using awk (more portable than bc)
    CATEGORY=$(awk -v p="$prompt" 'BEGIN {
        if (p < 0.5) print "Budget/Flash";
        else if (p > 5.0) print "Frontier/Pro";
        else print "Standard";
    }')
    
    printf "| %s | \$%s | \$%s | %s |\n" "$id" "$prompt" "$completion" "$CATEGORY"
done