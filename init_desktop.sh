xrandr --output HDMI1 --auto --scale 1.5x1.5 --right-of eDP1
feh --no-fehbg --bg-scale ~/.config/background
~/.config/polybar/launch.sh

# set keyboard layout of mech to eu
xinput | grep -w 'SONiX USB DEVICE ' | awk '{print $5}' | tr '=' ' ' | awk '{print $2}' | xargs -I{} setxkbmap -device {} eu
