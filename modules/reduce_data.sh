#!/bin/bash 

# Author:
# Matt May <mcmay.web@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a
# copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

if [ $# -ne 1 ] || [ ! -f $1 ]; then # || [ ! -d $2 ]; then
    echo "ERROR - usage: $0 ftriage.conf" #/ftriage/lib/"
    exit 1
else
    source $1
fi

conf=$(realpath $1)
lib=$(realpath "$FTRIAGE/lib")
#lib=$(realpath $2)

function secs_to_mins() {
    num=$1
    min=0
    hour=0
    day=0
    if((num>59));then
        ((sec=num%60))
        ((num=num/60))
        if((num>59));then
            ((min=num%60))
            ((num=num/60))
            if((num>23));then
                ((hour=num%24))
                ((day=num/24))
            else
                ((hour=num))
            fi
        else
            ((min=num))
        fi
    else
        ((sec=num))
    fi
    echo "$day"d "$hour"h "$min"m "$sec"s
}

if [ ! -d "$OUTDIR/logs" ]; then
    mkdir -p $OUTDIR/logs
    echo "Directory $OUTDIR/logs/ does not exist - creating now..."
else
    echo "Directory $OUTDIR/logs/ already exists - moving on..."
fi

self_base="initial_fast_module"
> $OUTDIR/logs/$self_base.log
> $OUTDIR/logs/pids.log

trap cleanup SIGINT SIGQUIT SIGHUP
function cleanup() {
    echo ""
    echo "----------"
    echo "** Trapped Interrupt **"
    echo "** Cleaning up jobs **"
    echo "----------"
    $FTRIAGE/devtools/pkiller.sh $OUTDIR/logs/pids.log | tee -a $OUTDIR/logs/$self_base.log
    exit 1
}

echo "----------"
echo "Running scripts in: $lib"
echo "Using configuration file: $conf"
echo "----------"

script_list=(
            "reduce_carved_files.sh"
            "hash_carved_files.sh"
            )

# IDEA - use screen to start processes so fg works
# IDEA - add PID name tracking for DEAD and FINISHED jobs
# ISSUES - cleanup / kill exited processes
  # NOTE - longer sleep time = bigger window to exit and miss bg procs
  # IDEA - use `pgrep -P $pid` to find all child procs of that pid
    # NOTE - find additional children of those children until no more are found

pids_in=()
pids_out=()
dead=()
start_time="$(date -u +%s)"

for script in "${script_list[@]}"
do
    meta=$(echo $script | cut -f 1 -d ".")
    $lib/$script $conf > $OUTDIR/logs/$meta.log 2>&1 &
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
                    if ! grep $cpid $OUTDIR/logs/pids.log > /dev/null; then
                        echo $cpid >> $OUTDIR/logs/pids.log
                        cname=$(ps -p $cpid -o comm=)
                        echo "PID: $cpid - CHILD: $cname - RUNNING"
                    else
                        cname=$(ps -p $cpid -o comm=)
                        echo "PID: $cpid - CHILD: $cname - RUNNING"
                    fi
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

    end_time="$(date -u +%s)"
    elapsed_seconds=$((end_time - start_time))
    elapsed_minutes=$(secs_to_mins "$elapsed_seconds")
    echo "----------"
    echo "ELAPSED TIME: $elapsed_minutes"

    sleep 7
done

