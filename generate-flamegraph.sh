#!/bin/bash
generate_flamegraph() {
#     echo "Flame graph generating...."
    
#     # Run perf and collect data
#     echo "$(pgrep -n node)"
#     pids=$(pgrep -f "node")
#     echo "$pids"
#     sudo perf record -F 99 -p $(pgrep -n node) -g -- sleep 500
    
#     # Generate raw output
#     sudo perf script > perf.out

#     # Clean the raw output
#    sed -i -r \
#   -e "/( __libc_start| LazyCompile | v8::internal::| Builtin:| Stub:| LoadIC:|\[unknown\]| LoadPolymorphicIC:)/d" \
#   -e 's/ LazyCompile:[*~]?/ /' \
#   perf.out
    
#     # Generate flame graph
#     cd FlameGraph
#     ./stackcollapse-perf.pl ../perf.out > ../out.folded
#     ./flamegraph.pl ../out.folded > ../perf-flamegraph.svg
    
#     # Remove previous data
#     rm -rf perf.data
#     rm -rf perf.out
#     echo "Flame graph generated at $(date)...."

#     cd ..

#!/bin/bash

echo "Flame graph generating...."
# rm -rf perf.data perf.out

# Ensure FlameGraph tools are available
if [ ! -d "FlameGraph" ]; then
    git clone https://github.com/brendangregg/FlameGraph.git
fi

# Get all Node.js PIDs managed by pm2
pids=$(pgrep -f "node")
echo "$pids"

# Create a temporary directory for intermediate files
mkdir -p temp_flamegraph

# Record performance data for each PID
for pid in $pids; do
    echo "Profiling PID: $pid"
    
    # Record performance data for each PID
    sudo perf record -F 99 -p $pid -g -- sleep 300
    
    # Generate raw output
    sudo perf script > temp_flamegraph/perf_$pid.out
    
    # Stack collapse and generate folded file
    cd FlameGraph
    ./stackcollapse-perf.pl ../temp_flamegraph/perf_$pid.out > ../temp_flamegraph/out_$pid.folded
    cd ..
    
    echo "Processed PID $pid"
done

# Combine all folded files into one
echo "Merging folded files"
cat temp_flamegraph/*.folded > temp_flamegraph/merged.folded
echo "Merged folded files"
# Generate the final flame graph
echo "Generating final flame graph"
cd FlameGraph
./flamegraph.pl ../temp_flamegraph/merged.folded > ../perf-flamegraph.svg
cd ..

echo "Flame graph generated: perf-flamegraph.svg"

# Clean up temporary files
# rm -rf temp_flamegraph

}

interval=180

while true; do
    generate_flamegraph
    sleep $interval
done


# echo "Flame graph generating...."
    
#     # Run perf and collect data
#     sudo perf record -F 99 -p $(pgrep -n node) -g -- sleep 1000
    
#     # Generate raw output
#     sudo perf script > perf.out

#     # Clean the raw output
#    sed -i -r \
#   -e "/( __libc_start| LazyCompile | v8::internal::| Builtin:| Stub:| LoadIC:|\[unknown\]| LoadPolymorphicIC:)/d" \
#   -e 's/ LazyCompile:[*~]?/ /' \
#   perf.out
    
#     # Generate flame graph
#     cd FlameGraph
#     ./stackcollapse-perf.pl ../perf.out > ../out.folded
#     ./flamegraph.pl ../out.folded > ../perf-flamegraph.svg
    
#     # Remove previous data
#     rm -rf perf.data
#     rm -rf perf.out
#     echo "Flame graph generated at $(date)...."

#     cd ..

