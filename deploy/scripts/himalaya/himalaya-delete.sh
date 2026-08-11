#!/bin/sh
# Delete message(s) by envelope ID, or all INBOX messages with --all.
# Usage: sh scripts/himalaya-delete.sh <ID>...
#        sh scripts/himalaya-delete.sh --all
set -eu

if [ "$#" -eq 1 ] && [ "$1" = "--all" ]; then
  ids=$(himalaya envelope list --folder INBOX --output json | node -e '
    const items = JSON.parse(require("fs").readFileSync(0, "utf8"));
    if (!Array.isArray(items) || items.length === 0) process.exit(0);
    process.stdout.write(items.map((e) => e.id).join(" "));
  ')
  if [ -z "$ids" ]; then
    echo "No messages in INBOX"
    exit 0
  fi
  # shellcheck disable=SC2086
  set -- $ids
fi

if [ "$#" -eq 0 ]; then
  echo "usage: himalaya-delete.sh <ID>... | --all" >&2
  exit 1
fi

himalaya message delete "$@"
