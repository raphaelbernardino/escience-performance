#!/bin/bash
log_delay=1

process_ps()
{
    ## resident memory, %cpu, cpu total time, elapsed time, number of threads, process id, arguments
    #ps -p $1 -o rss,%cpu,cputime,etime,nlwp,pid,args | grep -w $1 | awk '{printf $1/1024; $1=""; print }' | tr '\n' ' '
    ps -eo rss,%cpu,cputime,etime,nlwp,pid,args:100 --sort=%mem,-pid | grep -v grep | grep -w $1 | awk '{f1+=$1/1024;f2+=$2;} END{print f1" "$2" "$3" "$4" "$5}' | tr '\n' ' '
}

process_io()
{
    # rchar, wchar, syscr, syscw, read_bytes, write_bytes, cancelled_write_bytes
    cat /proc/$1/io | awk 'NR>=3&&NR<=6 { print $2; }' | tr '\n' ' '
}

execute_sumatra()
{
    s_name=$1
    # starting process
    smt run --executable=python --main="$s_name" >/dev/null &
    s_pid=$!
    start_time=$(date +%s)
    
    # process started
    echo -e "[+] $s_name is running with process id $s_pid"
    
    # print header
    echo -e "## execution_time, syscr, syscw, read_bytes, write_bytes, resident memory, %cpu, cpu total time, elapsed time, number of threads, process id, arguments"
    
    # process still running
    while [ -e "/proc/$s_pid" ]; do
        elapsed_time=$(( $(date +%s) - $start_time ))
        #echo -e -n "\r[-] running for $elapsed_time seconds..."
        
        echo -n "$elapsed_time "
        process_io $s_pid
        process_ps $s_name
        echo -en "\n"
        
        sleep $log_delay
    done
    
    # process finished
    #echo -e "\n[+] process finished."
}

plot()
{
    log_path=$1
    ptitle=$2
    echo $(pwd)
    
    gnuplot -e "log_name='$log_path.txt'; tname='$ptitle PS'" "./plot-ps.gpl" > "$log_path.ps.svg"
    gnuplot -e "log_name='$log_path.txt'; tname='$ptitle IO'" "./plot-io.gpl" > "$log_path.io.svg"
}

test_script()
{
    curr_directory=$(pwd)
    script_directory=$1
    python_script=$2
    base_log=$3
    script_name=$4
    repeat_test=$5
    #cd "$1"
    mkdir -p $base_log
    
    for i in $(seq 1 $repeat_test); do
        timestamp=$(date +%s)
        dest_log="$base_log/$timestamp"
        
        execute_sumatra "$script_directory/$python_script" >> "$dest_log.txt"
        plot $dest_log $script_name
    done
    
    cd "$curr_directory" 
}

cd "scripts/sumatra-test"
test_script "./example/" "test.py" "logs/test_py/" "test" 100
test_script "./rho/" "test.py" "logs/rho_py/" "rho" 100
test_script "./criminal-gan-faces/" "gan.py" "./logs/gan_py/" "GAN faces" 100

