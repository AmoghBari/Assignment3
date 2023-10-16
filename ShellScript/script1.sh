#!/bin/bash

# Define the valid options for each input
valid_components=("INGESTOR" "JOINER" "WRANGLER" "VALIDATOR")
valid_scales=("MID" "HIGH" "LOW")
valid_views=("Auction" "Bid")
valid_count_regex='^[0-9]$'  # Regex to match a single digit

# Function to validate user input against valid options
validate_input() {
  local input="$1"
  shift
  local valid_options=("$@")

  for option in "${valid_options[@]}"; do
    if [ "$input" == "$option" ]; then
      return 0  # Valid input
    fi
  done

  return 1  # Invalid input
}

# Main script
read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
read -p "Enter Scale [MID/HIGH/LOW]: " scale
read -p "Enter View [Auction/Bid]: " view
read -p "Enter Count [single digit number]: " count

# Validate user inputs
if ! validate_input "$component" "${valid_components[@]}"; then
  echo "Invalid Component Name. Please choose from the provided options."
  exit 1
fi

if ! validate_input "$scale" "${valid_scales[@]}"; then
  echo "Invalid Scale. Please choose from the provided options."
  exit 1
fi

if ! validate_input "$view" "${valid_views[@]}"; then
  echo "Invalid View. Please choose from the provided options."
  exit 1
fi

if ! [[ $count =~ $valid_count_regex ]]; then
  echo "Invalid Count. Please enter a single digit number."
  exit 1
fi

# Create the new line
new_line="$view ; $scale ; $component ; ETL ; vdopia-etl= $count"

# Use sed to replace the first line in the sig.conf file
sed -i "1s/.*/$new_line/" sig.conf

echo "File updated successfully!"
