#!/bin/bash 

if [ $# -ne 2 ] || [ ! -f $1 ] || [ ! -d $2 ]; then
    echo "ERROR - usage: $0 ftriage.conf /ftriage/lib/"
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

self_base="initial_fast_module"
> $OUTDIR/logs/$self_base.log
> $OUTDIR/logs/pids.log

echo "----------"
echo "Running scripts in: $lib"
echo "Using configuration file: $conf"
echo "----------"

script_list=(
             "d_unallocated_foremost.sh"
             "tsk_recover.sh"
             "d_slack_foremost.sh"
             "d_strings.sh"
             "sorter.sh"
             "dlldump.sh"
             "dumpfiles_exe.sh"
             "dumpfiles_dll.sh"
             "m_strings.sh"
             "filescan.sh"
             "timeline.sh"
             )

pids_in=()
pids_out=()
dead=()

# IDEA - add elapsed time tracking for each script.
# IDEA - add PID name tracking for DEAD and FINISHED jobs
# ISSUES - cleanup / kill exited processes
  # NOTE - longer sleep time = bigger window to exit and miss bg procs
  # NOTE - exiting prevents appending new children to pids.log - cleanup at exit
  # IDEA - use `pgrep -P $pid` to find all child procs of that pid
    # NOTE - find additional children of those children until no more are found

for script in "${script_list[@]}"
do
    meta=$(echo $script | cut -f 1 -d ".")
    $lib/$script $conf > $OUTDIR/logs/$meta.log 2>&1 &
    sleep 1
    pids_in+=("$!")
    echo "$!" >> $OUTDIR/logs/pids.log
    echo "PID: $! - JOB: $script - writing to $OUTDIR/logs/$meta.log" | tee -a $OUTDIR/logs/$self_base.log
done

echo "----------" | tee -a $OUTDIR/logs/$self_base.log

while [ ! "${#pids_in[@]}" -eq 0 ]; do
    clear
    head -"${#script_list[@]}" $OUTDIR/logs/$self_base.log
    echo "----------"

    for pid in "${pids_in[@]}"
    do
        if ps -p $pid > /dev/null; then
            pid_command=$(ps -p $pid -o comm=)
            echo "PID: $pid - JOB: $pid_command - RUNNING"
            cpids=$(pgrep -P $pid)
            if [ ! "${#cpids[@]}" -eq 0 ]; then
                for cpid in ${cpids[@]} # "${cpids[@]}" --> error process ID list syntax error + ps usage
                do
                    echo "$cpid" >> $OUTDIR/logs/pids.log # building pids.log perpetually, need logic to check this
                    cname=$(ps -p $cpid -o comm=)
                    echo "PID: $cpid - CHILD: $cname - RUNNING"
                done
            fi
            pids_out+=("$pid")
        fi
    done

    if [ ! "${#dead[@]}" -eq 0 ]; then
        for pid in "${dead[@]}"
        do
            echo "PID: $pid - DEAD"
        done
    fi

    for pid in "${pids_in[@]}"
    do
        if [[ ! "${pids_out[@]}" =~ "${pid}" ]]; then
            echo "PID: $pid - FINISHED"
            dead+=("$pid")
        fi
    done
    
    pids_in=("${pids_out[@]}")
    unset pids_out
    sleep 10
done

