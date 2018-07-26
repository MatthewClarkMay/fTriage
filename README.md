Scripts I threw together for quickly gathering forensic artifacts from suspect memory/disk image(s), carving, etc.

### Setup
1. Download NSRL hashlist if you will not be providing your own via baseline build + md5deep
```
cd /opt/ftriage/lists/nsrl/
./pull.sh
unzip rds_modernm.zip
./build_nsrl_idx.sh
```
2. edit /ftriage/conf/ftriage.conf and make sure all variables have been filled in.
3. run scripts individually, or prebuilt modules.

### Recommended Usage
```
./ftriage/modules/ftriage.sh ./ftriage/conf/ftriage.conf ./ftriage/modules/scriptlists/bulk.conf
```

Suite is still under development, but coming along quickly!
