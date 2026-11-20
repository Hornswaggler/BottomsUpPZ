#!/usr/bin/env bash
set -euo pipefail

if (( $# < 1 )); then
    echo "Usage: $0 metadata.json [KEY=value|KEY=@file.txt ...]" >&2
    exit 2
fi

json_file="$1"
shift
declare -a replacement_keys=()
declare -a replacement_values=()

while (( $# )); do
    pair="$1"
    shift

    if [[ "$pair" != *=* ]]; then
        echo "Error: Expected KEY=value, got '$pair'." >&2
        exit 2
    fi

    key="${pair%%=*}"
    value="${pair#*=}"

    if [[ ! "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
        echo "Error: Invalid token key '$key'." >&2
        exit 2
    fi

    if [[ "$value" == @@* ]]; then
        value="${value#@}"
    elif [[ "$value" == @* ]]; then
        value_file="${value#@}"
        if [[ ! -f "$value_file" || ! -r "$value_file" ]]; then
            echo "Error: Value file '$value_file' is missing or unreadable." >&2
            exit 1
        fi

        value="$(cat -- "$value_file" && printf '\001')"
        value="${value%$'\001'}"
    fi

    replacement_keys+=("$key")
    replacement_values+=("$value")
done

if [[ ! -f "$json_file" || ! -r "$json_file" ]]; then
    echo "Error: Metadata file '$json_file' is missing or unreadable." >&2
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required to read '$json_file'." >&2
    exit 1
fi

if ! jq -e 'type == "object"' "$json_file" >/dev/null; then
    echo "Error: Metadata file '$json_file' must contain a valid JSON object." >&2
    exit 1
fi

quote_vdf() {
    local value="$1"
    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    printf '"%s"' "$value"
}

output_file="${json_file%.*}.vdf"
mapfile -t encoded_keys < <(jq -c 'keys_unsorted[]' "$json_file")

{
    printf '"workshopitem"\n'
    printf '{\n'

    for encoded_key in "${encoded_keys[@]}"; do
        encoded_key="${encoded_key//$'\r'/}"
        key="$(jq -nj --arg encoded_key "$encoded_key" '$encoded_key | fromjson' && printf '\001')"
        key="${key%$'\001'}"

        if ! jq -e --arg key "$key" '.[$key] | type == "string"' "$json_file" >/dev/null; then
            echo "Error: Metadata field '$key' must be a string in '$json_file'." >&2
            exit 1
        fi

        value="$(jq -r -j --arg key "$key" '.[$key]' "$json_file" && printf '\001')"
        value="${value%$'\001'}"

        for index in "${!replacement_keys[@]}"; do
            marker="{{${replacement_keys[$index]}}}"
            replacement="${replacement_values[$index]}"
            value="${value//"$marker"/$replacement}"
        done


        printf '  %s  %s\n' "$(quote_vdf "$key")" "$(quote_vdf "$value")"
    done

    printf '}\n'
} > "$output_file"