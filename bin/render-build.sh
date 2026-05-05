#!/usr/bin/env bash
# exit on error
set -o errexit

# 1. Install JS dependencies
yarn install

# 2. Build your React assets
yarn build

# 3. Handle your vendor bundles
chmod +x ./css_vendor_bundle.sh
chmod +x ./js_vendor_bundle.sh
./css_vendor_bundle.sh
./js_vendor_bundle.sh

# 4. Standard Rails build
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean