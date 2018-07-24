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

self_base="initial_fast_module"
> $OUTDIR/logs/$self_base.log
> $OUTDIR/logs/job_pids.log

echo "----------"
echo "Running scripts in: $lib"
echo "Using configuration file: $conf"
echo "----------"

pids_in=()
pids_out=()
dead=()

script_list=(
             "d_unallocated_filecarve.sh"
             "tsk_recover.sh"
             "d_slack_filecarve.sh"
             "d_strings.sh"
             "sorter.sh"
             "dlldump.sh"
             "dumpfiles_exe.sh"
             "dumpfiles_dll.sh"
             "m_strings.sh"
             "filescan.sh"
             "timeline.sh"
             )

# IDEA - add elapsed time tracking for each script.
# IDEA - add PID name tracking for DEAD and FINISHED jobs
# ISSUES - cleanup / kill exited processes
  # IDEA - use `pgrep -P $pid` to find all child processes of that pid
    # NOTE - find additional children of those children until no more are found

for script in "${script_list[@]}"
do
    meta=$(echo $script | cut -f 1 -d '.')
    $lib/$script $conf > $OUTDIR/logs/$meta.log 2>&1 &
    sleep 1
    pids_in+=("$!")
    echo "$!" >> $OUTDIR/logs/pids.log
    echo "JOB: $script - PID $! - writing to $OUTDIR/logs/$meta.log" | tee -a $OUTDIR/logs/$self_base.log
done

echo "----------" | tee -a $OUTDIR/logs/$self_base.log

while [ ! ${#pids_in[@]} -eq 0 ]; do
    clear
    head -${#script_list[@]} $OUTDIR/logs/$self_base.log | tee -a $OUTDIR/logs/$self_base.log
    echo "----------" | tee -a $OUTDIR/logs/$self_base.log

    for pid in "${pids_in[@]}"
    do
        if ps -p $pid > /dev/null; then
            pid_name=$(ps -p $pid -o comm=)
            echo "PID: $pid - JOB: $pid_name - RUNNING" | tee -a $OUTDIR/logs/$self_base.log
            cpids=$(pgrep -P $pid)
            if [ ! "${#cpids[@]}" -eq 0 ]; then
                for cpid in ${cpids[@]}
                do
                    echo "$cpid" >> $OUTDIR/logs/pids.log
                    cname=$(ps -p $cpid -o comm=)
                    echo "PID: $cpid - CHILD: $cname - RUNNING" | tee -a $OUTDIR/logs/$self_base.log
                done
            fi
            pids_out+=("$pid")
        fi
    done

    if [ ! ${#dead[@]} -eq 0 ]; then
        for pid in ${dead[@]}
        do
            echo "PID: $pid - DEAD" | tee -a $OUTDIR/logs/$self_base.log
        done
    fi

    for pid in ${pids_in[@]}
    do
        if [[ ! "${pids_out[@]}" =~ "${pid}" ]]; then
            echo "PID: $pid - FINISHED" | tee -a $OUTDIR/logs/$self_base.log
            dead+=("$pid")
        fi
    done
    
    pids_in=("${pids_out[@]}")
    unset pids_out
    echo "----------" >> $OUTDIR/logs/$self_base.log
    sleep 10
done

