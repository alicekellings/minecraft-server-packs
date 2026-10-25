#!/usr/bin/env bash
# ===========================================================================
#  SkyBlock Menus Lite - start.sh (Linux / macOS)
#
#  If the server dies immediately with an out-of-memory error, lower MAX_RAM.
#  Leave at least 1 GB for the OS itself.
# ===========================================================================
set -uo pipefail
cd "$(dirname "$0")"

MIN_RAM="1G"
MAX_RAM="4G"

# Prefer the portable runtime the installer fetches when the machine has no Java.
JAVA_BIN="$(command -v java || true)"
if [ -x "./runtime/bin/java" ]; then JAVA_BIN="./runtime/bin/java"; fi
if [ -z "$JAVA_BIN" ]; then
  echo
  echo "  Java 25 is missing. Run  bash install.sh  again - it downloads a portable Java."
  echo "  Or install Java 25: https://adoptium.net/temurin/releases/?version=25"
  exit 1
fi

if [ ! -f server.jar ]; then
  echo
  echo "  server.jar is missing. Run  bash install.sh  first."
  echo
  exit 1
fi

if ! grep -q "^eula=true" eula.txt 2>/dev/null; then
  echo
  echo "  ============================================================"
  echo "   Minecraft EULA"
  echo "  ============================================================"
  echo
  echo "   Accept it to run this server: https://aka.ms/MinecraftEULA"
  echo
  printf "  Type YES to accept, or press Enter to quit: "
  read -r eula_answer
  if [ "$eula_answer" != "YES" ]; then
    echo
    echo "  EULA not accepted - nothing was started."
    exit 1
  fi
  echo "eula=true" > eula.txt
  echo
  echo "  EULA accepted. Starting the server..."
  echo
fi

JVM_FLAGS=(
  -Xms"$MIN_RAM"
  -Xmx"$MAX_RAM"
  -XX:+UseG1GC
  -XX:+ParallelRefProcEnabled
  -XX:MaxGCPauseMillis=200
  -XX:+UnlockExperimentalVMOptions
  -XX:+DisableExplicitGC
  -XX:+AlwaysPreTouch
  -XX:G1NewSizePercent=30
  -XX:G1MaxNewSizePercent=40
  -XX:G1HeapRegionSize=8M
  -XX:G1ReservePercent=20
  -XX:G1HeapWastePercent=5
  -XX:G1MixedGCCountTarget=4
  -XX:InitiatingHeapOccupancyPercent=15
  -XX:G1MixedGCLiveThresholdPercent=90
  -XX:G1RSetUpdatingPauseTimePercent=5
  -XX:SurvivorRatio=32
  -XX:+PerfDisableSharedMem
  -XX:MaxTenuringThreshold=1
  -Dusing.aikars.flags=https://mcflags.emc.gs
  -Daikars.new.flags=true
)

exec "$JAVA_BIN" "${JVM_FLAGS[@]}" -jar server.jar nogui
