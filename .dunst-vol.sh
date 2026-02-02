#!/bin/sh
#!/bin/bash

# Получаем текущий уровень громкости
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | cut -d. -f1)
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oE '\[(ON|OFF)\]' | tr -d '[]')

# Если звук выключен
if [ "$MUTED" = "OFF" ]; then
  dunstify -a "Volume" -u low -r 9999 -i audio-volume-muted -t 1000 "Volume: Muted"
  exit 0
fi

# Формируем полоску громкости
BAR=$(seq -s "─" $(($VOLUME / 5)) | sed 's/[0-9]//g')

# Отправляем уведомление
dunstify -a "Volume" -u low -r 9999 -i audio-volume-high -t 1000 "Volume: $VOLUME% [$BAR]"
