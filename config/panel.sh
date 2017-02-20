#!/usr/bin/env bash

function hc() {
    herbstclient "$@"
}

monitor=0
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=16

font="pango:DejaVu Sans Mono 7"

bgcolor=$(hc get frame_border_normal_color)
selbg=$(hc get window_border_active_color)
selfg='#101010'

hc pad $monitor $panel_height

{
    (i3status -c /etc/i3/status |
         while read line
         do
             echo $'i3status\t'"$line"
         done
    ) &
    hc --idle
} | {
    IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
    visible=true
    i3status=""
    windowtitle=""
    while true ; do

        ### Output ###
        # This part prints dzen data based on the _previous_ data handling run,
        # and then waits for the next event to happen.

        bordercolor="#26221C"
        separator="^bg()^fg($selbg)|"
        # draw tags
        windowinfo=""
        for i in "${tags[@]}" ; do
            case ${i:0:1} in
                '#')
                    windowinfo="$windowinfo""^bg($selbg)^fg($selfg)"
                    ;;
                '+')
                    windowinfo="$windowinfo""^bg(#9CA668)^fg(#141414)"
                    ;;
                ':')
                    windowinfo="$windowinfo""^bg()^fg(#ffffff)"
                    ;;
                '!')
                    windowinfo="$windowinfo""^bg(#FF0675)^fg(#141414)"
                    ;;
                *)
                    windowinfo="$windowinfo""^bg()^fg(#ababab)"
                    ;;
            esac
            windowinfo="$windowinfo"" ${i:1} "
        done
        # windowinfo="^bg()^fg() ${windowtitle//^/^^}""$separator""$windowinfo"
        echo -n "$windowinfo"
        # small adjustments
        right="$separator^bg() $i3status $separator"
        echo -n "$right"
        echo
        ### Data handling ###
        # This part handles the events generated in the event loop, and sets
        # internal variables based on them. The event and its arguments are
        # read into the array cmd, then action is taken depending on the event
        # name.
        # "Special" events (quit_panel/togglehidepanel/reload) are also handled
        # here.
        # wait for next event
        IFS=$'\t' read -ra cmd || break
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
                ;;
            i3status)
                i3status="${cmd[@]:1}"
                ;;
            quit_panel)
                exit
                ;;
            togglehidepanel)
                currentmonidx=$(hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
                if [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    hc pad $monitor 0
                else
                    visible=true
                    hc pad $monitor $panel_height
                fi
                ;;
            reload)
                exit
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
            #player)
            #    ;;
        esac
    done
    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.
} |
    dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height \
    -ta c -bg "$bgcolor" -fg '#efefef'
