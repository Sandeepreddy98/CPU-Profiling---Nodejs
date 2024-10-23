generate_flamegraph(){
#!/bin/bash

echo "Flame graph generation started..."

# Remove previous data
rm -rf temp_flamegraph perf-flamegraph.svg perf.data

# Ensure FlameGraph tools are available
if [ ! -d "FlameGraph" ]; then
    git clone https://github.com/brendangregg/FlameGraph.git
fi

# Get all Node.js PIDs managed by pm2
pids=$(pgrep -f "node")
echo "Found PIDs: $pids"

# Create a temporary directory for intermediate files
mkdir -p temp_flamegraph

# Record performance data for each PID
# for pid in $pids; do
#     echo "Profiling PID: $pid"
    
#     # Record performance data for each PID
#     sudo perf record -F 99 -p $pid -g -- sleep 10  # Adjust sleep time as needed
    
#     # Generate raw output for the PID and append to the merged file
#     # sudo perf script >> temp_flamegraph/merged.out
#     sudo perf script > temp_flamegraph/perf_$pid.out
    
#     echo "Processed PID $pid"
# done

# echo "Combining all perf files to single perf"
# cd temp_flamegraph
# find . -maxdepth 1 -type f -name "perf_*.out" -print0 | while IFS= read -r -d '' file; do
#     cat "$file" >> merged.out
# done

# Stack collapse the merged output file
# echo "Collapsing merged perf output..."
cd FlameGraph
./stackcollapse-perf.pl ../temp_flamegraph/merged.out > ../temp_flamegraph/merged.folded
cd ..

# Generate the final flame graph
echo "Generating final flame graph..."
cd FlameGraph
./flamegraph.pl ../temp_flamegraph/merged.folded > ../perf-flamegraph.svg
cd ..

echo "Flame graph generated: perf-flamegraph.svg"

}
# generate_flamegraph
# graph(){
#     Stack collapse the merged output file
# echo "Collapsing merged perf output..."
# cd FlameGraph
# ./stackcollapse-perf.pl ../temp_flamegraph/merged.out > ../temp_flamegraph/merged.folded
# cd ..

# # Generate the final flame graph
# echo "Generating final flame graph..."
# cd FlameGraph
# ./flamegraph.pl ../temp_flamegraph/merged.folded > ../perf-flamegraph.svg
# cd ..

# echo "Flame graph generated: perf-flamegraph.svg"
# }
# graph
# interval=30

# while true; do
#     generate_flamegraph
#     sleep $interval
# done