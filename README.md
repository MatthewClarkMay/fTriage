My attempt at automating forensic artifact acquisition, reduction, and analysis.  

fTriage leverages dozens of popular, open source tools to triage suspect memory/disk image(s). Each script automates a step in the investigation an analyst would otherwise perform manually. Moreover, I've written a wrapper to execute collections of data acquisition scripts. There is no limit to how many scripts you can run at once, but naturally there are some that need to be run before others, review the "Recommended Usage" section for example usage of prebuilt script lists.

### Setup
1. Install dependencies:
```
sudo ./ftriage/dependencies.sh
```
2. Download NSRL hashlist if you will not be providing your own via baseline build + md5deep.
```
cd /opt/ftriage/lists/nsrl/
./pull.sh
unzip rds_modernm.zip
./build_nsrl_idx.sh
```
3. edit /ftriage/conf/ftriage.conf and make sure all variables have been filled in.
4. run scripts individually, or prebuilt modules.

### Recommended Usage
```
./ftriage/modules/ftriage.sh ./ftriage/conf/ftriage.conf ./ftriage/modules/scriptlists/bulk.conf
```

### lib (targeted scripts)
- dlldump.sh: Runs the Volatility dlldump command.  
- d_slack_foremost.sh: Uses blkls to dump and redirect all slack space into a file, then runs foremost against the blkls slack file. Also outputs a snippit from the audit results.  
- d_strings.sh: Runs strings against the disk image and sorts the output.  
- dumpfiles_dll.sh: Runs the Volatility dumpfiles command searching for .dll files via regex.  
- dumpfiles_exe.sh: Runs the Volatility dumpfiles command searching for .exe files via regex.   
- d_unallocated_foremost.sh: Uses blkls to dump and redirect all unallocated space into a file, then runs foremost against the blkls unallocated file. Also outputs a snippit from the audit results.  
- filescan: Runs the Volatility filescan command and saves the output in a file.  
- hash_carved_files.sh: Builds md5 hash lists of carved files in $OUTDIR.  
- imageinfo.sh: Runs the Volatility imageinfo command - usually used in initial setup stages to determine our memory $PROFILE variable.  
- m_filecarve.sh: Basically runs dlldump.sh, dumpfiles_dll.sh, and dumpfiles_exe.sh inline (not as seperate processes in the background). This was split this into individual scripts so they could each be run separately and backgrounded by the wrapper.  
- m_strings.sh: Runs strings against the memory image and sorts the output. Also runs the Volatility strings command to enrich our output with process info and virtual addresses.  
- reduce_carved_files.sh: Moves all carved files from their respective carving output directories into a common directory. 
- sorter.sh: Runs sorter against the disk with a the SIFT config file. Accepts an indexed hash white list (usually NSRL or md5deep of baseline.  
- supertimeline.sh: Builds a SuperTimeline using log2timeline.py, psort.py, and grep.
- timeline.sh: Builds a filesystem and memory timeline using the Volatility timeliner command, fls, mactime, and grep.  
- tsk_recover: Runs tsk_recover to carve files out of unallocated space.  

Most (if not all) of these scripts produce logs in some form or another - these can be found in the $OUTDIR/logs/ directory.

### modules (wrapper for running an array of scripts)
- ftriage.sh: Wrapper for running scripts in the background and monitoring status.

Suite is still under development, but coming along quickly!
