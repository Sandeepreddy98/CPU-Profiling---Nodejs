#!/bin/bash

# Input and output file paths
INPUT_FILE="processed.txt"
OUTPUT_FILE="stacks.txt"

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Pattern to match JavaScript function entries
js_function_pattern='JS: '

# Read the processed V8 log line by line
while IFS= read -r line; do
  # Trim leading and trailing whitespace from the line
  line=$(echo "$line" | xargs)

  # If the line contains a JavaScript function (matches the pattern)
  if [[ "$line" == *"$js_function_pattern"* ]]; then
    # Extract the function name and file location
    function_name=$(echo "$line" | awk -F "$js_function_pattern" '{print $2}' | cut -d' ' -f1)
    
    # Add the function to the current stack
    stack+=("$function_name")
  else
    # If we encounter a non-JavaScript line, output the current stack
    if [ ${#stack[@]} -gt 0 ]; then
      # Join the stack with semicolons and write to the output file
      echo "${stack[*]}" | tr ' ' ';' >> "$OUTPUT_FILE"
      # Reset the stack
      stack=()
    fi
  fi
done < "$INPUT_FILE"

# If there's any leftover stack, output it
if [ ${#stack[@]} -gt 0 ]; then
  echo "${stack[*]}" | tr ' ' ';' >> "$OUTPUT_FILE"
fi

# Final output
echo "Stacks have been extracted and written to $OUTPUT_FILE"
