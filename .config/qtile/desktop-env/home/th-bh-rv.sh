xrandr \
  --output eDP-1 --off \
  --output DP-1-3 --mode 3840x1080 --primary --pos 0x0 \
  --output HDMI-1-0 --mode 1920x1080 --pos 0x1080
#  --output DP-1-1 --mode 1920x1080 --rotate left --pos 3840x1080
#exec qtile start --config /home/kevin/.config/qtile/desktop-env/home/config-th-bh-rv.py
exec qtile start --config /home/kevin/.config/qtile/desktop-env/home/config-th-bh.py
