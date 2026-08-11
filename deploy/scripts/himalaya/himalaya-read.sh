#!/bin/sh
# Read full message (headers + body).
# Usage: sh scripts/himalaya-read.sh <ID>
set -eu
ID="${1:?usage: himalaya-read.sh <ID>}"
himalaya message read "$ID" --output plain
