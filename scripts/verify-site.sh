#!/bin/sh
set -eu

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

check_file() {
  [ -s "$1" ] || fail "$1 is missing or empty"
}

check_no_matches() {
  pattern="$1"
  shift

  if matches=$(grep -R -n "$pattern" "$@" 2>/dev/null); then
    printf '%s\n' "$matches" >&2
    fail "unexpected pattern found: $pattern"
  fi
}

check_file "index.html"
check_file "lyrics/index.html"
check_file "styles.css"
check_file "CNAME"
check_file "assets/images/glass-and-thorns-logo.png"
check_file "assets/images/glass-and-thorns-logo-text.png"
check_file "assets/images/glass-and-thorns-cover.png"

check_no_matches 'href="#"' index.html lyrics/index.html
check_no_matches 'datetime="2026-00-00"' index.html lyrics/index.html
check_no_matches 'target="_blank"' index.html lyrics/index.html
check_no_matches 'Glass & Thorns' index.html lyrics/index.html
check_no_matches 'border-radius: 24px' styles.css lyrics/index.html
check_no_matches 'aspect-ratio: 1 / 1' styles.css

printf 'Static site checks passed.\n'
