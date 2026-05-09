if status is-interactive
    set -U fish_greeting ''
end

if test -z "$DISPLAY" -a (tty) = /dev/tty1
    exec startx
end
