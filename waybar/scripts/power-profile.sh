#!/usr/bin/env bash
profile=$(powerprofilesctl get)

case "$profile" in
    performance) text="performance" ;;
    balanced)    text="balanced" ;;
    power-saver) text="low" ;;
    *)           text="$profile" ;;
esac

echo "{\"text\": \"$text\", \"tooltip\": \"Power profile: $profile\", \"class\": \"$profile\"}"
