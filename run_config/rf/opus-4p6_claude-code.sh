#!/bin/bash
set -euo pipefail

# Load credentials
set -a
source "$(dirname "$0")/../../.env"
set +a

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HARBOR_BIN="${HARBOR_BIN:-harbor}"
: "${HARBOR_AGENT_ALLOWED_HOST:?Set HARBOR_AGENT_ALLOWED_HOST in .env}"

"${HARBOR_BIN}" run \
  -p ./data/rf \
  -a claude-code \
  -m "anthropic/claude-opus-4-6" \
  -e modal \
  --ek modal_vm_runtime=true \
  -k 3 \
  -n 24 \
  --ak reasoning_effort=high \
  --ak disallowed_tools=WebSearch,WebFetch \
  --allow-agent-host "${HARBOR_AGENT_ALLOWED_HOST}" \
  -o results/rf/ \
  --job-name "opus-4p6_claude-code"
