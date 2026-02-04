#!/bin/sh

title=$(playerctl metadata | grep title | awk '{for(i=3; i<=NF; i++) printf "%s%s", $i, (i==NF ? ORS : OFS)}')
album=$(playerctl metadata | grep album | awk '{for(i=3; i<=NF; i++) printf "%s%s", $i, (i==NF ? ORS : OFS)}')
artist=$(playerctl metadata | grep artist | awk '{for(i=3; i<=NF; i++) printf "%s%s", $i, (i==NF ? ORS : OFS)}')
art=$(playerctl metadata | grep artUrl | awk '{for(i=3; i<=NF; i++) printf "%s%s", $i, (i==NF ? ORS : OFS)}' | sed 's|file://||')

dunstify -a "metadata" -u low -i $art -r 9999 -t 5000 "Title:  $title
Album:  $album
Artist: $artist"
