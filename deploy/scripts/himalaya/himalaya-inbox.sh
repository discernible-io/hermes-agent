#!/bin/sh
# List INBOX with sender email addresses (plain table omits addr).
# Usage: sh scripts/himalaya-inbox.sh [PAGE_SIZE]
set -eu
PAGE_SIZE="${1:-10}"
himalaya envelope list --folder INBOX --page-size "$PAGE_SIZE" --output json | node -e '
const rows = JSON.parse(require("fs").readFileSync(0, "utf8"));
if (!Array.isArray(rows) || rows.length === 0) {
  console.log("INBOX is empty");
  process.exit(0);
}
for (const e of rows) {
  const from = e.from?.addr || "?";
  const name = e.from?.name || "";
  console.log(`ID ${e.id}\t${from}\t${name}\t${e.subject}\t${e.date || ""}`);
}
'
