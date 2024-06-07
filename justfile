default: install-flutter get-deps gen-code

set windows-shell := ["pwsh.exe", "-NoProfile", "-c"]

##
# Basic commands
##

install-flutter:
  fvm install -s --skip-pub-get

get-deps:
  fvm flutter pub get

gen-code:
  fvm dart run build_runner build --delete-conflicting-outputs

##
# Watching
##

watch-bridge:
  flutter_rust_bridge_codegen generate --watch

watch-code:
  fvm dart run build_runner watch --delete-conflicting-outputs

##
# Building
##

[windows]
build:
  fvm flutter build windows --release

[linux]
build:
  fvm flutter build linux --release

[macos]
build:
  fvm flutter build macos --release

build-web:
  fvm flutter build web

build-wasm:
  fvm flutter build web --wasm

test:
  fvm flutter test

##
# Other commands
##

lint:
  fvm flutter analyze

show-outdated:
  fvm flutter pub outdated

upgrade-deps:
  fvm flutter pub upgrade
