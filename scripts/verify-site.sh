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

# Assert source-level accessibility baseline as well as brand/content checks.
grep -q 'class="skip-link" href="#top"' index.html || fail "Homepage skip link missing"
grep -q 'id="top" tabindex="-1"' index.html || fail "Main skip target not focusable"
grep -q 'focus-visible' styles.css || fail "Visible keyboard focus style missing"
grep -q 'prefers-reduced-motion' styles.css || fail "Reduced-motion style missing"

check_file "robots.txt"
check_file "sitemap.xml"
grep -Fq 'rel="canonical" href="https://glassandthorns.art/"' index.html || fail "Homepage canonical URL missing"
grep -Fq 'rel="canonical" href="https://glassandthorns.art/lyrics/"' lyrics/index.html || fail "Lyrics canonical URL missing"
grep -Fq 'Sitemap: https://glassandthorns.art/sitemap.xml' robots.txt || fail "robots.txt sitemap declaration missing"
python3 -c '
import xml.etree.ElementTree as ET
root = ET.parse("sitemap.xml").getroot()
ns = "{http://www.sitemaps.org/schemas/sitemap/0.9}"
urls = [v.text for v in root.findall(f"{ns}url/{ns}loc")]
assert urls == ["https://glassandthorns.art/", "https://glassandthorns.art/lyrics/"], urls
'

printf 'Static site checks passed.\n'
