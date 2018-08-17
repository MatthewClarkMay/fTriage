Automating forensic artifact extraction, reduction, and analysis.  

fTriage leverages dozens of popular, open source tools to triage suspect memory/disk images. Each script automates a step in the investigation an analyst would otherwise perform manually. Moreover, I've written a wrapper to execute collections of data acquisition scripts. There is no limit to how many scripts you can run at once, but naturally there are some that need to be run before others, review the "Recommended Usage" section for example usage of prebuilt script lists.

### Setup
1. Install dependencies:
```
sudo ./ftriage/dependencies.sh
```
2. Download NSRL hashlist if you will not be providing your own via baseline build + md5deep:
```
cd /ftriage/lists/nsrl/
./pull.sh
unzip rds_modernm.zip
./build_nsrl_idx.sh
```
3. Download 3rd party tools - These tools aren't yet integrated with fTriage, but they will be eventually and the scripts are nice shortcuts so we don't need to browse to the download site(s):
```
#NOTE: pescan requires a license from tzworks, you can request one by emailing "info@tzworks.net" or filling out the "demo" form at "https://www.tzworks.net/store/product_page.php"

cd /ftriage/3rd_party/
./wget_pescan.sh
./wget_autoruns.sh
./wget_sigcheck.sh
cp ~/<license> /ftriage/3rd_party/pescan*-*
```  
3. edit /ftriage/conf/ftriage.conf and make sure all variables have been filled in.
4. run scripts individually, or prebuilt modules.

### Recommended Usage
```
#NOTE: each bulk acquisition will probably generate 30-80GB content, keep that in mind
#NOTE: probably going to wrap all this into one script, but I think this helps visualize the process.

./ftriage/modules/ftriage.sh ./ftriage/conf/ftriage.conf ./ftriage/modules/scriptlists/bulk.conf &&
./ftriage/lib/reduce_carved_files.sh ./ftriage/conf/ftriage.conf &&
./ftriage/modules/ftriage.sh ./ftriage/conf/ftriage.conf ./ftriage/modules/scriptlists/process_reduced_files.conf &&
./ftriage/lib/analyze_density_results.sh ./ftriage/conf/ftriage.conf
```

### lib (targeted scripts)
- **imageinfo.sh:** Runs the Volatility imageinfo command - usually used in initial setup stages to determine our memory $PROFILE variable.  
- **image_export.sh:** Runs image_export.py against the disk with a filter file native to the SIFT Workstation. Great initial triage script because it quickly collects key forensic artifacts from a disk image (VSS too) and organizes them neatly. An analyst can start analyzing these forensic artifacts while the more time consuming scripts run (sorter.sh for example can take 30 minutes to several hours depending on hardware).  
- **sorter.sh:** Runs sorter against the disk with a filter file native to the SIFT Workstation. Accepts an indexed hash white list, usually NSRL or md5deep of baseline.
- **tsk_recover.sh:** Runs tsk_recover to carve files out of unallocated space.  
- **d_unallocated_foremost.sh:** Uses blkls to dump and redirect all unallocated space into a file, then runs foremost against the blkls unallocated file. Also outputs a snippit from the audit results.  
- **d_slack_foremost.sh:** Uses blkls to dump and redirect all slack space into a file, then runs foremost against the blkls slack file. Also outputs a snippit from the audit results.  
- **dlldump.sh:** Runs the Volatility dlldump command.  
- **dumpfiles_dll.sh:** Runs the Volatility dumpfiles command searching for .dll files via regex.  
- **dumpfiles_exe.sh:** Runs the Volatility dumpfiles command searching for .exe files via regex.   
- **d_strings.sh:** Runs strings against the disk image and sorts the output.  
- **m_strings.sh:** Runs strings against the memory image and sorts the output. Also runs the Volatility strings command to enrich our output with process info and virtual addresses.  
- **filescan:** Runs the Volatility filescan command and saves the output in a file.  
- **hash_carved_files.sh:** Builds md5 hash lists of carved files in $OUTDIR.  
- **reduce_carved_files.sh:** Moves all carved files from their respective carving output directories into a common directory. 
- **timeline.sh:** Builds a filesystem and memory timeline using the Volatility timeliner command, fls, mactime, and grep.  
- **supertimeline.sh:** Builds a SuperTimeline using log2timeline.py, psort.py, and grep.
- **densityscout.sh:** Runs densityscout against all carved + reduced EXEs/DLLs, and against image_export/Windows and image_export/Users  
- **analyze_density_results.sh:** Parses output from densityscout.sh, sorter.sh, d_unallocated_foremost.sh, d_slack_foremost.sh, dlldump.sh, dumpfiles_dll.sh, and dumpfiles_exe.sh. Copies carved files with high density to $OUTDIR/carving/high_density_exes/ with original filename appended.


### modules (wrapper for running an array of scripts)
- **ftriage.sh:** Wrapper for running scripts in the background and monitoring status. Logs can be found in the $OUTDIR/logs/ directory.

### devtools
- **mount_host_shares.sh:** Creates /root/host_shares directory, then mounts all VMware shared folders from host.
- **nuke.sh:** Script I use to remove various output directories during development.
- **pkiller.sh:** Used by ftriage.sh to cleanup background scripts.
- **rm_extra.sh:** Removes excess output files that usually are unnecessary after initial triage.

### Notes
- Autoruns.exe \& autorunsc.exe usage and references at [my blog](https://bytehacks.com/2018-07-02-CMD-Cheat-Sheet/#autoruns) 

Suite is still under development, but coming along quickly!
