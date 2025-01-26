#!/bin/bash

set -e

product_id="sc8-1550-bg-g"
url="https://uk.nps-solovair.com/collections/all/products/${product_id}.js"
file="response.json"

response=$(curl -s "$url")
# response=$(cat "$file")

echo "$response" | jq -r '.variants[] | "\(.title): \(.available)"' > "./results/${product_id}.txt"

if echo "$response" | jq -e '.variants[] | select(.title == "UK 10") | .available' | grep -q 'true'; then
  echo "'UK 10' is available. Exiting."
  exit 111
fi


while IFS= read -r product_id; do
  url="https://uk.nps-solovair.com/collections/all/products/${product_id}.js"
  response=$(curl -s "$url")

  echo "$response" | jq -r '.variants[] | "\(.title): \(.available)"' > "./results/${product_id}.txt"
  sleep 1
done < product_ids.txt