#!/bin/bash
# Script for logging current system status:
# - number of processes
# - RX and TX bytes over ext network interface

# Log to this file:
LOG_FILE=/var/www/stat/local.rrd

# Process number
PROCNUM=`ps aux | wc -l`
PROCNUM=$(($PROCNUM-1))

# netstat info
NETBYTES=`netstat -i | grep '^ext' | awk '{print $4":"$8}'`

# Log all to the file

if [ -f "$LOG_FILE" ]; then
   rrdtool update "$LOG_FILE" N:$PROCNUM:$NETBYTES

else
   # Create file
   rrdtool create "$LOG_FILE" --step 60 \
       DS:procs:GAUGE:120:0:1000 \
       DS:RX:DERIVE:120:0:4294967295 \
       DS:TX:DERIVE:120:0:4294967295 \
       RRA:AVERAGE:0.5:1:2880 \
       RRA:AVERAGE:0.5:30:672 \
       RRA:AVERAGE:0.5:120:732 \
       RRA:AVERAGE:0.5:720:1460
fi

#------------------------------------------------------------


