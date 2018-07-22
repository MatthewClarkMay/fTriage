#!/bin/bash 

if [ $# -ne 2 ] || [ ! -f $1 ] || [ ! -d $2 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf /path/to/ftriage/lib"
    exit 1
else
    source $1
fi

conf=$(realpath $1)
lib=$(realpath $2)

if [ ! -d "$OUTDIR/logs" ]; then
    mkdir -p $OUTDIR/logs
    echo "Directory $OUTDIR/logs/ does not exist - creating now..."
else
    echo "Directory $OUTDIR/logs/ already exists - moving on..."
fi

> $OUTDIR/logs/session.log

echo "----------"
echo "Running scripts in: $lib"
echo "Using configuration file: $conf"
echo "----------"

pids_in=()
pids_out=()
dead=()

script_list=(
             "d_unallocated_filecarve.sh"
             "d_slack_filecarve.sh"
             "d_strings.sh"
             "sorter.sh"
             "m_filecarve.sh"
             "m_strings.sh"
             "filescan.sh"
             "timeline.sh"
             )

for script in "${script_list[@]}"
do
    meta=$(echo $script | cut -f 1 -d '.')
    $lib/$script $conf > $OUTDIR/logs/$meta.log 2>&1 &
    sleep 1
    pids_in+=("$!")
    echo "JOB: $script - PID $! - writing to $OUTDIR/logs/$meta.log" | tee -a $OUTDIR/logs/session.log
done

echo "----------" | tee -a $OUTDIR/logs/session.log

while [ ! ${#pids_in[@]} -eq 0 ]; do
    clear
    head -${#script_list[@]} $OUTDIR/logs/session.log | tee -a $OUTDIR/logs/session.log
    echo "----------" | tee -a $OUTDIR/logs/session.log

    for pid in ${pids_in[@]}
    do
        if ps -p "$pid" > /dev/null; then
            pid_name=$(ps -p $pid -o comm=)
            echo "JOB: $pid_name - PID: $pid - RUNNING" | tee -a $OUTDIR/logs/session.log
            pids_out+=("$pid")
        fi
    done

    if [ ! ${#dead[@]} -eq 0 ]; then
        for pid in ${dead[@]}
        do
            echo "PID: $pid - DEAD" | tee -a $OUTDIR/logs/session.log
        done
    fi

    for pid in ${pids_in[@]}
    do
        #echo $pid
        if [[ ! " ${pids_out[@]} " =~ " ${pid} " ]]; then
        #    #echo "JOB: $pid_name - PID: $pid - FINISHED"
            echo "PID: $pid - FINISHED" | tee -a $OUTDIR/logs/session.log
            dead+=("$pid")
        fi
    done
    
    pids_in=("${pids_out[@]}")
    unset pids_out
    echo "----------" >> $OUTDIR/logs/session.log
    sleep 5
done
