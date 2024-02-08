# This sets the keyboard layout to German (de) for a 
# specific X input device (the barrier virtual keyboard). 

fix_barrier_keymap() {
    device_id=$(xinput list | \
                grep "Virtual core XTEST keyboard" | \
                sed -e 's/.\+=\([0-9]\+\).\+/\1/')
    setxkbmap -device $device_id de
}
