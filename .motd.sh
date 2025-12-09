#!/usr/bin/env bash

# synthwave-styled MOTD with host/IP/battery/temp

PINK="\033[38;5;213m"
PURPLE="\033[38;5;99m"
CYAN="\033[38;5;45m"
RESET="\033[0m"

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)
LOLCAT_BIN="$(command -v lolcat || command -v /opt/homebrew/bin/lolcat || true)"
DEFAULT_IFACE=$(route get default 2>/dev/null | awk '/interface:/{print $2}')
LABEL_WIDTH=12
VALUE_WIDTH=0
BORDER=""

rows=()
FONTS=(
  alligator
  alligator2
  avatar
  banner3-D
  big
  bigchief
  block
  bubble
  bubble__
  bubble_b
  crawford
  doom
  epic
  isometric1
  larry3d
  lean
  ogre
  roman
  slant
  small
  smkeyboard
  speed
  standard
  starwars
)

add_row() {
  local label="$1" value="$2"
  [ -z "$value" ] && return
  rows+=("${label}:::${value}")
}

get_ip() {
  local iface ip
  iface=${DEFAULT_IFACE}
  if [ -n "$iface" ]; then
    ip=$(ipconfig getifaddr "$iface" 2>/dev/null)
  fi
  echo "${ip:-127.0.0.1}"
}

get_battery() {
  local batt
  batt=$(pmset -g batt 2>/dev/null | awk 'NR==2 {gsub(/;/,""); printf "%s %s", $3, $4}')
  echo "${batt:-n/a}"
}

get_disk_root() {
  local line
  line=$(df -h / 2>/dev/null | awk 'NR==2 {printf "%s free / %s", $4, $2}')
  echo "${line:-n/a}"
}

get_git_info() {
  local root branch
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  echo "$(basename "$root") @ $branch"
}

choose_font() {
  local font="univers"
  if [ "${#FONTS[@]}" -gt 0 ]; then
    if command -v shuf >/dev/null 2>&1; then
      font=$(printf '%s\n' "${FONTS[@]}" | shuf -n1)
    elif command -v gshuf >/dev/null 2>&1; then
      font=$(printf '%s\n' "${FONTS[@]}" | gshuf -n1)
    else
      local idx=$(( RANDOM % ${#FONTS[@]} ))
      font="${FONTS[$idx]}"
    fi
  fi
  echo "$font"
}

HOSTNAME=$(hostname)
IP=$(get_ip)
OS=$(sw_vers -productName 2>/dev/null || uname -s)
OS_VER=$(sw_vers -productVersion 2>/dev/null || uname -r)
TIME_STR=$(date +'%H:%M:%S %Z')
DATE_STR=$(date +'%Y-%m-%d')
UPTIME_STR=$(uptime -p 2>/dev/null || uptime)
UPTIME_STR=${UPTIME_STR#up }
UPTIME_STR=${UPTIME_STR%, load averages:*}
UPTIME_STR=${UPTIME_STR%, load average:*}
LOAD=$(uptime | awk -F'load averages?: ' '{print $2}' | sed 's/^[[:space:]]*//')
BATTERY=$(get_battery)
DISK=$(get_disk_root)
GITINFO=$(get_git_info)

add_row "System" "$OS"
add_row "Version" "$OS_VER"
add_row "Host/IP" "$HOSTNAME / ${IP}"
add_row "Battery" "$BATTERY"
add_row "Disk" "$DISK"
add_row "Git" "$GITINFO"
add_row "Time" "$TIME_STR"
add_row "Date" "$DATE_STR"
add_row "Uptime" "$UPTIME_STR"
add_row "Load avg" "$LOAD"

# determine dynamic widths
max_val_len=0
for entry in "${rows[@]}"; do
  val=${entry#*:::}
  (( ${#val} > max_val_len )) && max_val_len=${#val}
done
VALUE_WIDTH=$(( max_val_len < 36 ? 36 : max_val_len ))
printf -v sample_row "/* %-${LABEL_WIDTH}s --- %-${VALUE_WIDTH}s */" "" ""
ROW_LEN=${#sample_row}
STAR_COUNT=$(( ROW_LEN - 4 ))
printf -v BORDER '%*s' "$STAR_COUNT" ''
BORDER=${BORDER// /*}

divider() {
  printf "%b/*%b%s%b*/%b\n" "$PINK" "$CYAN" "$BORDER" "$PINK" "$RESET"
}

row() {
  printf "%b/*%b %-*s %b---%b %-${VALUE_WIDTH}s %b*/%b\n" \
    "$PINK" "$CYAN" "$LABEL_WIDTH" "$1" "$PURPLE" "$CYAN" "$2" "$PINK" "$RESET"
}

if command -v artii >/dev/null 2>&1; then
  FONT=$(choose_font)
  if [ -n "$LOLCAT_BIN" ]; then
    artii -f "$FONT" 'Welcome!' 2>/dev/null | "$LOLCAT_BIN" -a -d 6 || artii -f univers 'Welcome!' | "$LOLCAT_BIN" -a -d 6
  else
    artii -f "$FONT" 'Welcome!' 2>/dev/null || artii -f univers 'Welcome!'
  fi
fi

divider
for entry in "${rows[@]}"; do
  key=${entry%%:::*}
  val=${entry#*:::}
  row "$key" "$val"
done
divider

if command -v fortune >/dev/null 2>&1 && command -v cowsay >/dev/null 2>&1; then
  fortune -n 20 linuxcookie computers science work wisdom ascii-art | cowsay -f llama
fi
