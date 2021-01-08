#!/bin/sh

# script for OpenWRT AP:
# weather as an SSID
# (does not update the SSID in case of active client connection)
#
# change the phy0 interface accordingly to your setup
# change the location and eventually output format (see https://github.com/chubin/wttr.in)
#
# add this script to the crontab to have the weather updated periodically, eg.:
# echo '*/5 * * * * /root/weather_ssid.sh' >> /etc/crontabs/root && /etc/init.d/cron restart

if iwinfo phy0 assoclist | head | grep "No station connected"; then
        wget http://wttr.in/Prague?format="%c+%t+%w+%m" -O weather.txt 2>/dev/null
        SSID=`head weather.txt 2>/dev/null 3>/dev/null || echo "weather station: offline"`
        rm weather.txt
        uci set wireless.@wifi-iface[0].ssid="$SSID"
        uci commit wireless
        wifi up
fi
