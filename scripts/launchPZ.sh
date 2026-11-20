#!/usr/bin/env bash
cd "/c/Program Files (x86)/Steam/steamapps/common/ProjectZomboid" || exit 1

case "${1:-}" in
    "debug")
        ./ProjectZomboid64.exe -Xmx4096m -Xms4096m -- -debug &
        ;;
    "nosteam")
        ./ProjectZomboid64.exe -Xmx4096m -Xms4096m -- -nosteam &
        ;;
    "debug_nosteam")
        ./ProjectZomboid64.exe -Xmx4096m -Xms4096m -- -debug -nosteam &
        ;;
esac
