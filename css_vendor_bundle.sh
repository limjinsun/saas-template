#!/usr/bin/env bash
set -euo pipefail

mkdir -p vendor/cdn_css
OUT_DIR="app/assets/vendor"
mkdir -p "$OUT_DIR"

URL_FLOWBITE="https://cdn.jsdelivr.net/npm/flowbite@4.0.0/dist/flowbite.min.css"
URL_DATEPICKER="https://cdn.jsdelivr.net/npm/flowbite-datepicker@1.3.2/dist/css/datepicker.min.css"
URL_TOASTR="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css"

dl () {
  local url="$1"
  local file="$2"
  echo "Downloading: $url"
  curl -L --fail --silent --show-error "$url" -o "vendor/cdn_css/$file"
}

dl "$URL_FLOWBITE"   "flowbite.min.css"
dl "$URL_DATEPICKER" "datepicker.min.css"
dl "$URL_TOASTR"     "toastr.min.css"

BUNDLE="$OUT_DIR/vendor.bundle.css"
cat > "$BUNDLE" <<'HEADER'
/*!
 * vendor.bundle.css
 * Bundled from CDN downloads.
 * Check each library’s license in its original header/source.
 */
HEADER

append () {
  local file="$1"
  echo -e "\n\n/* ===== $file ===== */\n" >> "$BUNDLE"
  cat "vendor/cdn_css/$file" >> "$BUNDLE"
}

# EXACT ORDER (as per your list)
append "flowbite.min.css"
append "datepicker.min.css"
append "toastr.min.css"

echo "✅ Built: $BUNDLE"
