#!/bin/bash
# get_shortlist.sh - Fetches a curated list of cost-effective/popular models from OpenRouter

# Fetch models from OpenRouter API
MODELS_JSON=$(curl -s https://openrouter.ai/api/v1/models)

if [ -z "$MODELS_JSON" ]; then
    echo "Error: Could not fetch models from OpenRouter."
    exit 1
fi

# Use jq to filter for popular providers and sort by cost (Input price)
echo "### 🚀 OpenRouter Recommended Models"
echo "| Model ID | Input Cost (1M) | Output Cost (1M) | Category |"
echo "| :--- | :--- | :--- | :--- |"

echo "$MODELS_JSON" | jq -r '.data[] | select(.id | test("openai|anthropic|google|meta")) | [.id, .pricing.prompt, .pricing.completion] | @tsv' | \
sort -k2 -n | \
while IFS=$'\t' read -r id prompt completion; do
    # Categorize based on price
    CATEGORY="Standard"
    if (( $(echo "$prompt < 0.5" | bc -l) )); then CATEGORY="Budget/Flash"; fi
    if (( $(echo "$prompt > 5.0" | bc -l) )); then CATEGORY="Frontier/Pro"; fi
    
    printf "| %s | \$%s | \$%s | %s |\n" "$id" "$prompt" "$completion" "$CATEGORY"
done