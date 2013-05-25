if [ "$ACTION" = "pressed" -a "$BUTTON" = "BTN_2" ]; then
        for dir in /var/run/hostapd-*; do
                [ -d "$dir" ] || continue
                logger "WPS button active: $dir"
                hostapd_cli -p "$dir" wps_pbc
        done
  echo 1 > /sys/class/leds/hg255d\:wps/brightness
  echo heartbeat > /sys/class/leds/hg255d\:wps/trigger
  sleep 10
  echo 0 > /sys/class/leds/hg255d\:wps/brightness

fi
