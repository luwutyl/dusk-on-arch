#!/bin/bash

# Минимальный символ теперь ▂ вместо пробела
bars=("▂" "▂" "▃" "▄" "▅" "▆" "▇" "█")

# Цвета для dusk
LOW="^c#98be65^"
MID="^c#ecbe7b^"
HIGH="^c#ff6c6b^"

CACHE="/tmp/cpu_bars_stat"
curr_stat=$(grep '^cpu[0-9]' /proc/stat)

if [ -f "$CACHE" ]; then
  prev_stat=$(cat "$CACHE")
  output=""

  for i in {0..7}; do
    j=$((i + 8))

    read -r _ u1 n1 s1 i1 iow1 irq1 soft1 steal1 _ < <(echo "$curr_stat" | grep -w "cpu$i")
    read -r _ u2 n2 s2 i2 iow2 irq2 soft2 steal2 _ < <(echo "$curr_stat" | grep -w "cpu$j")
    read -r _ pu1 pn1 ps1 pi1 piow1 pirq1 psoft1 psteal1 _ < <(echo "$prev_stat" | grep -w "cpu$i")
    read -r _ pu2 pn2 ps2 pi2 piow2 pirq2 psoft2 psteal2 _ < <(echo "$prev_stat" | grep -w "cpu$j")

    idle=$(((i1 + iow1 + i2 + iow2) - (pi1 + piow1 + pi2 + piow2)))
    total=$(((u1 + n1 + s1 + i1 + iow1 + irq1 + soft1 + steal1 + u2 + n2 + s2 + i2 + iow2 + irq2 + soft2 + steal2) - (pu1 + pn1 + ps1 + pi1 + piow1 + pirq1 + psoft1 + psteal1 + pu2 + pn2 + ps2 + pi2 + piow2 + pirq2 + psoft2 + psteal2)))

    # Защита от деления на ноль
    ((total == 0)) && total=1
    usage=$((100 * (total - idle) / total))

    [[ $usage -lt 30 ]] && color=$LOW
    [[ $usage -ge 30 && $usage -lt 70 ]] && color=$MID
    [[ $usage -ge 70 ]] && color=$HIGH

    # Рассчитываем индекс (0-7)
    idx=$((usage * 7 / 100))
    output+="${color}${bars[$idx]}"
  done
  echo -e "$output^d^"
fi

echo "$curr_stat" >"$CACHE"
