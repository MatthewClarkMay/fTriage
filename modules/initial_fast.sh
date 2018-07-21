#!/bin/bash 

conf="/opt/ftriage/conf/ftriage.conf"
lib="/opt/ftriage/lib"

if [ -f "$conf" ]; then
    source $conf
else
    echo "$conf missing - exiting..."
    exit 1
fi

script_list=("d_unallocated_filecarve.sh"
             "d_slack_filecarve.sh"
             "d_strings.sh"
             "sorter.sh"
             "m_filecarve.sh"
             "m_strings.sh"
             "filescan.sh"
             "timeline.sh")

for script in "${script_list[@]}"
do
    gnome-terminal -e "$lib/$script $conf"
    sleep 1
    echo $script
done


