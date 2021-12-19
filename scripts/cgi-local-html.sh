#!/bin/bash
# HTML CGI script

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
<pre>
`tail -n $NUM "$LOG_FILE" | sort -r`
</pre>
</body>
</html>
END
#------------------------------------------------------------
