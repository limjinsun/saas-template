#!/usr/bin/env bash
set -euo pipefail

mkdir -p vendor/cdn
OUT_DIR="app/assets/vendor"
mkdir -p "$OUT_DIR"

URL_TURBO="https://cdn.jsdelivr.net/npm/@hotwired/turbo@8.0.20/dist/turbo.es2017-umd.min.js"
URL_TAILWIND="https://cdn.tailwindcss.com"
URL_ALPINE="https://unpkg.com/alpinejs"
URL_FLOWBITE_TURBO="https://cdn.jsdelivr.net/npm/flowbite@4.0.0/dist/flowbite.turbo.min.js"
URL_DATEPICKER="https://cdn.jsdelivr.net/npm/flowbite-datepicker@1.3.2/dist/js/datepicker-full.min.js"
URL_RAILS_UJS="https://cdn.jsdelivr.net/npm/@rails/ujs@7.1.3-4/app/assets/javascripts/rails-ujs.min.js"
URL_JQUERY="https://code.jquery.com/jquery-3.7.1.min.js"
URL_TOASTR="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"
URL_JSPDF="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"
URL_AUTOTABLE="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.4/jspdf.plugin.autotable.min.js"

dl () {
  local url="$1"
  local file="$2"
  echo "Downloading: $url"
  curl -L --fail --silent --show-error "$url" -o "vendor/cdn/$file"
}

dl "$URL_TURBO"        "turbo.es2017-umd.min.js"
dl "$URL_TAILWIND"     "tailwindcdn.js"
dl "$URL_ALPINE"       "alpine.js"
dl "$URL_FLOWBITE_TURBO" "flowbite.turbo.min.js"
dl "$URL_DATEPICKER"   "datepicker-full.min.js"
dl "$URL_RAILS_UJS"    "rails-ujs.min.js"
dl "$URL_JQUERY"       "jquery-3.7.1.min.js"
dl "$URL_TOASTR"       "toastr.min.js"
dl "$URL_JSPDF"        "jspdf.umd.min.js"
dl "$URL_AUTOTABLE"    "jspdf.plugin.autotable.min.js"

BUNDLE="$OUT_DIR/vendor.bundle.js"
cat > "$BUNDLE" <<'HEADER'
/*!
 * vendor.bundle.js
 * Bundled from CDN downloads.
 * Check each library’s license in its original header/source.
 */
HEADER

append () {
  local file="$1"
  echo -e "\n\n/* ===== $file ===== */\n" >> "$BUNDLE"
  cat "vendor/cdn/$file" >> "$BUNDLE"
}

# EXACT ORDER (as per your list)
append "turbo.es2017-umd.min.js"
append "tailwindcdn.js"
append "alpine.js"
append "flowbite.turbo.min.js"
append "datepicker-full.min.js"
append "rails-ujs.min.js"
append "jquery-3.7.1.min.js"
append "toastr.min.js"
append "jspdf.umd.min.js"
append "jspdf.plugin.autotable.min.js"

echo "✅ Built: $BUNDLE"
