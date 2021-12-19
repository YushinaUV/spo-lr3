#!/bin/bash
# Output script in HTML

echo Content-type: text/html
echo ""

# Show NUM lines
if [ -n "$QUERY_STRING" ]; then
    FNAME=$QUERY_STRING
else
    if [ -n "$1" ]; then
        FNAME=$1
    else
        FNAME=$0
    fi
fi

cat <<END
<html>
<head>
<title>Script $FNAME</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Cache-Control" content="no-cache">
</head>
<body>
<h2>Код скрипта $FNAME</h2>
<hr/>
<pre>
END
if echo "$FNAME" | egrep -q '^(\.\./\.\./bin/|(\.\./)?[0-9a-z-]+\.(sh|rrd|html))'; then
  cat "$FNAME" | \
    sed -e 's/&/\&amp;/g' | \
    sed -e 's/</\&lt;/g' | \
    sed -e 's/>/\&gt;/g'
else
   echo "$FNAME ??"
fi
cat <<END
</pre>
<hr/>
</body>
</html>
END
#------------------------------------------------------------
