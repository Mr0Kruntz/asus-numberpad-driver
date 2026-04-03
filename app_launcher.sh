#!/usr/bin/env bash

# ==========================================
# WAYLAND GUI BYPASS
# ==========================================
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export WAYLAND_DISPLAY=wayland-0
export DISPLAY=:0

# The hidden file where we will save your choice
CONFIG_FILE="$HOME/.numpad_app_choice"

# ==========================================
# 1. CHECK FOR SAVED APP (First-time setup)
# ==========================================
if [ ! -f "$CONFIG_FILE" ]; then
  # If the file DOES NOT exist, show the kdialog menu
  CHOICE=$(kdialog --title "Numpad Quick Launch" --menu "Select the default app to toggle:" \
    "konsole" "Terminal (Konsole)" \
    "firefox" "Web Browser (Firefox)" \
    "dolphin" "File Manager (Dolphin)")

  # If the user clicks Cancel, exit silently
  if [ -z "$CHOICE" ]; then
    exit 0
  fi

  # Save the chosen app to the hidden text file
  echo "$CHOICE" > "$CONFIG_FILE"
else
  # If the file DOES exist, read the saved app name from it
  CHOICE=$(cat "$CONFIG_FILE")
fi

# ==========================================
# 2. THE TOGGLE LOGIC (Open / Close)
# ==========================================
# Check if the chosen app is currently running
if ! pgrep -x "$CHOICE" >/dev/null 2>&1; then
  # If NOT running, launch it
  systemd-run --user --no-block /usr/bin/$CHOICE >/dev/null 2>&1
else
  # If IS running, force close it
  killall "$CHOICE" >/dev/null 2>&1
fi
