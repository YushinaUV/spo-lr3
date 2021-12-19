#!/bin/bash
# CGI script for SNMP statistic, with HTML tables

echo Content-type: text/html
echo ""

LOG_FILE=/var/www/stat/snmp.log

# Show NUM lines
if [ -n "$QUERY_STRING" ]; then
    NUM=$QUERY_STRING
else
    if [ -n "$1" ]; then
        NUM=$1
    else
	NUM=10
    fi
fi

test "$NUM" -le 0 2>/dev/null
[ $? -eq 1 ] || NUM=10

cat <<END
<html>
<head>
<title>Current statistic</title>
<meta http-equiv="Refresh" content="60">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Cache-Control" content="no-cache">
</head>
<body>
<h2>Текущая статистика:</h2>
<table border="1">
<tr><th rowspan=2>Время</th><th colspan=2>Получено</th><th colspan=2>Передано</th></tr>
<tr><th>пакетов</th><th>байт</th><th>пакетов</th><th>байт</th></tr>
END

tail -n $NUM "$LOG_FILE" | sort -r | \
   sed -e 's/if\(In\|Out\)Octets://g' | sed -e 's/if\(In\|Out\)UcastPkts://g' | \
   awk '{print "<tr><td>"$2"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$8"</td></tr>"}'

cat <<END
</table>
</body>
</html>
END

#------------------------------------------------------------


