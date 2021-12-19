#!/bin/bash
# CGI script with HTML tables

echo Content-type: text/html
echo ""

LOG_FILE=/var/www/stat/local.log

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
<tr><th>Время</th><th>Число процессов</th><th>Получено, байт</th><th>Передано, байт</th></tr>
END

tail -n $NUM "$LOG_FILE" | sort -r | \
   awk '{sub(/,/,"",$5); print "<tr><td>"$2"</td><td>"$5"</td><td>"$7"</td><td>"$10"</td></tr>"}'

cat <<END
</table>
</body>
</html>
END
#------------------------------------------------------------


