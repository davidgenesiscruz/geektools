path="/Users/david.genesis.cruz/Documents/dev/geektools/weather/"
url="http://xml.weather.yahoo.com/forecastrss?p=JAXX0085&u=c"
filename="icon.gif"

icon=$(curl -s "$url" | grep 'src' | cut -d\" -f2)
curl -s "$icon" -o "$path$filename"
