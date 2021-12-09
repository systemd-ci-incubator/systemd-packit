#!/bin/bash
# shellcheck disable=SC2064

set -eu
set -o pipefail

EC=0
TEMPFILE="$(mktemp)"
trap "rm -f '$TEMPFILE'" EXIT

for ((i = 0; i < 3; i++)); do
    EC=0
    (sudo python3 -m mkosi "$@") |& tee "$TEMPFILE" || EC=$?
    if [[ $EC -eq 0 ]]; then
        # The command passed - let's return immediatelly
        break
    fi

    if ! grep -E "Failed to dissect image .+: Connection timed out" "$TEMPFILE"; then
        # The command failed for other reason than the dissect-related timeout -
        # let's exit with the same EC
        exit $EC
    fi

    # The command failed due to the dissect-related timeout - let's try again
done

exit $EC
