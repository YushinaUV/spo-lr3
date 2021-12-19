

#!/bin/bash
# Script for logging current SNMP information:
# - RX and TX bytes over some network interface

# Log to this file:
LOG_FILE=/var/www/stat/snmp.rrd

# Network interface number:
N=16

# SNMP host
HOST=192.168.222.141

# SNMP community
COMMUNITY=public

# MIBS
MIB1="IF-MIB::ifDescr.$N"
MIB2="IF-MIB::ifInOctets.$N"
MIB3="IF-MIB::ifInUcastPkts.$N"
MIB4="IF-MIB::ifOutOctets.$N"
MIB5="IF-MIB::ifOutUcastPkts.$N"

#############################
# snmp info
RES='N'

for MIB in $MIB2 $MIB3 $MIB4 $MIB5; do
    LINE=`snmpget -c $COMMUNITY -v 1 $HOST $MIB`
    VALUE=`echo "$LINE" | sed "s/^IF-MIB::[[:alnum:]]\+\.$N = [[:alnum:]]\+: //"`
    RES="$RES:$VALUE"
done

# Log all to the file
if [ -f "$LOG_FILE" ]; then
   rrdtool update "$LOG_FILE" "$RES"

else
   # Create file
   rrdtool create "$LOG_FILE" --step 60 \
       DS:ifInOctets:DERIVE:120:0:4294967295 \
       DS:ifInUcastPkts:DERIVE:120:0:4294967295 \
       DS:ifOutOctets:DERIVE:120:0:4294967295 \
       DS:ifOutUcastPkts:DERIVE:120:0:4294967295 \
       RRA:AVERAGE:0.5:1:2880 \
       RRA:AVERAGE:0.5:30:672 \
       RRA:AVERAGE:0.5:120:732 \
       RRA:AVERAGE:0.5:720:1460
fi

#------------------------------------------------------------


