find . -maxdepth 1 -type f -name "isolate-0x*-v8.log" -print0 | while IFS= read -r -d '' file; do
    # cat "$file" >> merged_v8_logs.log
    rm -rf file
done