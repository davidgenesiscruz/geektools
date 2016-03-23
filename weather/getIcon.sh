icon=$(curl -s "http://xml.weather.yahoo.com/forecastrss?p=JAXX0085&u=c" | grep 'src' | cut -d\" -f2)
curl -s "$icon" -o "Users/david.genesis.cruz/tmp/icon.gif"
