Automating forensic artifact extraction, reduction, and analysis.  

fTriage leverages dozens of popular, open source tools to triage suspect memory/disk images. Each module automates a step in the investigation an analyst would otherwise perform manually. Moreover, I've written a wrapper (ftriage.sh) to execute collections of these modules. There is no limit to how many modules you can run at once, but naturally there are some that need to be run before others, review the "Recommended Usage" section for example usage of prebuilt modlists.

## Setup:
1. Install dependencies:
```
sudo ./dependencies.sh
```
2. Download NSRL hashlist if you will not be providing your own via baseline build + md5deep:
```
cd ./conf/nsrl/
./pull.sh
unzip rds_modernm.zip
./build_nsrl_idx.sh
```
3. Edit ./conf/ftriage.conf and make sure all variables have been filled in.
4. Run modules individually, or in batches using ftriage.sh with modlists.
5. (OPTIONAL) Download 3rd party tools - These tools aren't yet integrated with fTriage, but they will be eventually and the scripts are nice shortcuts so we don't need to browse to the download site(s):
```
#NOTE: pescan requires a license from tzworks, you can request one by emailing "info@tzworks.net" or filling out the "demo" form at "https://www.tzworks.net/store/product_page.php"

cd ./3rd_party/
./wget_pescan.sh
./wget_autoruns.sh
./wget_sigcheck.sh
cp ~/<license> ./3rd_party/pescan*-*
```  

## Recommended Usage:
```
#NOTE: Each bulk acquisition will probably generate 30-80GB content, keep that in mind
#NOTE: Probably going to wrap all this into one script, but I think this helps visualize the process.

./ftriage.sh ./conf/ftriage.conf ./modlists/bulk.conf &&
./modules/analysis/reduce_carved_files.sh ./conf/ftriage.conf &&
./ftriage.sh ./conf/ftriage.conf ./modlists/process_reduced_files.conf &&
./modules/analysis/analyze_density_results.sh ./conf/ftriage.conf
```

## ftriage.sh (wrapper for running an array of modules \& scripts):
- **ftriage.sh:** Wrapper for running modules \& scripts in the background and monitoring status. Logs can be found in the $OUTDIR/logs/ directory.

## Modules (targeted scripts):
### Disk:
- **image_export.sh:** Runs image_export.py against the disk with a filter file native to the SIFT Workstation. Great initial triage script because it quickly collects key forensic artifacts from a disk image (VSS too) and organizes them neatly. An analyst can start analyzing these forensic artifacts while the more time consuming scripts run (sorter.sh for example can take 30 minutes to several hours depending on hardware).  
- **sorter.sh:** Runs sorter against the disk with a filter file native to the SIFT Workstation. Accepts an indexed hash white list, usually NSRL or md5deep of baseline.
- **tsk_recover.sh:** Runs tsk_recover to carve files out of unallocated space.  
- **d_unallocated_foremost.sh:** Uses blkls to dump and redirect all unallocated space into a file, then runs foremost against the blkls unallocated file. Also outputs a snippit from the audit results.  
- **d_slack_foremost.sh:** Uses blkls to dump and redirect all slack space into a file, then runs foremost against the blkls slack file. Also outputs a snippit from the audit results.  
- **d_strings.sh:** Runs strings against the disk image and sorts the output.  
- **d_timeline.sh:** Builds unfiltered and filtered filesystem timelines using fls, mactime, and grep.
- **supertimeline.sh:** Builds a SuperTimeline using log2timeline.py, psort.py, and grep.
### Memory:
- **imageinfo.sh:** Runs the Volatility imageinfo command - usually used in initial setup stages to determine our memory $PROFILE variable.  
- **malprocfind.sh:** Runs the Volatility malprocfind plugin - Finds malicious processes based on discrepancies from observed, normal behavior and properties. This plugin automates several manual checks performed on every memory image when looking for malware including expected PPID, name permutations, expected path, priority, expected cmdline args, proper user SID, session, time after boot, cmd.exe parent, missing binaries, and abnormal paths.
- **malfind.sh:** Runs the Volatility malfind plugin (looks for code injection), parses output, and dumps suspect memory sections to disk.
- **ldrmodules.sh:** Runs the Volatility ldrmodules plugin, and parses output. DLLs are tracked in three separate linked lists for each process. Some malware attempts to unlink loaded DLLs from these lists in order to evade detection. This plugin scans all process memory sections for DLLs, then parses each list and compares results to find unlinked DLLs.
- **hollowfind.sh:** Runs the volatility hollowfind plugin, and dumps suspect memory sections to disk. The plugin detects such attacks by finding discrepancy in the VAD and PEB, it also disassembles the address of entry point to detect any redirection attempts and also reports any suspicious memory regions which should help in detecting any injected code. Prime example of this technique was Stuxnet; if you analyze a sample memory image of a Stuxnet infected machine you will notice multiple lsass.exe processes, but there should only ever be one lsass.exe process running at a time. The malware started extra legitimate lsass.exe processes in a suspended state, hollowed them out, injected the malicious code, then resumed the process. Great writeup [here](https://cysinfo.com/detecting-deceptive-hollowing-techniques).
- **dlllist.sh:** Runs the Volatility dlllist plugin. This output is derived from processes tracked in the Process Environment Block (PEB), so injected and unlinked DLLs will not be detected. Unlinked DLLs can be detected using ldrmodules.sh
- **cmdline.sh:** Runs the Volatility cmdline plugin, a simple plugin designed to list command line args passed for each running process.
- **dlldump.sh:** Runs the Volatility dlldump plugin. 
- **dumpfiles_dll.sh:** Runs the Volatility dumpfiles command searching for .dll files via regex.  
- **dumpfiles_exe.sh:** Runs the Volatility dumpfiles command searching for .exe files via regex.   
- **m_strings.sh:** Runs strings against the memory image and sorts the output. Also runs the Volatility strings command to enrich our output with process info and virtual addresses.  
- **filescan.sh:** Runs the Volatility filescan command and saves the output in a file.  
- **m_timeline.sh:** Builds unfiltered and filtered timelines using the Volatility timeliner command, mactime, and grep.
### Hybrid:
- **h_timeline.sh:** Builds unfiltered and filtered combined filesystem/memory timelines using the Volatility timeliner command, fls, mactime, and grep.  
### Analysis:
- **reduce_carved_files.sh:** Moves all carved files from their respective carving output directories into a common directory. 
- **hash_carved_files.sh:** Builds md5 hash lists of carved files in $OUTDIR.  
- **densityscout.sh:** Runs densityscout against all carved + reduced EXEs/DLLs, and against image_export/Windows and image_export/Users  
- **analyze_density_results.sh:** Parses output from densityscout.sh, sorter.sh, d_unallocated_foremost.sh, d_slack_foremost.sh, dlldump.sh, dumpfiles_dll.sh, and dumpfiles_exe.sh. Copies carved files with high density to $OUTDIR/carving/high_density_exes/ with original filename appended.
### Custom:
- Where user supplied modules should be placed

## Devtools:
- **mount_host_shares.sh:** Creates /root/host_shares directory, then mounts all VMware shared folders from host.
- **nuke.sh:** Script I use to remove various output directories during development.
- **pkiller.sh:** Used by ftriage.sh to cleanup background jobs.
- **rm_extra.sh:** Removes excess output files that usually are unnecessary after initial triage.

## Notes:
- Autoruns.exe \& autorunsc.exe usage and references at [my blog](https://bytehacks.com/2018-07-02-CMD-Cheat-Sheet/#autoruns) 

Suite is still under development, but coming along quickly!
