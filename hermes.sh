#!/usr/bin/env bash
# Repo-root forwarder for Podman operator commands (start/stop/status/…).
# Implementation lives in deploy/hermes.sh — keep using that path, or call this.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$ROOT/deploy/hermes.sh" "$@"
