generate_v8_profiling(){
    for i in {1..20} # Adjust the number of iterations as needed
do
    echo "-----------------Hitting CPU endpoint---------------"
    ab -k -c 20 -n 20 "http://localhost:3000/cpu"
    sleep 3
    
    echo "-----------------Hitting Memory endpoint------------"
    ab -k -c 20 -n 200 "http://localhost:3000/memory"
    sleep 3
    # echo "------------------Hitting callbacks-----------------"
    # ab -k -c 10 -n 10 "http://localhost:3000/callbacks"
    # sleep 3
    
    # echo "------------------Hitting promises------------------"
    # ab -k -c 10 -n 10 "http://localhost:3000/promise"

    # echo "Processing profile data"
    # node --prof-process $(find . -maxdepth 1 -type f -name "isolate-*" | sort | head -n 1) > processed.txt
#     for file in $(find . -maxdepth 1 -type f -name "isolate-*"); do
#   node --prof-process "$file" >> processed.txt

# cat $(find . -maxdepth 1 -type f -name "isolate-*") > combined-isolate.txt

# echo "Cleaning up isolate files"
# rm combined-isolate.txt
# rm $(find . -maxdepth 1 -type f -name "isolate-*")

done
#     ab -k -c 20 -n 50 "http://localhost:3000/cpu"
# sleep 30
# ab -k -c 20 -n 50 "http://localhost:3000/memory"
# node --prof-process $(find . -maxdepth 1 -type f -name "isolate-*" | head -n 1) > processed.txt
# rm -rf $(find . -maxdepth 1 -type f -name "isolate-*" | head -n 1)
}
generate_v8_profiling
interval=200

# while true; do
#     generate_v8_profiling
#     sleep $interval
# done